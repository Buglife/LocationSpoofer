#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "CLLocation+LOSPAdditions.h"
#import "CLPlacemark+LOSPAdditions.h"
#import "LOSPLocationDebugViewController.h"
#import "LOSPLocationProvider.h"
#import "LOSPLocationSpoofer.h"
#import "LOSPTrip+LOSPPresets.h"
#import "LOSPTrip.h"
#import "MKCoordinateSpan+LOSPAdditions.h"

FOUNDATION_EXPORT double LocationSpooferVersionNumber;
FOUNDATION_EXPORT const unsigned char LocationSpooferVersionString[];

