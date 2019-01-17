//
//  LOSPPresetTableViewController.m
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

#import "LOSPPresetTableViewController.h"
#import "CLLocation+LOSPAdditions.h"
#import "CLPlacemark+LOSPAdditions.h"
#import <CoreLocation/CoreLocation.h>
#import "LOSPLocationSpoofer.h"


@interface LOSPPresetTableViewController ()

@property (nonatomic, nonnull, readonly) NSArray<CLPlacemark *> *presets;

@end

@implementation LOSPPresetTableViewController

@synthesize presets=_presets;

+ (nonnull NSString *)_cellIdentifier
{
    return @"CellIdentifier";
}

#pragma mark - Initializers

- (instancetype)init
{
    return [super initWithStyle:UITableViewStyleGrouped];
}

#pragma mark - Accessors

- (NSArray<CLPlacemark *> *)presets
{
    if (_presets == nil) {
        _presets = [CLPlacemark losp_presets];
    }
    
    return _presets;
}

#pragma mark - UIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Location Presets";
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:[[self class] _cellIdentifier]];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.presets.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[[self class] _cellIdentifier] forIndexPath:indexPath];
    CLPlacemark *preset = self.presets[indexPath.row];
    cell.textLabel.text = preset.name;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CLPlacemark *preset = self.presets[indexPath.row];
    [LOSPLocationSpoofer sharedSpoofer].location = preset.location;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.navigationController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    });
}

@end
