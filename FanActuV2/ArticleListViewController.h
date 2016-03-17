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
    
    // Some consts
    CGFloat tableHeaderHeight;
    CGFloat HotDisplayedHeight;
    
    // Data Holders
    NSMutableArray *actus;
    NSMutableArray *topWeek;
    NSMutableArray *topMonth;
    NSMutableArray *hotList;
    
    // Reference to some screens elements
    UIPageControl *hotPageControl;
    UIButton *B1;
    UIButton *B2;
    UIButton *B3;
    UIColor *SelectedColor;
    UIColor *UnselectedColor;

    // States
    int buttonSelected;
    BOOL loading;
    NSNumber *idCategory;
}

@property (weak, nonatomic) IBOutlet UITableView *ArticleTableView;
@property (weak, nonatomic) IBOutlet UIView *NavBar;
@property (weak, nonatomic) IBOutlet UIImageView *SplashScreen;
@property (weak, nonatomic) IBOutlet UIImageView *SplashLogo
;

- (IBAction)myUnwindAction:(UIStoryboardSegue*)unwindSegue;
- (IBAction)selectedRow:(UIStoryboardSegue*)selectedSegue;
- (IBAction)search:(UIStoryboardSegue*)searchSegue;

- (NSMutableArray*) getDisplayedArticleList;

@end
