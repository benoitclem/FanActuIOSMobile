//
//  MenuViewController.m
//  FanActuV2
//
//  Created by Clément BENOIT on 07/03/16.
//  Copyright © 2016 cbenoitp. All rights reserved.
//

#import "MenuViewController.h"
#import "UniversListViewController.h"

#define N_ACTUALITE 5
#define N_UNIVERS 3

@interface MenuViewController ()

@end

@implementation MenuViewController

- (IBAction)myUnwindAction:(UIStoryboardSegue *)unwindSegue{
    NSLog(@"Dismiss Screen UNIVERS");
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    ActuRows = 0;
    UniversRows = 0;
    //_image.image = [UIImage imageNamed:@"bb8.jpg"];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(section == 0) {
        return ActuRows+1;
    } else if(section == 1) {
        return UniversRows+1;
    } else {
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell;
    if(indexPath.section == 0) {
        if(indexPath.row == 0) {
            cell = [tableView dequeueReusableCellWithIdentifier:@"bigEntry" forIndexPath:indexPath];
            UILabel *rowLabel = (UILabel *)[cell.contentView viewWithTag:10];
            rowLabel.text = @"ACTUALITÉS";
        } else {
            cell = [tableView dequeueReusableCellWithIdentifier:@"smallEntry" forIndexPath: indexPath];
            UILabel *rowLabel = (UILabel *)[cell.contentView viewWithTag:10];
            switch(indexPath.row) {
                case 1:
                    rowLabel.text = @"CINÉMA";
                    break;
                case 2:
                    rowLabel.text = @"ANIMATION";
                    break;
                case 3:
                    rowLabel.text = @"SÉRIES TV";
                    break;
                case 4:
                    rowLabel.text = @"JEUX VIDÉO";
                    break;
                case 5:
                    rowLabel.text = @"INCLASSABLE";
                    break;
                default:
                    rowLabel.text = @"NOPPPS";
                    break;
            }
        }
    } else if(indexPath.section == 1) {
        if(indexPath.row == 0) {
            cell = [tableView dequeueReusableCellWithIdentifier:@"bigEntry" forIndexPath:indexPath];
            UILabel *rowLabel = (UILabel *)[cell.contentView viewWithTag:10];
            rowLabel.text = @"UNIVERS";
        } else {
            cell = [tableView dequeueReusableCellWithIdentifier:@"smallEntry" forIndexPath: indexPath];
            UILabel *rowLabel = (UILabel *)[cell.contentView viewWithTag:10];
            switch(indexPath.row) {
                case 1:
                    rowLabel.text = @"PROUT";
                    break;
                case 2:
                    rowLabel.text = @"CACA";
                    break;
                case 3:
                    rowLabel.text = @"PIPI";
                    break;
                default:
                    rowLabel.text = @"NOPPPS";
                    break;
            }
        }
    } else {
        cell = [tableView dequeueReusableCellWithIdentifier:@"bigEntry" forIndexPath:indexPath];
        UILabel *rowLabel = (UILabel *)[cell.contentView viewWithTag:10];
        rowLabel.text = @"CONTACT";
    }
    
    // Set programmaticaly the background color when selected
    UIView *bgColorView = [[UIView alloc] init];
    bgColorView.backgroundColor = [UIColor colorWithRed:48.0/255.0 green:81.0/255.0 blue:90.0/255.0 alpha:1.0];
    [cell setSelectedBackgroundView:bgColorView];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if((indexPath.section == 0) && (indexPath.row == 0)) {
        NSLog(@"Clicked On Actu stuffs");
        // Fait a l'arrache
        if(ActuRows == 0) {
            ActuRows += N_ACTUALITE;
            NSMutableArray *insertIndexPaths = [[NSMutableArray alloc] init];
            for( int i = 0; i<N_ACTUALITE; i++){
                [insertIndexPaths addObject:[NSIndexPath indexPathForRow:i+1 inSection:0]];
            }
            [self.menuTable beginUpdates];
            [self.menuTable insertRowsAtIndexPaths:insertIndexPaths withRowAnimation:UITableViewRowAnimationFade];
            //[self.menuTable deleteRowsAtIndexPaths:deleteIndexPaths withRowAnimation:UITableViewRowAnimationFade];
            [self.menuTable endUpdates];
        } else {
            ActuRows -= N_ACTUALITE;
            NSMutableArray *deleteIndexPaths = [[NSMutableArray alloc] init];
            for( int i = 0; i<N_ACTUALITE; i++){
                [deleteIndexPaths addObject:[NSIndexPath indexPathForRow:i+1 inSection:0]];
            }
            [self.menuTable beginUpdates];
            //[self.menuTable insertRowsAtIndexPaths:insertIndexPaths withRowAnimation:UITableViewRowAnimationFade];
            [self.menuTable deleteRowsAtIndexPaths:deleteIndexPaths withRowAnimation:UITableViewRowAnimationFade];
            [self.menuTable endUpdates];
        }
    } else if((indexPath.section == 1) && (indexPath.row == 0)) {
        NSLog(@"Clicked on Actu Stuff");
        [self performSegueWithIdentifier:@"segue0" sender:self];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
