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
#import "UniversListViewController.h"
#import "SearchViewController.h"
#import "FanActuHTTPRequest.h"
#import "UIImageView+WebCache.h"
#import "HotView.h"
#import "DevicesMacros.h"
#import "Globals.h"
@import AVFoundation;
@import AVKit;

@interface ArticleListViewController ()

@end

@implementation ArticleListViewController

// Basic unwinding

- (IBAction)myUnwindAction:(UIStoryboardSegue *)unwindSegue{
    NSLog(@"Dismiss Screen");
}

- (IBAction)selectedUnivers:(UIStoryboardSegue*)selectedSegue{
    NSLog(@"Do network request");
    NSLog(@"Selected Universe %ld",[idUnivers integerValue]);
    NSString *encodedDate = [Globals getEncodedDate:nil];
    loading = true;
    [FanActuHTTPRequest requestArticlesWithCategory:@0
                                            univers:idUnivers
                                               date:encodedDate
                                 andCompletionBlock:^(NSData *data, NSURLResponse *response, NSError *error){
                             NSMutableDictionary * all = [NSJSONSerialization
                                                          JSONObjectWithData:data
                                                          options:NSJSONReadingMutableContainers
                                                          error:&error];
                             
                            // NSLog(@"RAW %@",all);
                             // handle response
                             NSMutableArray *hl = [all objectForKey:@"hot"];
                             NSLog(@"Hot %@ ", hl);
                             [Globals setHots:hl];
                             hotList = hl;
                             
                             NSMutableArray *actuList = [all objectForKey:@"actus"];
                             NSLog(@"Actus %@ ", actuList);
                             [Globals setActus:actuList];
                             actus = actuList;
                             
                             NSMutableArray *topsWeek = [all objectForKey:@"topWeek"];
                             NSLog(@"week %@ ", topsWeek);
                             [Globals setTopsWeek:topsWeek];
                             topWeek = topsWeek;
                             
                             NSMutableArray *topsMonth = [all objectForKey:@"topMonth"];
                             NSLog(@"month %@ ", topsMonth);
                             [Globals setTopsMonth:topsMonth];
                             topMonth = topsWeek;
                             
                             isSearchResult = NO;
                             [self performSelectorOnMainThread:@selector(reloadAndRewind) withObject:nil waitUntilDone: NO];
                             //[self.ArticleTableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
                             NSLog(@"ReloadedTableView");
                             loading = false;
                             
                         }];

}

- (IBAction)selectedCategory:(UIStoryboardSegue*)selectedSegue{
    MenuViewController *menuVc = (MenuViewController*)selectedSegue.sourceViewController;
    NSIndexPath *ip = [menuVc.menuTable indexPathForSelectedRow];
    NSLog(@"Selected %ld",(long)ip.row);
    // Allow the the system to load the good news feed when scrolling
    long oldIdCategory = [idCategory integerValue];
    switch(ip.row){
        default:
        case 1:
            idCategory = @0; // Toutes
            break;
        case 2:
            idCategory = @2; // Cinéma
            break;
        case 3:
            idCategory = @1; // Animation
            break;
        case 4:
            idCategory = @4; // Serie TV
            break;
        case 5:
            idCategory = @3; // Jeux Video
            break;
        case 6:
            idCategory = @5; // Inclassable
            break;
    }
    if([idCategory integerValue] != oldIdCategory) {
        // Need to reflesh the feed
        NSLog(@"Need to refresh the feed");
        NSString *encodedDate = [Globals getEncodedDate:nil];
        loading = true;
        [FanActuHTTPRequest requestArticlesWithCategory:idCategory
                                                univers:@0
                                                   date:encodedDate
                                     andCompletionBlock:^(NSData *data, NSURLResponse *response, NSError *error){
                                         NSMutableDictionary * all = [NSJSONSerialization
                                                                      JSONObjectWithData:data
                                                                      options:NSJSONReadingMutableContainers
                                                                      error:&error];
                                         
                                         // handle response
                                         NSMutableArray *hl = [all objectForKey:@"hot"];
                                         NSLog(@"Hot %@ ", hl);
                                         [Globals setHots:hl];
                                         hotList = hl;
                                         
                                         NSMutableArray *actuList = [all objectForKey:@"actus"];
                                         NSLog(@"Actus %@ ", actuList);
                                         [Globals setActus:actuList];
                                         actus = actuList;
                                         
                                         NSMutableArray *topsWeek = [all objectForKey:@"topWeek"];
                                         NSLog(@"week %@ ", topsWeek);
                                         [Globals setTopsWeek:topsWeek];
                                         topWeek = topsWeek;
                                         
                                         NSMutableArray *topsMonth = [all objectForKey:@"topMonth"];
                                         NSLog(@"month %@ ", topsMonth);
                                         [Globals setTopsMonth:topsMonth];
                                         topMonth = topsMonth;
                                         
                                         isSearchResult = NO;
                                         [self performSelectorOnMainThread:@selector(reloadAndRewind) withObject:nil waitUntilDone: NO];
                                         //[self.ArticleTableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
                                         NSLog(@"ReloadedTableView");
                                         loading = false;
                                         
                                     }];
    }
}

- (IBAction)search:(UIStoryboardSegue*)searchSegue{
    SearchViewController *searchVc = (SearchViewController*)searchSegue.sourceViewController;
    NSString *srchTxt = [searchVc.SearchTextField text];
    NSLog(@"Search %@",srchTxt);
    loading = true;
    [FanActuHTTPRequest requestArticlesWithKeyWords:srchTxt
                                 andCompletionBlock:^(NSData *data, NSURLResponse *response, NSError *error){
                                     NSMutableDictionary * all = [NSJSONSerialization
                                                                  JSONObjectWithData:data
                                                                  options:NSJSONReadingMutableContainers
                                                                  error:&error];
                                     
                                     NSLog(@"search result %@",all);
                                     
                                     // handle response
                                     NSMutableArray *hl = [all objectForKey:@"hot"];
                                     NSLog(@"Hot %@ ", hl);
                                     [Globals setHots:hl];
                                     hotList = hl;
                                     
                                     NSMutableArray *actuList = [all objectForKey:@"actus"];
                                     NSLog(@"Actus %@ ", actuList);
                                     [Globals setActus:actuList];
                                     actus = actuList;
                                     
                                     NSMutableArray *topsWeek = [all objectForKey:@"topWeek"];
                                     NSLog(@"week %@ ", topsWeek);
                                     [Globals setTopsWeek:topsWeek];
                                     topWeek = topsWeek;
                                     
                                     NSMutableArray *topsMonth = [all objectForKey:@"topMonth"];
                                     NSLog(@"month %@ ", topsMonth);
                                     [Globals setTopsMonth:topsMonth];
                                     topMonth = topsWeek;
                                      
                                     isSearchResult = YES;
                                     [self performSelectorOnMainThread:@selector(reloadAndRewind) withObject:nil waitUntilDone: NO];
                                     //[self.ArticleTableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
                                     NSLog(@"ReloadedTableView");
                                    
                                     loading = false;

                                 }];
}

- (void) reloadAndRewind{
    [self.ArticleTableView reloadData];
    [self.ArticleTableView setContentOffset:CGPointZero animated:YES];
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void) setIdUnivers:(NSNumber*) lIdUnivers{
    idUnivers = lIdUnivers;
}

- (void) HotTapped:(NSString*) n{
    isHotTapped = YES;
    hotIdPub = [NSString stringWithString:n];
    NSLog(@"YAAAA");
    [self performSegueWithIdentifier: @"toArticle" sender: self];
}

- (void)viewDidLoad {
    hotPageControl = nil;
    UIImage *splashImage;
    //self.SplashScreen.image = splashImage;
    [super viewDidLoad];
    loading = false;
    buttonSelected = 1;
    isSearchResult = FALSE;
    isHotTapped = FALSE;
    HotDisplayedHeight = 255.0;
    SelectedColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
    UnselectedColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.3];
    
    NSLog(@"reload category id to zero");
    idCategory = @0;
    
    // Request the data from globals
    actus = [Globals getActus];
    topWeek = [Globals getTopsWeek];
    topMonth = [Globals getTopsMonth];
    hotList = [Globals getHots];
    
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
    
    // Set publication Id
    //NSLog(@"get PubId %@",[FanActuHTTPRequest getParameter:@"idPublication" fromArticles:hotList withIndex:index]);
    [hotView setPublicationId:[FanActuHTTPRequest getParameter:@"idPublication" fromArticles:hotList withIndex:index]];
    [hotView setCallBack:self];
    
    // Image
    NSString *strImgUrl = [FanActuHTTPRequest getParameter:@"visuel" fromArticles:hotList withIndex:index];
    //NSLog(@"%@",strImgUrl);
    [hotView.image sd_setImageWithURL:[NSURL URLWithString:strImgUrl] placeholderImage:[UIImage imageNamed:@"placeholderImg.jpg"]];
    //hotView.clipsToBounds = TRUE;
    // Configure the Category
    NSString *strCategory = [FanActuHTTPRequest getParameter:@"categorie" fromArticles:hotList withIndex:index];
    [hotView.category setText:[strCategory uppercaseString]];
    
    // Configure the Cell author
    //NSString *strAutor = [FanActuHTTPRequest getParameter:@"author" fromArticles:hotList withIndex:index];
    //[hotView.WhenWho setText:strAutor];
    
    // Configure the Cell title
    NSString *strTitle = [FanActuHTTPRequest getParameter:@"titre" fromArticles:hotList withIndex:index];
    [hotView.Title setText:[strTitle uppercaseString]];
    
    return hotView;
}

- (void)swipeViewWillBeginDragging:(SwipeView *)swipeView {
    

}

/*
- (void)swipeViewDidEndDragging:(SwipeView *)swipeView willDecelerate:(BOOL)decelerate;
{
    NSArray *views = [swipeView visibleItemViews];
    for(HotView *hv in views){
        hv.clipsToBounds = FALSE;
    }
}*/

- (void)swipeViewDidScroll:(SwipeView *)swipeView{
    // MAke this differential?
    hotPageControl.currentPage = swipeView.currentItemIndex;
    /*NSArray *views = [swipeView visibleItemViews];
    for(HotView *hv in views){
        hv.clipsToBounds = TRUE;
    }*/
}

/*
- (CGSize)swipeViewItemSize:(SwipeView *)swipeView {
    //NSLog(@"s = %f",swipeView.frame.size.width);
    return CGSizeMake(swipeView.frame.size.width, HotDisplayedHeight);
}
 */

// =========== UITableView Delegates ===========

- (NSMutableArray*) getDisplayedArticleList{
    NSMutableArray *articleList;
    switch(buttonSelected) {
        default:
        case 1:
            articleList = actus;
            break;
        case 2:
            articleList = topWeek;
            break;
        case 3:
            articleList = topMonth;
    }
    return articleList;
}

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
        NSMutableArray *articleList = [self getDisplayedArticleList];
        if(indexPath.row != [articleList count]) {
            // Get a cell
            cell = [tableView dequeueReusableCellWithIdentifier:@"ArticleRow" forIndexPath:indexPath];
            
            // Configure the Cell img
            UIImageView *img = (UIImageView *)[cell.contentView viewWithTag:20];
            NSString *strImgUrl = [FanActuHTTPRequest getParameter:@"img" fromArticles:articleList withIndex:indexPath.row];
            NSLog(@"url %@",strImgUrl);
            [img sd_setImageWithURL:[NSURL URLWithString:strImgUrl] placeholderImage:[UIImage imageNamed:@"placeholderImg.jpg"]];
            
            // Configure the Cell author
            //UILabel *Who = (UILabel *)[cell.contentView viewWithTag:12];
            NSString *strAutor = [FanActuHTTPRequest getParameter:@"author" fromArticles:articleList withIndex:indexPath.row];
            //[Who setText:strAutor];
            
            // Configure the Cell title
            UILabel *Title = (UILabel *)[cell.contentView viewWithTag:10];
            NSString *strTitle = [FanActuHTTPRequest getParameter:@"titre" fromArticles:articleList withIndex:indexPath.row];
            [Title setText:[strTitle uppercaseString]];
            
            // Configure the Cell time
            UILabel *Time = (UILabel *)[cell.contentView viewWithTag:11];
            NSString *strDate = [FanActuHTTPRequest getParameter:@"date" fromArticles:articleList withIndex:indexPath.row];
            NSString *dateAutor = [strDate stringByAppendingString:[NSString stringWithFormat:@" | Par %@",strAutor]];
            [Time setText:dateAutor];
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
    else {
        NSMutableArray *articleList = [self getDisplayedArticleList];
        if(isSearchResult) {
            return [articleList count]; // when this is a search result don't add the activity indicator
        } else {
            return [articleList count] + 1;
        }
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
        // This is not very clean, we need to reload only the section headerTouch
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
            UIImageView *arrowView = [[UIImageView alloc] initWithFrame:CGRectMake(B1.frame.size.width/2-imgW/2,B1.frame.size.height-3, imgW, imgH)];
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
            UIImageView *arrowView = [[UIImageView alloc] initWithFrame:CGRectMake(B1.frame.size.width/2-imgW/2,B2.frame.size.height-3, imgW, imgH)];
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
            UIImageView *arrowView = [[UIImageView alloc] initWithFrame:CGRectMake(B1.frame.size.width/2-imgW/2,B3.frame.size.height-3, imgW, imgH)];
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
    
    CGFloat fullOpacityHeight = 120.0;
    // navbar background opacity
    if ((actualPosition<=fullOpacityHeight)&&(actualPosition>0)){
        CGFloat opacity = 1.0-(fullOpacityHeight-actualPosition)/fullOpacityHeight;
        //NSLog(@"opacity %f",opacity);
        self.NavBar.backgroundColor = [self.NavBar.backgroundColor colorWithAlphaComponent:opacity];
    } else if (actualPosition>fullOpacityHeight) {
        self.NavBar.backgroundColor = [self.NavBar.backgroundColor colorWithAlphaComponent:1.0];
    }
    
    // avoid header goes under navbar
    CGFloat navBarHeight = 72;
    //NSLog(@"%f",actualPosition);
    if (actualPosition>=navBarHeight) {
        self.ArticleTableView.contentInset = UIEdgeInsetsMake(navBarHeight, 0, 0, 0);
    } else {
        self.ArticleTableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    }
    
    if(!isSearchResult) {
        // loading next view
        if ((actualPosition >= contentHeight)&& (!loading)) {
            loading = true;
            NSLog(@"Loading next Data idCategory(%ld)",[idCategory integerValue]);
            // Get The date of last requested article
            NSMutableArray *articleList = [self getDisplayedArticleList];
            NSDictionary *lastArticle = [articleList objectAtIndex:[articleList count] - 1];
            NSString *dateString = [lastArticle objectForKey:@"dateTime"];
            dateString = [Globals getEncodedDate:dateString];
            NSLog(@"Last Arcticle %@",dateString);
            [FanActuHTTPRequest requestArticlesWithCategory:idCategory
                                                    univers:@0
                                                       date:dateString
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
            //NSLog(@"visiblePart %f",computedVisiblePart);
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
        NSString *destPubId;
        if(!isHotTapped) {
            // Pass the publication Id of selected article
            NSIndexPath *selected = [self.ArticleTableView indexPathForSelectedRow];
            NSMutableArray *articleList = [self getDisplayedArticleList];
            NSDictionary *article = [articleList objectAtIndex:selected.row];
            destPubId = [NSString stringWithFormat:@"%ld",[[article objectForKey:@"idPublication"] integerValue]];
        } else {
            destPubId = hotIdPub;
            isHotTapped = NO;
        }
        ArticleViewController *avc = (ArticleViewController*) segue.destinationViewController;
        [avc setPublicationId:destPubId];
    }
}

@end
