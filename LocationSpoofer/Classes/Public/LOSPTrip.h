//
//  LOSPTrip.h
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

#import <CoreLocation/CoreLocation.h>
#import "LOSPLocationProvider.h"

@class MKPolyline;
@class LOSPTrip;

typedef void (^LOSPGeocodeTripCompletion)(LOSPTrip * _Nullable, NSError * _Nullable);

/**
 * Represents a moving location, with a given duration.
 */
NS_SWIFT_NAME(Trip)
@interface LOSPTrip : NSObject <LOSPLocationProvider>

/**
 * Initializes a Trip object.
 *
 * @param coordinates The sequence of coordinates
 * @param coordinateCount The number of coordinates
 * @param duration The duration of the entire trip in seconds
 */
- (instancetype)initWithCoordinates:(CLLocationCoordinate2D *)coordinates coordinateCount:(NSUInteger)coordinateCount duration:(NSTimeInterval)duration NS_DESIGNATED_INITIALIZER;

/**
 * Convenience factory method for generating a Trip object using a start address and end address.
 * This uses MapKit's geocoding API to convert address strings into coordinates, thus
 * (a) this method is async. Completion is called on the main queue
 * (b) check for errors in the completion block
 *
 * @param startAddress The start address
 * @param endAddress The end address
 * @param duration The duration of the entire trip in seconds
 * @param completion The completion handler. This is called on the main queue
 */
+ (void)getTripWithStartAddress:(nonnull NSString *)startAddress endAddress:(nonnull NSString *)endAddress duration:(NSTimeInterval)duration completion:(nonnull LOSPGeocodeTripCompletion)completion;

/**
 * Use getWithStartAddress(_:endAddress:duration:completion:) to fetch instances of this class.
 */
- (null_unspecified instancetype)init NS_UNAVAILABLE;

@property (nonatomic, nonnull, readonly) MKPolyline *polyline;

@end
