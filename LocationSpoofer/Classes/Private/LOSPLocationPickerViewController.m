//
//  LOSPLocationPickerViewController.m
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

#import "LOSPLocationPickerViewController.h"
#import "LOSPLocationSpoofer.h"
#import "UIView+LOSPAdditions.h"
#import "MKMapView+LOSPAdditions.h"
#import "CLLocation+LOSPAdditions.h"
#import <MapKit/MapKit.h>

@interface LOSPLocationPickerView : UIView

@property (nonatomic, nonnull, readonly) MKMapView *mapView;
@property (nonatomic, nonnull, readonly) UITextField *textField;

@end

@interface LOSPLocationPickerViewController () <MKMapViewDelegate, UITextFieldDelegate>

@property (nonatomic, nonnull, readonly) LOSPLocationPickerView *locationPickerView;
@property (nonatomic, nonnull, readonly) CLGeocoder *geocoder;
@property (nonatomic, nullable) MKPointAnnotation *annotation;

@end

@implementation LOSPLocationPickerViewController

@synthesize locationPickerView = _locationPickerView;

- (LOSPLocationPickerView *)locationPickerView
{
    if (_locationPickerView == nil) {
        _locationPickerView = [[LOSPLocationPickerView alloc] init];
        _locationPickerView.textField.delegate = self;
        _locationPickerView.mapView.delegate = self;
    }
    
    return _locationPickerView;
}

- (void)loadView
{
    self.view = self.locationPickerView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Location Picker";
    _geocoder = [[CLGeocoder alloc] init];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if (self.annotation) {
        CLLocationCoordinate2D coordinate = self.annotation.coordinate;
        [LOSPLocationSpoofer sharedSpoofer].location = [[CLLocation alloc] initWithLatitude:coordinate.latitude longitude:coordinate.longitude];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self _reverseGeocode:textField.text];
        [textField resignFirstResponder];
    });
    
    return YES;
}

- (void)_reverseGeocode:(NSString *)placeOrAddress
{
    [self.geocoder geocodeAddressString:placeOrAddress completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        NSParameterAssert([NSThread isMainThread]);
        if (error != nil) {
            NSLog(@"Error geocoding: %@", error);
            return;
        }
        
        CLPlacemark *placemark = placemarks.firstObject;
        
        if (placemark) {
            NSLog(@"Found placemark: %@", placemark.name);
            CLLocation *location = placemark.location;
            
            if (self.annotation != nil) {
                [self.locationPickerView.mapView removeAnnotation:self.annotation];
            }
            
            self.annotation = [[MKPointAnnotation alloc] init];
            self.annotation.title = placemark.name;
            self.annotation.coordinate = location.coordinate;
            [self.locationPickerView.mapView addAnnotation:self.annotation];
            [self.locationPickerView.mapView losp_zoomToLocation:location animated:YES];
        }
    }];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    NSParameterAssert([annotation isKindOfClass:[MKPointAnnotation class]]);
    MKPinAnnotationView *view = (MKPinAnnotationView *) [mapView dequeueReusableAnnotationViewWithIdentifier:@"identifier"];
    
    if (view == nil) {
        view = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"identifier"];
        view.animatesDrop = YES;
        view.canShowCallout = YES;
    } else {
        view.annotation = annotation;
    }
    
    return view;
}

@end

@interface LOSPLocationPickerView ()

@property (nonatomic, nonnull) UIView *sheetView;
@property (nonatomic, nonnull) NSLayoutConstraint *textFieldBottomConstraint;

@end

static const CGFloat LOSPLocationPickerViewTextFieldPadding = 15;
static const CGFloat LOSPLocationPickerViewTextFieldHeight = 33;

@implementation LOSPLocationPickerView

- (instancetype)init
{
    self = [super init];
    if (self) {
        _mapView = [[MKMapView alloc] init];
        _mapView.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:_mapView];
        
        _sheetView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleProminent]];
        _sheetView.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:_sheetView];
        
        _textField = [[UITextField alloc] init];
        _textField.translatesAutoresizingMaskIntoConstraints = NO;
        _textField.placeholder = @"Search for a place or address";
        _textField.backgroundColor = [UIColor colorWithRed:230.0/255.0 green:230.0/255.0 blue:226.0/255.0 alpha:1];
        _textField.returnKeyType = UIReturnKeyGo;
        _textField.autocorrectionType = UITextAutocorrectionTypeNo;
        _textField.layer.cornerRadius = 5;
        _textField.layer.masksToBounds = YES;
        [self addSubview:_textField];
        
        UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, LOSPLocationPickerViewTextFieldPadding, LOSPLocationPickerViewTextFieldHeight)];
        _textField.leftView = paddingView;
        _textField.leftViewMode = UITextFieldViewModeAlways;
        
        _textFieldBottomConstraint = [_textField.bottomAnchor constraintEqualToAnchor:self.losp_safeAreaBottomAnchor constant:-LOSPLocationPickerViewTextFieldPadding];
        
        [NSLayoutConstraint activateConstraints:
            @[
                [_mapView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor],
                [_mapView.topAnchor constraintEqualToAnchor:self.topAnchor],
                [_mapView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor],
                [_mapView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor],
                
                [_sheetView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor],
                [_sheetView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor],
                [_sheetView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor],
                
                [_textField.topAnchor constraintEqualToAnchor:_sheetView.topAnchor constant:LOSPLocationPickerViewTextFieldPadding],
                [_textField.leadingAnchor constraintEqualToAnchor:_sheetView.leadingAnchor constant:LOSPLocationPickerViewTextFieldPadding],
                [_textField.trailingAnchor constraintEqualToAnchor:_sheetView.trailingAnchor constant:-LOSPLocationPickerViewTextFieldPadding],
                [_textField.heightAnchor constraintEqualToConstant:LOSPLocationPickerViewTextFieldHeight],
                
                _textFieldBottomConstraint
            ]
         ];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_keyboardWillShow:) name:UIKeyboardWillHideNotification object:nil];
    }
    return self;
}

- (void)_keyboardWillShow:(NSNotification *)notification
{
    NSDictionary *userInfo = notification.userInfo;
    NSTimeInterval animationDuration = ((NSNumber *)userInfo[UIKeyboardAnimationDurationUserInfoKey]).doubleValue;
    CGRect keyboardEndFrame = ((NSNumber *)userInfo[UIKeyboardFrameEndUserInfoKey]).CGRectValue;
    CGRect convertedKeyboardEndFrame = [self convertRect:keyboardEndFrame fromView:self.window];
    UIViewAnimationOptions animationCurve = ((NSNumber *)userInfo[UIKeyboardAnimationCurveUserInfoKey]).unsignedIntegerValue << 16;
    
    CGFloat constant = CGRectGetMaxY(self.bounds) - CGRectGetMinY(convertedKeyboardEndFrame);
    self.textFieldBottomConstraint.constant = -constant;
    
    [UIView animateWithDuration:animationDuration delay:0 options:animationCurve animations:^{
        [self layoutIfNeeded];
    } completion:nil];
}

@end
