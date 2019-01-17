//
//  LOSPTrip+LOSPPresets.m
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

#import "LOSPTrip+LOSPPresets.h"

@implementation LOSPTrip (LOSPPresets)

+ (nonnull instancetype)lombardStreet
{
    NSTimeInterval duration = 10;
    NSUInteger count = 32;
    const CLLocationCoordinate2D coordinates[32] = { { 37.801644271239645, -122.42207774017521 }, { 37.80177016742526, -122.42126754541445 }, { 37.80178919434547, -122.42120283712194 }, { 37.80187108553946, -122.42067611832653 }, { 37.80199849046767, -122.41961966325056 }, { 37.802013577893376, -122.4195157276512 }, { 37.80208750627934, -122.41942017395502 }, { 37.802101252600536, -122.41937290002113 }, { 37.80208272859453, -122.41931690890792 }, { 37.80200695618984, -122.41923811901808 }, { 37.80200460925696, -122.41918279845714 }, { 37.802035287022576, -122.4191435711503 }, { 37.802138384431615, -122.41907886285779 }, { 37.802144503220916, -122.41902454812524 }, { 37.80205573886631, -122.41892195363036 }, { 37.80204408802091, -122.41886797417393 }, { 37.80206236056983, -122.41882606465808 }, { 37.8021754324436, -122.41875766832817 }, { 37.802181802690036, -122.41874224562633 }, { 37.802179707214236, -122.41868357230413 }, { 37.80209655873475, -122.41859103609309 }, { 37.80208515934647, -122.41854711492047 }, { 37.80210477299989, -122.41850151736719 }, { 37.802192447707064, -122.41845659036619 }, { 37.80222689732909, -122.41840328146202 }, { 37.802216755226254, -122.41834460813979 }, { 37.802138887345784, -122.41826213021253 }, { 37.802127823233604, -122.4182215618012 }, { 37.8021434135735, -122.41817931700919 }, { 37.80220912769437, -122.41811226178382 }, { 37.80219454318285, -122.41796943415375 }, { 37.80230795033277, -122.41708908286344 } };
    CLLocationCoordinate2D *coordsCopy = malloc(sizeof(CLLocationCoordinate2D) * count);
    
    for (int i = 0; i < count; i++) {
        coordsCopy[i] = coordinates[i];
    }
    
    return [[LOSPTrip alloc] initWithCoordinates:coordsCopy coordinateCount:count duration:duration];
}

@end
