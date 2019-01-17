//
//  CLLocation+LOSPAdditions.m
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

#import "CLLocation+LOSPAdditions.h"
#import "CLPlacemark+LOSPAdditions.h"

const CLLocationCoordinate2D CLLocationCoordinate2DAlcatraz = { 37.825944, -122.422398 };

const CLLocationCoordinate2D CLLocationCoordinate2DEasterIsland = { -27.105361, -109.332320 };

@implementation CLLocation (LOSPAdditions)

+ (instancetype)losp_locationWithCoordinate:(CLLocationCoordinate2D)coordinate
{
    return [[CLLocation alloc] initWithCoordinate:coordinate altitude:0 horizontalAccuracy:0 verticalAccuracy:0 timestamp:[NSDate date]];
}

- (CLLocation *)locationAtTimestamp:(NSDate *)timestamp {
    return self;
}

+ (void)losp_getLocationWithAddress:(nonnull NSString *)address completion:(nonnull void (^)(CLLocation * _Nullable, NSError * _Nullable))completion
{
    [CLPlacemark losp_getPlacemarkWithAddress:address completion:^(CLPlacemark * _Nullable placemark, NSError * _Nullable error) {
        completion(placemark.location, error);
    }];
}

@end
