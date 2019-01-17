//
//  LOSPLocationSpoofer.m
//
//  Copyright © 2019 Buglife, Inc. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

#import "LOSPLocationSpoofer.h"
#import "LOSPSwizzler.h"
#import "LOSPTrip.h"
#import "LOSPLocationProvider.h"
#import <CoreLocation/CoreLocation.h>

@interface LOSPLocationSpoofer ()

@property (nonatomic, nonnull) dispatch_queue_t workQueue;
@property (nonatomic, nullable) id<LOSPLocationProvider> unsafeLocationProvider;  // named `unsafe` because it should only be accessed on `workQueue`

@end

@implementation LOSPLocationSpoofer

@dynamic sharedSpoofer;
@dynamic location;

+ (nonnull instancetype)sharedSpoofer
{
    static LOSPLocationSpoofer *gSharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        gSharedInstance = [[self alloc] initPrivate];
    });
    return gSharedInstance;
}

- (instancetype)initPrivate
{
    self = [super init];
    if (self) {
        _workQueue = dispatch_queue_create("LOSPLocationSpoofer.workQueue", DISPATCH_QUEUE_CONCURRENT);
    }
    return self;
}

- (void)setLocation:(nullable id<LOSPLocationProvider>)location
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self _swizzleLocation];
        [self _swizzleLocationManagerDidUpdateLocations];
    });
    
    dispatch_barrier_sync(_workQueue, ^{
        self.unsafeLocationProvider = location;
    });
}

- (void)_swizzleLocation
{
    LOSPLocationSpoofer *spoofer = self;
    Class cls = [CLLocationManager class];
    SEL selector = @selector(location);
    
    __block IMP originalIMP =
    LOSPReplaceMethodWithBlock(cls, selector, (CLLocation *)^(CLLocationManager *_self) {
        CLLocation *result;
        id<LOSPLocationProvider> locationProvider = [spoofer _syncGetLocationProvider];
        CLLocation *location = [locationProvider locationAtTimestamp:[NSDate date]];
        
        if (location) {
            result = location;
        } else {
            result = ((CLLocation * ( *)(id, SEL))originalIMP)(_self, selector);
        }
        
        return result;
    });
}

- (void)_swizzleLocationManagerDidUpdateLocations
{
    Protocol *protocol = @protocol(CLLocationManagerDelegate);
    SEL selector = @selector(locationManager:didUpdateLocations:);
    NSArray<Class> *classes = LOSPGetClassesAdoptingProtocol(protocol);
    LOSPLocationSpoofer *spoofer = self;
    
    for (Class cls in classes) {
        if (![cls instancesRespondToSelector:selector]) {
            continue;
        }
        
        __block IMP originalIMP =
        LOSPReplaceMethodWithBlock(cls, selector, ^(NSObject *_self, CLLocationManager *manager, NSArray<CLLocation *> *actualLocations) {
            
            NSArray *spoofedLocations;
            id<LOSPLocationProvider> locationProvider = [spoofer _syncGetLocationProvider];
            CLLocation *location = [locationProvider locationAtTimestamp:[NSDate date]];
            
            if (location) {
                spoofedLocations = @[location];
            } else {
                spoofedLocations = actualLocations;
            }
            
            ((void ( *)(id, SEL, CLLocationManager *, NSArray<CLLocation *> *))originalIMP)(_self, selector, manager, spoofedLocations);
        });
    }
}

- (nullable id<LOSPLocationProvider>)_syncGetLocationProvider
{
    __block id<LOSPLocationProvider> result;
    
    dispatch_sync(_workQueue, ^{
        result = self.unsafeLocationProvider;
    });
    
    return result;
}

@end
