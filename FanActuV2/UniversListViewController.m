//
//  UniversListViewController.m
//  FanActu
//
//  Created by Clément BENOIT on 27/02/16.
//  Copyright (c) 2016 FanActu. All rights reserved.
//

#import "UniversListViewController.h"
#import "FanActuHTTPRequest.h"
#import "UIImageView+WebCache.h"
#import "DevicesMacros.h"
#import "Globals.h"
@import AVFoundation;
@import AVKit;

@interface UniversListViewController ()

@end

@implementation UniversListViewController

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    loading = true;
    // Register UDID
    [FanActuHTTPRequest requestUniversWithCompletionBlock:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSArray *univers = [(NSDictionary*)[NSJSONSerialization
                                          JSONObjectWithData:data
                                          options:NSJSONReadingMutableContainers
                                      error:&error] objectForKey:@"univers"];
        NSLog(@"univers %@",univers);
        // Keep the univers in globals
        [Globals setUnivers:univers];
    }];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// =========== UITableView Delegates ===========

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    if(indexPath.section == 0){
        cell = [tableView dequeueReusableCellWithIdentifier:@"TableFixedHeader" forIndexPath:indexPath];
        UIImageView *cover = (UIImageView *)[cell.contentView viewWithTag:10];
        cover.image = [UIImage imageNamed:@"visuelUnivers.jpg"];
        return cell;
    } else {
        NSArray *universList = [Globals getUnivers];
        if(indexPath.row != [universList count]) {
            // Get a cell
            cell = [tableView dequeueReusableCellWithIdentifier:@"UniversRow" forIndexPath:indexPath];
            
            // Configure the Cell img
            UIImageView *img = (UIImageView *)[cell.contentView viewWithTag:20];
            NSString *strImgUrl = [FanActuHTTPRequest getParameter:@"Visuel" fromArticles:universList withIndex:indexPath.row];
            //NSLog(@"url %@",strImgUrl);
            [img sd_setImageWithURL:[NSURL URLWithString:strImgUrl] placeholderImage:[UIImage imageNamed:@"bb8.jpg"]];
            
            // Configure the Cell author
            UILabel *Title = (UILabel *)[cell.contentView viewWithTag:10];
            NSString *strTitle = [FanActuHTTPRequest getParameter:@"nom" fromArticles:universList withIndex:indexPath.row];
            [Title setText:strTitle];
            
            // Configure the Cell title
            UISwitch *sw = (UISwitch *)[cell.contentView viewWithTag:11];
            NSNumber *state = [FanActuHTTPRequest getNumberParameter:@"level" fromArticles:universList withIndex:indexPath.row];
            [sw setOn:([state integerValue] == 1)];
        }
    }

    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(section == 0)
        return 1;
    else {
        NSArray *universList = [Globals getUnivers];
        return [universList count];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 255;
    } else {
        return 104;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if(section == 1)
        return 50;
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UITableViewCell *cell;
    if(section == 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"Empty"];
    } else {
        cell = [tableView dequeueReusableCellWithIdentifier:@"Header"];
    }
    return (UIView*)cell;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView_
{
    CGFloat actualPosition = scrollView_.contentOffset.y;
    //CGFloat contentHeight = scrollView_.contentSize.height - (self.UniversTableView.frame.size.height+200);
    
    // Do the nice resizing stuffs for carousel
    // Get visible cells on table view.
    NSArray *visibleCells = [self.UniversTableView visibleCells];
    NSArray *visibleIndexes = [self.UniversTableView indexPathsForVisibleRows];
    int index = 0;
    for(NSIndexPath *visibleIndex in visibleIndexes) {
        if((visibleIndex.section == 0)&&(visibleIndex.row == 0)) {
            UITableViewCell *tvc = [visibleCells objectAtIndex:index];
            UIImageView *img = (UIImageView*)[tvc.contentView viewWithTag:10];
            UIImageView *overlay = (UIImageView*)[tvc.contentView viewWithTag:11];
            CGFloat computedVisiblePart = 255-actualPosition;
            tvc.clipsToBounds = computedVisiblePart<255;
            img.frame = (CGRectMake(0,-computedVisiblePart+255, img.frame.size.width, computedVisiblePart));
            overlay.frame = (CGRectMake(0,-computedVisiblePart+255, overlay.frame.size.width, computedVisiblePart));
        }
        index++;
    }
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSLog(@"Make the HTTP Request to update the server notification side");
}

@end
