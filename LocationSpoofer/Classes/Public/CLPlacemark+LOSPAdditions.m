//
//  CLPlacemark+LOSPAdditions.m
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

#import "CLPlacemark+LOSPAdditions.h"
#import <Intents/Intents.h>

@implementation CLPlacemark (LOSPAdditions)

+ (instancetype)losp_alcatraz
{
    return [CLPlacemark losp_placemarkName:@"Alcatraz" latitude:37.826612 longitude:-122.422877];
}

+ (instancetype)losp_ballsPyramid
{
    return [CLPlacemark losp_placemarkName:@"Ball's Pyramid" latitude:-31.753122 longitude:159.251228];
}

+ (instancetype)losp_daksa
{
    return [CLPlacemark losp_placemarkName:@"Daksa" latitude:42.668121 longitude:18.057304];
}

+ (instancetype)losp_drinaRiverHouse
{
    return [CLPlacemark losp_placemarkName:@"Drina River House" latitude:43.985449 longitude:19.566522];
}

+ (instancetype)losp_easterIsland
{
    return [CLPlacemark losp_placemarkName:@"Easter Island" latitude:-27.103032 longitude:-109.349471];
}

+ (instancetype)losp_farallonIslandNuclearWasteDump
{
    return [CLPlacemark losp_placemarkName:@"Farallon Island Nuclear Waste Dump" latitude:37.616667 longitude:-123.283333];
}

+ (instancetype)losp_fortBoyard
{
    return [CLPlacemark losp_placemarkName:@"Ford Boyard" latitude:46.000498 longitude:-1.214031];
}

+ (instancetype)losp_greatBlueHole
{
    return [CLPlacemark losp_placemarkName:@"Great Blue Hole" latitude:17.316069 longitude:-87.535143];
}

+ (instancetype)losp_greatPacificGarbagePatch
{
    return [CLPlacemark losp_placemarkName:@"The Great Pacific Garbage Patch" latitude:33.500000 longitude:-137.000000];
}

+ (instancetype)losp_hashimaIsland
{
    return [CLPlacemark losp_placemarkName:@"Hashima Island" latitude:32.628088 longitude:129.738633];
}

+ (instancetype)losp_isolaLaGaiola
{
    return [CLPlacemark losp_placemarkName:@"Isola La Gaiola" latitude:40.791734 longitude:14.187102];
}

+ (instancetype)losp_okunoshima
{
    return [CLPlacemark losp_placemarkName:@"Ōkunoshima" latitude:34.312442 longitude:132.992340];
}

+ (instancetype)losp_palmJumeirah
{
    return [CLPlacemark losp_placemarkName:@"Palm Jumeirah" latitude:25.116752 longitude:55.139207];
}

+ (instancetype)losp_providenciales
{
    return [CLPlacemark losp_placemarkName:@"Providenciales" latitude:21.785015 longitude:-72.225625];
}

+ (instancetype)losp_queimadaGrande
{
    return [CLPlacemark losp_placemarkName:@"Queimada Grande" latitude:-24.486796 longitude:-46.674327];
}

+ (instancetype)losp_ramreeIsland
{
    return [CLPlacemark losp_placemarkName:@"Ramree Island" latitude:19.142351 longitude:93.785989];
}

+ (instancetype)losp_ratIsland
{
    return [CLPlacemark losp_placemarkName:@"Rat Island" latitude:40.855434 longitude:-73.780906];
}

+ (instancetype)losp_sableIsland
{
    return [CLPlacemark losp_placemarkName:@"Sable Island" latitude:43.963065 longitude:-59.908631];
}

+ (instancetype)losp_socotra
{
    return [CLPlacemark losp_placemarkName:@"Socotra" latitude:12.526312 longitude:53.838767];
}

+ (instancetype)losp_tashirojima
{
    return [CLPlacemark losp_placemarkName:@"Tashirojima" latitude:38.297340 longitude:141.418072];
}

+ (instancetype)losp_tromelinIsland
{
    return [CLPlacemark losp_placemarkName:@"Tromelin Island" latitude:-15.890212 longitude:54.523670];
}

+ (instancetype)losp_vulcanPoint
{
    return [CLPlacemark losp_placemarkName:@"Vulcan Point" latitude:14.009637 longitude:120.996165];
}

+ (nonnull NSArray<CLPlacemark *> *)losp_presets
{
    return @[
             [self losp_alcatraz],
             [self losp_ballsPyramid],
             [self losp_daksa],
             [self losp_drinaRiverHouse],
             [self losp_easterIsland],
             [self losp_farallonIslandNuclearWasteDump],
             [self losp_fortBoyard],
             [self losp_greatBlueHole],
             [self losp_greatPacificGarbagePatch],
             [self losp_hashimaIsland],
             [self losp_isolaLaGaiola],
             [self losp_okunoshima],
             [self losp_palmJumeirah],
             [self losp_providenciales],
             [self losp_queimadaGrande],
             [self losp_ramreeIsland],
             [self losp_ratIsland],
             [self losp_sableIsland],
             [self losp_socotra],
             [self losp_tashirojima],
             [self losp_tromelinIsland],
             [self losp_vulcanPoint]
             ];
}

+ (nonnull instancetype)losp_placemarkName:(nonnull NSString *)name latitude:(CLLocationDegrees)latitude longitude:(CLLocationDegrees)longitude
{
    CLLocation *location = [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];
    return [CLPlacemark placemarkWithLocation:location name:name postalAddress:nil];
}

+ (void)losp_getPlacemarkWithAddress:(nonnull NSString *)address completion:(void (^)(CLPlacemark * _Nullable, NSError * _Nullable))completion
{
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder geocodeAddressString:address completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(placemarks.firstObject, error);
        });
    }];
}

@end
