//
//  LOSPRootViewController.m
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

#import "LOSPRootViewController.h"
#import "CLLocation+LOSPAdditions.h"
#import "LOSPPresetTableViewController.h"
#import "LOSPLocationPickerViewController.h"
#import <CoreLocation/CoreLocation.h>

@interface LOSPRootViewController ()

@end

@implementation LOSPRootViewController

+ (nonnull NSString *)_cellIdentifier
{
    return @"CellIdentifier";
}

#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.clearsSelectionOnViewWillAppear = YES;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:[[self class] _cellIdentifier]];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(_dismissButtonTapped)];
}

- (void)_dismissButtonTapped
{
    [self.navigationController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[[self class] _cellIdentifier] forIndexPath:indexPath];
    
    if (indexPath.row == 0) {
        cell.textLabel.text = @"Presets";
    } else if (indexPath.row == 1) {
        cell.textLabel.text = @"Location picker";
    }
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        LOSPPresetTableViewController *presetVC = [[LOSPPresetTableViewController alloc] init];
        [self.navigationController pushViewController:presetVC animated:true];
    } else if (indexPath.row == 1) {
        LOSPLocationPickerViewController *vc = [[LOSPLocationPickerViewController alloc] init];
        [self.navigationController pushViewController:vc animated:true];
    }
}

@end
