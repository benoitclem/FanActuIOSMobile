//
//  UniversListViewController.m
//  FanActu
//
//  Created by Clément BENOIT on 27/02/16.
//  Copyright (c) 2016 FanActu. All rights reserved.
//

#import "UniversListViewController.h"
#import "ArticleListViewController.h"
#import "UISwitchWithData.h"
#import "FanActuHTTPRequest.h"
#import "UIImageView+WebCache.h"
#import "DevicesMacros.h"
#import "Globals.h"
@import AVFoundation;
@import AVKit;

@interface UniversListViewController ()

@end

@implementation UniversListViewController

-(IBAction)switched:(id)sender {
    UISwitchWithData *s = (UISwitchWithData*)sender;
    NSString *strIndex = [NSString stringWithFormat:@"%ld",[s getValue]];
    NSNumber *level = (s.on)?@1:@0;
    NSLog(@"Switched %@ to %@",strIndex,level);
    [FanActuHTTPRequest updateUniversWithId:strIndex andLevel:level andCompletionBlock:^(NSData *data, NSURLResponse *response, NSError *error){
        NSLog(@"Update Done");
    }];

}

- (IBAction)ValueChanged:(id)sender {
    //NSLog(@"Slider Value Changed");
    UISlider *slider = (UISlider*) sender;
    NSLog(@"Slider Value = %f",slider.value);
    if(slider.value <0.17) {
        [slider setValue:0.0 animated:YES];
        [actuLabelLevel setText:@"PAS FAN"];
        [FanActuHTTPRequest updateUniversWithId:@"0" andLevel:@0 andCompletionBlock:^(NSData *data, NSURLResponse *response, NSError *error){
            NSLog(@"Update Done");
        }];
    }else if(slider.value < 0.5) {
        [slider setValue:0.33 animated:YES];
        [actuLabelLevel setText:@"MINI FAN"];
        [FanActuHTTPRequest updateUniversWithId:@"0" andLevel:@1 andCompletionBlock:^(NSData *data, NSURLResponse *response, NSError *error){
            NSLog(@"Update Done");
        }];
    } else if(slider.value < 0.83) {
        [slider setValue:0.66 animated:YES];
        [actuLabelLevel setText:@"BIG FAN"];
        [FanActuHTTPRequest updateUniversWithId:@"0" andLevel:@2 andCompletionBlock:^(NSData *data, NSURLResponse *response, NSError *error){
            NSLog(@"Update Done");
        }];
    } else {
        [slider setValue:1.0 animated:YES];
        [actuLabelLevel setText:@"HARDCORE FAN"];
        [FanActuHTTPRequest updateUniversWithId:@"0" andLevel:@3 andCompletionBlock:^(NSData *data, NSURLResponse *response, NSError *error){
            NSLog(@"Update Done");
        }];
    }
    
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    loading = true;
    NSArray *tempUniversList = [Globals getUnivers];
    universList = [NSMutableArray arrayWithArray: [tempUniversList subarrayWithRange:NSMakeRange(0, [tempUniversList count]-1)]];
    // Register UDID
    /* [FanActuHTTPRequest requestUniversWithCompletionBlock:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSArray *univers = [(NSDictionary*)[NSJSONSerialization
                                          JSONObjectWithData:data
                                          options:NSJSONReadingMutableContainers
                                      error:&error] objectForKey:@"univers"];
        NSLog(@"univers %@",univers);
        // Keep the univers in globals
        [Globals setUnivers:univers];
    }]; */
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) setNotificationScreen {
    isNotificationScreen = true;
}

- (NSString*) getSelectedIdUnivers {
    return selectedIdUnivers;
}

// =========== UITableView Delegates ===========

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(section == 0)
        return 1;
    else {
        if(isNotificationScreen)
            return [universList count] +1;
        else
            return [universList count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    if(indexPath.section == 0){
        cell = [tableView dequeueReusableCellWithIdentifier:@"TableFixedHeader" forIndexPath:indexPath];
        UIImageView *cover = (UIImageView *)[cell.contentView viewWithTag:10];
        cover.image = [UIImage imageNamed:@"visuelUnivers.jpg"];
        return cell;
    } else {

        if(isNotificationScreen) {
            if(indexPath.row == 0){
                cell = [tableView dequeueReusableCellWithIdentifier:@"ActuRow" forIndexPath:indexPath];
                UIImageView *img = (UIImageView *)[cell.contentView viewWithTag:20];
                img.image = [UIImage imageNamed:@"placeholderImg.jpg"];
                
                UILabel *Title = (UILabel*)[cell.contentView viewWithTag:10];
                [Title setText:@"ACTU"];
                UISlider *Slider = (UISlider*)[cell.contentView viewWithTag:11];
                Slider.continuous = false;
                Slider.value = 1.0;
                UILabel *actuLabel = (UILabel*)[cell.contentView viewWithTag:12];
                actuLabelLevel = actuLabel;
                [actuLabel setText:@"HARDCORE FAN"];
            } else {
                //
                cell = [tableView dequeueReusableCellWithIdentifier:@"UniversRowNotif" forIndexPath:indexPath];
                
                // Configure the Cell img
                UIImageView *img = (UIImageView *)[cell.contentView viewWithTag:20];
                NSString *strImgUrl = [FanActuHTTPRequest getParameter:@"visuel" fromArticles:universList withIndex:indexPath.row-1];
                //NSLog(@"url %@",strImgUrl);
                [img sd_setImageWithURL:[NSURL URLWithString:strImgUrl] placeholderImage:[UIImage imageNamed:@"placeholderImg.jpg"]];
                
                // Configure the Cell author
                UILabel *Title = (UILabel *)[cell.contentView viewWithTag:10];
                NSString *strTitle = [FanActuHTTPRequest getParameter:@"nom" fromArticles:universList withIndex:indexPath.row-1];
                [Title setText:[strTitle uppercaseString]];

                // Configure the Cell title
                UISwitchWithData *sw = (UISwitchWithData *)[cell.contentView viewWithTag:11];
                NSNumber *n = [FanActuHTTPRequest getNumberParameter:@"idUnivers" fromArticles:universList withIndex:indexPath.row-1];
                NSLog(@"%@",n);
                [sw setValue:[n integerValue]];
                NSNumber *state = [FanActuHTTPRequest getNumberParameter:@"level" fromArticles:universList withIndex:indexPath.row-1];
                [sw setOn:([state integerValue] == 1)];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        } else {
            cell = [tableView dequeueReusableCellWithIdentifier:@"UniversRow" forIndexPath:indexPath];
            
            // Configure the Cell img
            UIImageView *img = (UIImageView *)[cell.contentView viewWithTag:20];
            NSString *strImgUrl = [FanActuHTTPRequest getParameter:@"visuel" fromArticles:universList withIndex:indexPath.row];
            //NSLog(@"url %@",strImgUrl);
            [img sd_setImageWithURL:[NSURL URLWithString:strImgUrl] placeholderImage:[UIImage imageNamed:@"placeholderImg.jpg"]];
            
            // Configure the Cell author
            UILabel *Title = (UILabel *)[cell.contentView viewWithTag:10];
            NSString *strTitle = [FanActuHTTPRequest getParameter:@"nom" fromArticles:universList withIndex:indexPath.row];
            [Title setText:[strTitle uppercaseString]];
            
            // Configure the article count
            UILabel *articleCount = (UILabel *)[cell.contentView viewWithTag:11];
            NSString *strArticleCount = [NSString stringWithFormat:@"%@ ARTICLES",[FanActuHTTPRequest getParameter:@"articles" fromArticles:universList withIndex:indexPath.row]];
            [articleCount setText:[strArticleCount uppercaseString]];
        }
    }

    return cell;
}

/*
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(!isNotificationScreen && (indexPath.section == 1)){
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        NSString *uN = [(UILabel*)[cell.contentView viewWithTag:10] text];
        NSArray *univers = [Globals getUnivers];
        for(NSDictionary *u in univers) {
            NSString *universName = [[u objectForKey:@"nom"] uppercaseString];
            if(universName) {
                if([universName compare:uN] == NSOrderedSame){
                    selectedIdUnivers = [u objectForKey:@"idUnivers"];
                    NSLog(@"Matched %@",selectedIdUnivers);
                }
            }
        }
    }
}
 */

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
    NSLog(@"This is a segue %@",segue.identifier);
    if(segue.identifier){
        if([segue.identifier compare:@"segue1"] == NSOrderedSame) {
            ArticleListViewController *avc = (ArticleListViewController*)segue.destinationViewController;
            UITableViewCell *cell = (UITableViewCell*) sender;
            NSString *uN = [(UILabel*)[cell.contentView viewWithTag:10] text];
            NSArray *univers = [Globals getUnivers];
            for(NSDictionary *u in univers) {
                NSString *universName = [[u objectForKey:@"nom"] uppercaseString];
                if(universName) {
                    if([universName compare:uN] == NSOrderedSame){
                        [avc setIdUnivers:[u objectForKey:@"idUnivers"]];
                    }
                }
            }
        }
    }
}

@end
