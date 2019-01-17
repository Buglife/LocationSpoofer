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

#import "CLLocationCoordinate2D+LOSPAdditions.h"
#import "LOSPLocationPickerViewController.h"
#import "LOSPPresetTableViewController.h"
#import "LOSPRootViewController.h"
#import "LOSPSwizzler.h"
#import "MKDirections+LOSPAdditions.h"
#import "MKMapView+LOSPAdditions.h"
#import "UIView+LOSPAdditions.h"
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

