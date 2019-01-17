//
//  LOSPTrip.m
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

#import <MapKit/MapKit.h>
#import "LOSPTrip.h"
#import "MKDirections+LOSPAdditions.h"

@interface LOSPTrip ()

@property (nonatomic, nonnull, readonly) NSDate *startTime;
@property (nonatomic, nonnull, readonly) CLLocationCoordinate2D *coordinates;
@property (nonatomic, readonly) NSUInteger coordinateCount;
@property (nonatomic, readonly) NSTimeInterval duration;

@end

@implementation LOSPTrip

@dynamic polyline;

- (instancetype)initWithCoordinates:(CLLocationCoordinate2D *)coordinates coordinateCount:(NSUInteger)coordinateCount duration:(NSTimeInterval)duration
{
    self = [super init];
    if (self) {
        _startTime = [NSDate date];
        _coordinates = coordinates;
        _coordinateCount = coordinateCount;
        _duration = duration;
    }
    return self;
}

- (nonnull MKPolyline *)polyline
{
    return [MKPolyline polylineWithCoordinates:_coordinates count:_coordinateCount];
}

#pragma - LOSPLocationProvider

- (nullable CLLocation *)locationAtTimestamp:(NSDate *)timestamp {
    NSTimeInterval secondsElapsed = [timestamp timeIntervalSinceDate:_startTime];
    // Assumes the trip restarts itself repeatedly
    NSTimeInterval secondsElapsedSinceRestart = fmod(secondsElapsed, _duration);
    double percentComplete = secondsElapsedSinceRestart / _duration;
    NSUInteger coordinateIndex = ((double)_coordinateCount) * percentComplete;
    
    if (coordinateIndex >= _coordinateCount) {
        coordinateIndex = _coordinateCount - 1;
    }
    
    CLLocationCoordinate2D coordinate = _coordinates[coordinateIndex];
    return [[CLLocation alloc] initWithLatitude:coordinate.latitude longitude:coordinate.longitude];
}

#pragma - Factory methods

+ (void)getTripWithStartAddress:(nonnull NSString *)startAddress endAddress:(nonnull NSString *)endAddress duration:(NSTimeInterval)duration completion:(nonnull LOSPGeocodeTripCompletion)completion
{
    [MKDirections losp_getRouteFromAddress:startAddress toAddress:endAddress completion:^(MKRoute * _Nullable route, NSError * _Nullable error) {
        MKPolyline *polyline = route.polyline;
        
        if (polyline == nil) {
            completion(nil, error);
            return;
        }
        
        NSUInteger pointCount = polyline.pointCount;
        CLLocationCoordinate2D *routeCoordinates = malloc(pointCount * sizeof(CLLocationCoordinate2D));
        [polyline getCoordinates:routeCoordinates range:NSMakeRange(0, pointCount)];
        LOSPTrip *result = [[LOSPTrip alloc] initWithCoordinates:routeCoordinates coordinateCount:pointCount duration:duration];
        completion(result, nil);
    }];
}

@end
