//
//  ArticleListViewController.m
//  FanActu
//
//  Created by Clément BENOIT on 27/02/16.
//  Copyright (c) 2016 FanActu. All rights reserved.
//

#import "ArticleListViewController.h"
#import "ArticleViewController.h"
#import "MenuViewController.h"
#import "SearchViewController.h"
#import "FanActuHTTPRequest.h"
#import "UIImageView+WebCache.h"
#import "HotView.h"
@import AVFoundation;
@import AVKit;

@interface ArticleListViewController ()

@end

@implementation ArticleListViewController

- (IBAction)myUnwindAction:(UIStoryboardSegue *)unwindSegue{
    NSLog(@"Dismiss Screen");
}

- (IBAction)selectedRow:(UIStoryboardSegue*)selectedSegue{
    
    MenuViewController *menuVc = (MenuViewController*)selectedSegue.sourceViewController;
    NSIndexPath *ip = [menuVc.menuTable indexPathForSelectedRow];
    NSLog(@"Selected %ld",(long)ip.row);
}

- (IBAction)search:(UIStoryboardSegue*)searchSegue{
    SearchViewController *searchVc = (SearchViewController*)searchSegue.sourceViewController;
    NSString *srchTxt = [searchVc.SearchTextField text];
    NSLog(@"Search %@",srchTxt);
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (NSString *) getEncodedDate:(NSString*) dateString{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    if(dateString == nil) {
        formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss ZZZ";
        dateString = [formatter stringFromDate:[NSDate date]];
    }
    return [dateString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
}

- (void)viewDidLoad {
    hotPageControl = nil;
    [super viewDidLoad];
    loading = true;
    buttonSelected = 1;
    HotDisplayedHeight = 255.0;
    SelectedColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
    UnselectedColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.3];
    NSString *encodedDate = [self getEncodedDate:nil];
    NSLog(@"Date %@",encodedDate);
    [FanActuHTTPRequest requestArticlesWithDate:encodedDate
        andCompletionBlock:^(NSData *data, NSURLResponse *response, NSError *error) {
            // handle response
            hotList = [(NSMutableDictionary*)[NSJSONSerialization
                                                  JSONObjectWithData:data
                                                  options:NSJSONReadingMutableContainers
                                                  error:&error] objectForKey:@"hot"];
            NSLog(@"Hot %@ ", hotList);
            articleList = [(NSMutableDictionary*)[NSJSONSerialization
                           JSONObjectWithData:data
                           options:NSJSONReadingMutableContainers
                           error:&error] objectForKey:@"actus"];
            NSLog(@"Actus %@ ", articleList);
            [self.ArticleTableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
            
            NSLog(@"ReloadedTableView");
            loading = false;
            }];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// =========== UISwipeView Delegates ===========

- (NSInteger)numberOfItemsInSwipeView:(SwipeView *)swipeView {
    int nPages = (int)[hotList count];
    if(hotPageControl != nil)
        hotPageControl.numberOfPages = nPages;
    return nPages;
}

- (UIView *)swipeView:(SwipeView *)swipeView viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view {
    HotView *hotView;
    if( view == nil ){
        hotView = (HotView*)[[NSBundle mainBundle] loadNibNamed:@"HotView" owner:self options:nil][0];
        //[hotView setFrame:CGRectMake(0, 0, hotView.frame.size.width/2, hotView.frame.size.height/2)];
        //NSLog(@"%f,%f",hotView.frame.size.width,hotView.frame.size.height);
    } else {
        hotView = (HotView*)view;
    }

    //NSLog(@"Showing %ld",(long)index);
    
    // Image
    NSString *strImgUrl = [FanActuHTTPRequest getParameter:@"visuel" fromArticles:hotList withIndex:index];
    NSLog(@"%@",strImgUrl);
    [hotView.image sd_setImageWithURL:[NSURL URLWithString:strImgUrl] placeholderImage:[UIImage imageNamed:@"bb8.jpg"]];
    
    // Configure the Category
    NSString *strCategory = [FanActuHTTPRequest getParameter:@"categorie" fromArticles:hotList withIndex:index];
    [hotView.category setText:[strCategory uppercaseString]];
    
    // Configure the Cell author
    NSString *strAutor = [FanActuHTTPRequest getParameter:@"author" fromArticles:hotList withIndex:index];
    [hotView.WhenWho setText:strAutor];
    
    // Configure the Cell title
    NSString *strTitle = [FanActuHTTPRequest getParameter:@"titre" fromArticles:hotList withIndex:index];
    [hotView.Title setText:strTitle];
    
    return hotView;
}

- (void)swipeViewDidScroll:(SwipeView *)swipeView{
    // MAke this differential?
    hotPageControl.currentPage = swipeView.currentItemIndex;
}

/*
- (CGSize)swipeViewItemSize:(SwipeView *)swipeView {
    //NSLog(@"s = %f",swipeView.frame.size.width);
    return CGSizeMake(swipeView.frame.size.width, HotDisplayedHeight);
}
 */

// =========== UITableView Delegates ===========

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    if(indexPath.section == 0){
        cell = [tableView dequeueReusableCellWithIdentifier:@"TableFixedHeader" forIndexPath:indexPath];
        SwipeView *sview = (SwipeView *)[cell.contentView viewWithTag:10];
        sview.alignment = SwipeViewAlignmentCenter;
        sview.pagingEnabled = YES;
        sview.itemsPerPage = 1;
        sview.truncateFinalPage = YES;
        sview.clipsToBounds = NO;
        hotPageControl = (UIPageControl*)[cell.contentView viewWithTag:30];
        // Trigger the swipe to reload, This reload all the image so there is no loading when swiping
        [sview reloadData];
        return cell;
    } else {
        if(indexPath.row != [articleList count]) {
            // Get a cell
            cell = [tableView dequeueReusableCellWithIdentifier:@"ArticleRow" forIndexPath:indexPath];
            
            // Configure the Cell img
            UIImageView *img = (UIImageView *)[cell.contentView viewWithTag:20];
            NSString *strImgUrl = [FanActuHTTPRequest getParameter:@"img" fromArticles:articleList withIndex:indexPath.row];
            //NSLog(@"url %@",strImgUrl);
            [img sd_setImageWithURL:[NSURL URLWithString:strImgUrl] placeholderImage:[UIImage imageNamed:@"bb8.jpg"]];
            
            // Configure the Cell author
            UILabel *Who = (UILabel *)[cell.contentView viewWithTag:12];
            NSString *strAutor = [FanActuHTTPRequest getParameter:@"author" fromArticles:articleList withIndex:indexPath.row];
            [Who setText:strAutor];
            
            // Configure the Cell title
            UILabel *Title = (UILabel *)[cell.contentView viewWithTag:10];
            NSString *strTitle = [FanActuHTTPRequest getParameter:@"titre" fromArticles:articleList withIndex:indexPath.row];
            [Title setText:strTitle];
            
            // Configure the Cell time
            UILabel *Time = (UILabel *)[cell.contentView viewWithTag:11];
            NSString *strDate = [FanActuHTTPRequest getParameter:@"date" fromArticles:articleList withIndex:indexPath.row];
            [Time setText:strDate];
        } else {
            // This is the activity indicator
            cell = [tableView dequeueReusableCellWithIdentifier:@"LoadingIndicator" forIndexPath:indexPath];
             UIActivityIndicatorView *loadingIndicator = (UIActivityIndicatorView *)[cell.contentView viewWithTag:10];
            [loadingIndicator startAnimating];
        }
    }

    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(section == 0)
        return 1;
    else
        return [articleList count] + 1 ;
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

- (void) buttonTouched:(UIButton *)sender {
    // A revoir
    int oldButtonSelected = buttonSelected;
    if(sender == B1) {
        //NSLog(@"B1 TOUCHED");
        buttonSelected = 1;
    } else if(sender == B2) {
        //NSLog(@"B2 TOUCHED");
        buttonSelected = 2;
    } else if(sender == B3){
        //NSLog(@"B3 TOUCHED");
        buttonSelected = 3;
    }
    if(oldButtonSelected != buttonSelected) {
        //NSLog(@"B1 RELOAD");
        // This is not very clean, we need to reload only the section header
        [self.ArticleTableView reloadData];
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UITableViewCell *cell;
    if(section == 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"Empty"];
    } else {
        cell = [tableView dequeueReusableCellWithIdentifier:@"Header"];
        B1 = (UIButton *)[cell.contentView viewWithTag:10];
        B2 = (UIButton *)[cell.contentView viewWithTag:11];
        B3 = (UIButton *)[cell.contentView viewWithTag:12];
        [B1 setTitle:@"ACTUALITÉS" forState:UIControlStateNormal];
        [B2 setTitle:@"TOP SEMAINE" forState:UIControlStateNormal];
        [B3 setTitle:@"TOP MOIS" forState:UIControlStateNormal];
        int n = 0;
        if(buttonSelected == 1) {
            n = 1;
            [B1.titleLabel setFont:[UIFont fontWithName:@"Fugaz One" size:17]];
            B1.titleLabel.textColor = SelectedColor;
            // Add the little "down arrow"
            
            UIImage *arrow = [UIImage imageNamed:@"flechejaune"];
            CGFloat imgW = arrow.size.width;
            CGFloat imgH = arrow.size.height;
            UIImageView *arrowView = [[UIImageView alloc] initWithFrame:CGRectMake(B1.frame.size.width/2-imgW/2,0, imgW, imgH)];
            arrowView.image = arrow;
            [B1 addSubview:arrowView];
        } else {
            [B1.titleLabel setFont:[UIFont fontWithName:@"Fugaz One" size:15]];
            B1.titleLabel.textColor = UnselectedColor;
        }
        if(buttonSelected == 2) {
            n = 3;
            [B2.titleLabel setFont:[UIFont fontWithName:@"Fugaz One" size:17]];
            B2.titleLabel.textColor = SelectedColor;
            UIImage *arrow = [UIImage imageNamed:@"flechejaune"];
            CGFloat imgW = arrow.size.width;
            CGFloat imgH = arrow.size.height;
            UIImageView *arrowView = [[UIImageView alloc] initWithFrame:CGRectMake(B1.frame.size.width/2-imgW/2,0, imgW, imgH)];
            arrowView.image = arrow;
            [B2 addSubview:arrowView];
            
        } else {
            [B2.titleLabel setFont:[UIFont fontWithName:@"Fugaz One" size:15]];
            B2.titleLabel.textColor = UnselectedColor;
        }
        if(buttonSelected == 3) {
            n = 5;
            [B3.titleLabel setFont:[UIFont fontWithName:@"Fugaz One" size:17]];
            B3.titleLabel.textColor = SelectedColor;
            UIImage *arrow = [UIImage imageNamed:@"flechejaune"];
            CGFloat imgW = arrow.size.width;
            CGFloat imgH = arrow.size.height;
            UIImageView *arrowView = [[UIImageView alloc] initWithFrame:CGRectMake(B1.frame.size.width/2-imgW/2,0, imgW, imgH)];
            arrowView.image = arrow;
            [B3 addSubview:arrowView];
        } else {
            [B3.titleLabel setFont:[UIFont fontWithName:@"Fugaz One" size:15]];
            B3.titleLabel.textColor = UnselectedColor;
        }
        [B1 addTarget:self action:@selector(buttonTouched:) forControlEvents:UIControlEventTouchDown];
        [B2 addTarget:self action:@selector(buttonTouched:) forControlEvents:UIControlEventTouchDown];
        [B3 addTarget:self action:@selector(buttonTouched:) forControlEvents:UIControlEventTouchDown];
    }
    return (UIView*)cell;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView_
{
    CGFloat actualPosition = scrollView_.contentOffset.y;
    CGFloat contentHeight = scrollView_.contentSize.height - (self.ArticleTableView.frame.size.height+200);
    
    CGFloat fullOpacityHeight = 203.0;
    // navbar background opacity
    if ((actualPosition<=fullOpacityHeight)&&(actualPosition>0)){
        CGFloat opacity = 1.0-(fullOpacityHeight-actualPosition)/fullOpacityHeight;
        //NSLog(@"opacity %f",opacity);
        self.NavBar.backgroundColor = [self.NavBar.backgroundColor colorWithAlphaComponent:opacity];
    } else if (actualPosition>fullOpacityHeight) {
        self.NavBar.backgroundColor = [self.NavBar.backgroundColor colorWithAlphaComponent:1.0];
    }
    
    // avoid header goes under navbar
    CGFloat navBarHeight = 52;
    //NSLog(@"%f",actualPosition);
    if (actualPosition>=navBarHeight) {
        self.ArticleTableView.contentInset = UIEdgeInsetsMake(navBarHeight, 0, 0, 0);
    } else {
        self.ArticleTableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    }
    
    // loading next view
    if ((actualPosition >= contentHeight)&& (!loading)) {
        loading = true;
        NSLog(@"Loading dext Data");
        // Get The date of last requested article
        NSDictionary *lastArticle = [articleList objectAtIndex:[articleList count] - 1];
        NSString *dateString = [lastArticle objectForKey:@"dateTime"];
        dateString = [self getEncodedDate:dateString];
        NSLog(@"Last Arcticle %@",dateString);
        [FanActuHTTPRequest requestArticlesWithDate:dateString
           andCompletionBlock:^(NSData *data, NSURLResponse *response, NSError *error) {
               // handle response
               [articleList addObjectsFromArray: [(NSMutableDictionary*)[NSJSONSerialization
                                                     JSONObjectWithData:data
                                                     options:NSJSONReadingMutableContainers
                                                     error:&error] objectForKey:@"actus"]];
               //NSLog(@" %@ ", articleList);
               [self.ArticleTableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
               NSLog(@"ReloadedTableView");
               loading = false;
           }];
    }
    
    // Do the nice resizing stuffs for carousel
    // Get visible cells on table view.
    NSArray *visibleCells = [self.ArticleTableView visibleCells];
    NSArray *visibleIndexes = [self.ArticleTableView indexPathsForVisibleRows];
    int index = 0;
    for(NSIndexPath *visibleIndex in visibleIndexes) {
        if((visibleIndex.section == 0)&&(visibleIndex.row == 0)) {
            UITableViewCell *tvc = [visibleCells objectAtIndex:index];
            SwipeView *swv = (SwipeView*)[tvc.contentView viewWithTag:10];
            HotView *hv = (HotView*)[swv itemViewAtIndex:swv.currentItemIndex];
            CGFloat computedVisiblePart = 255-actualPosition;
            NSLog(@"visiblePart %f",computedVisiblePart);
            hv.image.frame = (CGRectMake(0,-computedVisiblePart+255, hv.image.frame.size.width, computedVisiblePart));
            hv.colorOverlay.frame = (CGRectMake(0,-computedVisiblePart+255, hv.image.frame.size.width, computedVisiblePart));
            //CGRect cellSize = [self.ArticleTableView rectForRowAtIndexPath:visibleIndex];
        }
        index++;
    }
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSLog(@"Segue %@",segue.identifier);
    if([segue.identifier compare:@"toArticle"] == NSOrderedSame) {
        // Pass the publication Id of selected article
        NSIndexPath *selected = [self.ArticleTableView indexPathForSelectedRow];
        NSDictionary *article = [articleList objectAtIndex:selected.row];
        ArticleViewController *avc = (ArticleViewController*) segue.destinationViewController;
        [avc setPublicationId:[NSString stringWithFormat:@"%ld",[[article objectForKey:@"idPublication"] integerValue]]];
    }
}

@end
