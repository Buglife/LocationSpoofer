//
//  MKDirections+LOSPAdditions.m
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

#import "MKDirections+LOSPAdditions.h"
#import "CLPlacemark+LOSPAdditions.h"

@implementation MKDirections (LOSPAdditions)

+ (void)losp_getRouteFromPlacemark:(nonnull CLPlacemark *)fromPlacemark toPlacemark:(nonnull CLPlacemark *)toPlacemark completion:(nonnull LOSPGetRouteHandler)completion
{
    MKDirectionsRequest *request = [[MKDirectionsRequest alloc] init];
    request.source = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithPlacemark:fromPlacemark]];
    request.destination = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithPlacemark:toPlacemark]];
    request.transportType = MKDirectionsTransportTypeAutomobile;
    
    MKDirections *directions = [[MKDirections alloc] initWithRequest:request];
    [directions calculateDirectionsWithCompletionHandler:^(MKDirectionsResponse * _Nullable response, NSError * _Nullable error) {
        MKRoute *route = response.routes.firstObject;
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(route, error);
        });
    }];
}

+ (void)losp_getRouteFromAddress:(nonnull NSString *)fromAddress toAddress:(nonnull NSString *)toAddress completion:(nonnull LOSPGetRouteHandler)completion
{
    [CLPlacemark losp_getPlacemarkWithAddress:fromAddress completion:^(CLPlacemark * _Nullable fromPlacemark, NSError * _Nullable fromError) {
        if (fromPlacemark == nil) {
            completion(nil, fromError);
            return;
        }
        
        [CLPlacemark losp_getPlacemarkWithAddress:toAddress completion:^(CLPlacemark * _Nullable toPlacemark, NSError * _Nullable toError) {
            if (toPlacemark == nil) {
                completion(nil, toError);
                return;
            }
            
            [self losp_getRouteFromPlacemark:fromPlacemark toPlacemark:toPlacemark completion:completion];
        }];
    }];
}

@end
