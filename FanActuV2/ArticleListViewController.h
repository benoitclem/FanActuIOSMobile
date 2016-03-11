//
//  ArticleListViewController.h
//  FanActu
//
//  Created by Clément BENOIT on 27/02/16.
//  Copyright (c) 2016 FanActu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Swipeview.h"


@interface ArticleListViewController : UIViewController <UITableViewDataSource,UITableViewDelegate,SwipeViewDataSource, SwipeViewDelegate> {
    CGFloat tableHeaderHeight;
    NSMutableArray *articleList;
    NSMutableArray *hotList;
    UIPageControl *hotPageControl;
    UIButton *B1;
    UIButton *B2;
    UIButton *B3;
    UIColor *SelectedColor;
    UIColor *UnselectedColor;
    CGFloat HotDisplayedHeight;
    int buttonSelected;
    BOOL loading;
}
@property (weak, nonatomic) IBOutlet UITableView *ArticleTableView;
@property (weak, nonatomic) IBOutlet UIView *NavBar;

- (NSString *) getEncodedDate:(NSString*) dateString;

- (IBAction)myUnwindAction:(UIStoryboardSegue*)unwindSegue;
- (IBAction)selectedRow:(UIStoryboardSegue*)selectedSegue;
- (IBAction)search:(UIStoryboardSegue*)searchSegue;

@end
