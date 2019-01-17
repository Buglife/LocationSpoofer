//
//  CLLocationCoordinate2D+LOSPAdditions.m
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

#import "CLLocationCoordinate2D+LOSPAdditions.h"

static const CLLocationDistance kLOSPEarthRadiusMeters = 6371000.0;

double LOSPDegreesToRadians(double degrees) {
    return degrees * M_PI / 180;
}

double LOSPRadiansToDegrees(double radians) {
    return radians * 180 / M_PI;
}

LOSPBearing LOSPBearingFromCoordinateToCoordinate(CLLocationCoordinate2D startCoordinate, CLLocationCoordinate2D endCoordinate) {
    double lat1 = LOSPDegreesToRadians(startCoordinate.latitude);
    double lon1 = LOSPDegreesToRadians(startCoordinate.longitude);
    double lat2 = LOSPDegreesToRadians(endCoordinate.latitude);
    double lon2 = LOSPDegreesToRadians(endCoordinate.longitude);
    double dLon = lon2 - lon1;
    double y = sin(dLon) * cos(lat2);
    double x = cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(dLon);
    double radiansBearing = atan2(y, x);
    return LOSPRadiansToDegrees(radiansBearing);
}

CLLocationCoordinate2D LOSPGetCoordinateFromStartingCoordinate(CLLocationCoordinate2D startCoordinate, CLLocationDistance distance, LOSPBearing bearing) {
    double distanceRadians = distance / kLOSPEarthRadiusMeters;
    double bearingRadians = LOSPDegreesToRadians(bearing);
    double fromLatRadians = LOSPDegreesToRadians(startCoordinate.latitude);
    double fromLonRadians = LOSPDegreesToRadians(startCoordinate.longitude);
    double toLatRadians = asin(sin(fromLatRadians) * cos(distanceRadians) + cos(fromLatRadians) * sin(distanceRadians) * cos(bearingRadians));
    double toLonRadians = fromLonRadians + atan2(sin(bearingRadians) * sin(distanceRadians) * cos(fromLatRadians), cos(distanceRadians) - sin(fromLatRadians) * sin(toLatRadians));
    toLonRadians = fmod((toLonRadians + 3*M_PI), (2*M_PI)) - M_PI;
    CLLocationCoordinate2D result;
    result.latitude = LOSPRadiansToDegrees(toLatRadians);
    result.longitude = LOSPRadiansToDegrees(toLonRadians);
    return result;
}
