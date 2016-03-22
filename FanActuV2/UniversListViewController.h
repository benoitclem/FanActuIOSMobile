//
//  ArticleListViewController.h
//  FanActu
//
//  Created by Clément BENOIT on 27/02/16.
//  Copyright (c) 2016 FanActu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UniversListViewController : UIViewController <UITableViewDataSource,UITableViewDelegate> {
    CGFloat tableHeaderHeight;
    NSMutableArray *universList;
    UILabel *actuLabelLevel;
    BOOL isNotificationScreen;
    BOOL loading;
    NSNumber *selectedIdUnivers;
}

- (IBAction)switched:(id)sender;
- (IBAction)ValueChanged:(id)sender;
- (NSString*) getSelectedIdUnivers;

@property (weak, nonatomic) IBOutlet UITableView *UniversTableView;
@property (weak, nonatomic) IBOutlet UIView *NavBar;

- (void) setNotificationScreen;

@end
