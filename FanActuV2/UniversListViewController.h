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
    BOOL isNotificationScreen;
    BOOL loading;
}
@property (weak, nonatomic) IBOutlet UITableView *UniversTableView;
@property (weak, nonatomic) IBOutlet UIView *NavBar;

- (void) setNotificationScreen;

@end
