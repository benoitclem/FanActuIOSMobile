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
    NSMutableDictionary *metaUnivers;
    
    // Reference to some screens elements
    SwipeView *sw;
    UIPageControl *hotPageControl;
    UIButton *b1;
    UIButton *b2;
    UIButton *b3;
    UIColor *SelectedColor;
    UIColor *UnselectedColor;

    // States
    BOOL isSearchResult;
    BOOL noMoreResults;
    BOOL isHotTapped;
    NSString *hotIdPub;
    int buttonSelected;
    BOOL loading;
    NSNumber *idCategory;
    NSNumber *idUnivers;
}

- (void) reloadAndRewind;

@property (weak, nonatomic) IBOutlet UITableView *ArticleTableView;
@property (weak, nonatomic) IBOutlet UIView *NavBar;
//@property (weak, nonatomic) IBOutlet UIImageView *SplashScreen;
//@property (weak, nonatomic) IBOutlet UIImageView *SplashLogo
;

- (IBAction)myUnwindAction:(UIStoryboardSegue*)unwindSegue;
- (IBAction)selectedCategory:(UIStoryboardSegue*)selectedSegue;
- (IBAction)selectedUnivers:(UIStoryboardSegue*)selectedSegue;
- (IBAction)search:(UIStoryboardSegue*)searchSegue;

- (void) setIdUnivers:(NSNumber*) lIdUnivers;
- (void) HotTapped:(NSString*) n;

- (NSMutableArray*) getDisplayedArticleList;

- (UITableViewCell *) tableView:(UITableView *)tableView HotCellForRowAtIndexPath:(NSIndexPath *)indexPath;
- (UITableViewCell *) tableView:(UITableView *)tableView ArticleCellForRowAtIndexPath:(NSIndexPath *)indexPath;
- (UITableViewCell *) tableView:(UITableView *)tableView LoadingCellForRowAtIndexPath:(NSIndexPath *)indexPath;
- (UITableViewCell *) HeaderCellForTableView:(UITableView *)tableView;

@end
