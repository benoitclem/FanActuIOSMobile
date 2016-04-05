//
//  ArticleListViewController.m
//  FanActu
//
//  Created by Clément BENOIT on 27/02/16.
//  Copyright (c) 2016 FanActu. All rights reserved.
//

#import "ArticleListViewController.h"
#import "ArticleViewController.h"
#import "CustomTableViewCells.h"
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
    noMoreResults = false;
    // Select by universe drop the category stuffs
    idCategory = @0;
    [FanActuHTTPRequest requestArticlesWithCategory:idCategory
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
                             //NSLog(@"Hot %@ ", hl);
                             [Globals setHots:hl];
                             hotList = hl;
                             
                             NSMutableArray *actuList = [all objectForKey:@"actus"];
                             NSLog(@"Actus %@ ", actuList);
                             [Globals setActus:actuList];
                             actus = actuList;
                             
                             NSMutableArray *topsWeek = [all objectForKey:@"topWeek"];
                             //NSLog(@"week %@ ", topsWeek);
                             [Globals setTopsWeek:topsWeek];
                             topWeek = topsWeek;
                             
                             NSMutableArray *topsMonth = [all objectForKey:@"topMonth"];
                             //NSLog(@"month %@ ", topsMonth);
                             [Globals setTopsMonth:topsMonth];
                             topMonth = topsWeek;
                             
                             isSearchResult = NO;
                            buttonSelected = 1;
                             [self performSelectorOnMainThread:@selector(reloadAndRewind) withObject:nil waitUntilDone: NO];
                             //[self.ArticleTableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
                             NSLog(@"ReloadedTableView");
                             loading = false;
                            
                             // Set a non TRUE value to idCategory, it pushes the view to reload
                             // corectly when goes from univers to all ACTUS
                             idCategory = @-2;
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
    // Select by category drop the universe thing
    idUnivers = @0;
    noMoreResults = false;
    if([idCategory integerValue] != oldIdCategory) {
        // Need to reflesh the feed
        NSLog(@"Need to refresh the feed");
        NSString *encodedDate = [Globals getEncodedDate:nil];
        loading = true;
        [FanActuHTTPRequest requestArticlesWithCategory:idCategory
                                                univers:idUnivers
                                                   date:encodedDate
                                     andCompletionBlock:^(NSData *data, NSURLResponse *response, NSError *error){
                                         NSMutableDictionary * all = [NSJSONSerialization
                                                                      JSONObjectWithData:data
                                                                      options:NSJSONReadingMutableContainers
                                                                      error:&error];
                                         
                                         // handle response
                                         NSMutableArray *hl = [all objectForKey:@"hot"];
                                         //NSLog(@"Hot %@ ", hl);
                                         [Globals setHots:hl];
                                         hotList = hl;
                                         
                                         NSMutableArray *actuList = [all objectForKey:@"actus"];
                                         //NSLog(@"Actus %@ ", actuList);
                                         [Globals setActus:actuList];
                                         actus = actuList;
                                         
                                         NSMutableArray *topsWeek = [all objectForKey:@"topWeek"];
                                         //NSLog(@"week %@ ", topsWeek);
                                         [Globals setTopsWeek:topsWeek];
                                         topWeek = topsWeek;
                                         
                                         NSMutableArray *topsMonth = [all objectForKey:@"topMonth"];
                                         //NSLog(@"month %@ ", topsMonth);
                                         [Globals setTopsMonth:topsMonth];
                                         topMonth = topsMonth;
                                         
                                         isSearchResult = NO;
                                         buttonSelected = 1;
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
                                     
                                     //NSLog(@"search result %@",all);
                                     
                                     // handle response
                                     NSMutableArray *hl = [all objectForKey:@"hot"];
                                     //NSLog(@"Hot %@ ", hl);
                                     [Globals setHots:hl];
                                     hotList = hl;
                                     
                                     NSMutableArray *actuList = [all objectForKey:@"actus"];
                                     //NSLog(@"Actus %@ ", actuList);
                                     [Globals setActus:actuList];
                                     actus = actuList;
                                     
                                     NSMutableArray *topsWeek = [all objectForKey:@"topWeek"];
                                     //NSLog(@"week %@ ", topsWeek);
                                     [Globals setTopsWeek:topsWeek];
                                     topWeek = topsWeek;
                                     
                                     NSMutableArray *topsMonth = [all objectForKey:@"topMonth"];
                                     //NSLog(@"month %@ ", topsMonth);
                                     [Globals setTopsMonth:topsMonth];
                                     topMonth = topsMonth;
                                      
                                     isSearchResult = YES;
                                     buttonSelected = 1;
                                     [self performSelectorOnMainThread:@selector(reloadAndRewind) withObject:nil waitUntilDone: NO];
                                     //[self.ArticleTableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
                                     NSLog(@"ReloadedTableView");
                                    
                                     loading = false;
                                     
                                 }];
}

- (void) reloadAndRewind{
    [self.ArticleTableView reloadData];
    //[self.ArticleTableView setContentOffset:CGPointZero animated:YES];
    
     CGRect sectionRect = [self.ArticleTableView rectForSection:0];
     //sectionRect.origin.y -= 72;
     [self.ArticleTableView setContentOffset:sectionRect.origin animated:YES];
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
   // NSLog(@"YAAAA");
    [self performSegueWithIdentifier: @"toArticle" sender: self];
}

- (void)viewDidLoad {
    hotPageControl = nil;
    //UIImage *splashImage;
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

- (void) viewDidAppear:(BOOL)animated {
    //NSLog(@"Appear");
    //int s = 1;
    // When hotlist countain no news don't display the hot stuffs, this mean to add offset on display
    /*if([hotList count] ==0) {
        s = 0;
        self.NavBar.backgroundColor = [self.NavBar.backgroundColor colorWithAlphaComponent:1.0];
        CGRect sectionRect = [self.ArticleTableView rectForSection:s];
        sectionRect.origin.y -= 72;
        [self.ArticleTableView setContentOffset:sectionRect.origin animated:YES];
    }*/
    
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
    //NSLog(@"%f %f",swipeView.frame.size.height,swipeView.frame.size.width);
    [hotView setFrame:swipeView.frame];
    
    // Set publication Id
    //NSLog(@"get PubId %@",[FanActuHTTPRequest getParameter:@"idPublication" fromArticles:hotList withIndex:index]);
    [hotView setPublicationId:[FanActuHTTPRequest getParameter:@"idPublication" fromArticles:hotList withIndex:index]];
    [hotView setCallBack:self];
    
    // Image
    NSString *strImgUrl = [FanActuHTTPRequest getParameter:@"visuel" fromArticles:hotList withIndex:index];
    //NSLog(@"%@",strImgUrl);
    [hotView.image sd_setImageWithURL:[NSURL URLWithString:strImgUrl] placeholderImage:[UIImage imageNamed:@"placeholderImg.jpg"]];
    hotView.clipsToBounds = TRUE;
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

/*
- (void)swipeViewWillBeginDragging:(SwipeView *)swipeView {
    NSArray *views = [swipeView visibleItemViews];
    for(HotView *hv in views){
        hv.clipsToBounds = FALSE;
    }
}

- (void)swipeViewDidEndDragging:(SwipeView *)swipeView willDecelerate:(BOOL)decelerate;
{
    NSArray *views = [swipeView visibleItemViews];
    for(HotView *hv in views){
        hv.clipsToBounds = TRUE;
    }
}
 */

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

- (UITableViewCell *) tableView:(UITableView *)tableView HotCellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"headerHots" forIndexPath:indexPath];
    SwipeView *sview = (SwipeView *)[cell.contentView viewWithTag:10];
    sview.alignment = SwipeViewAlignmentCenter;
    sview.pagingEnabled = YES;
    sview.itemsPerPage = 1;
    sview.truncateFinalPage = YES;
    sview.bounces = NO;
    sview.clipsToBounds = NO;
    hotPageControl = (UIPageControl*)[cell.contentView viewWithTag:30];
    // Trigger the swipe to reload, This reload all the image so there is no loading when swiping
    sw = sview;
    [sview reloadData];
    return cell;
}

- (UITableViewCell *) tableView:(UITableView*)tableView CoverCellForRowAtIndexPath:(NSIndexPath *) indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"headerCover" forIndexPath:indexPath];
    UIImageView *imgView = (UIImageView *)[cell.contentView viewWithTag:10];
    //[imgView sd_setImageWithURL:[NSURL URLWithString:strImgUrl] placeholderImage:[UIImage imageNamed:@"placeholderImg.jpg"]];
    UILabel *universLabel = (UILabel *)[cell.contentView viewWithTag:12];
    if(!isSearchResult)
        [universLabel setText:@"!!UNIVERS!!"];
    else
        [universLabel setText:@""];
    return cell;
}

- (UITableViewCell *) tableView:(UITableView *)tableView ArticleCellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSMutableArray *articleList = [self getDisplayedArticleList];
    // Get a cell
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ArticleRow" forIndexPath:indexPath];
    
    // Configure the Cell img
    UIImageView *img = (UIImageView *)[cell.contentView viewWithTag:20];
    NSString *strImgUrl = [FanActuHTTPRequest getParameter:@"img" fromArticles:articleList withIndex:indexPath.row];
    //NSLog(@"url %@",strImgUrl);
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
    //NSString *strDate = [FanActuHTTPRequest getParameter:@"date" fromArticles:articleList withIndex:indexPath.row];
    NSString *rawStrDate = [FanActuHTTPRequest getParameter:@"dateTime" fromArticles:articleList withIndex:indexPath.row];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [dateFormat dateFromString:rawStrDate];
    NSString *strDate = [Globals getDateStringWithDate:date];
    NSString *dateAutor = [strDate stringByAppendingString:[NSString stringWithFormat:@" | Par %@",strAutor]];
    [Time setText:dateAutor];
    return cell;
}

- (UITableViewCell *) tableView:(UITableView *)tableView LoadingCellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // This is the activity indicator
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LoadingIndicator" forIndexPath:indexPath];
    UIActivityIndicatorView *loadingIndicator = (UIActivityIndicatorView *)[cell.contentView viewWithTag:10];
    [loadingIndicator startAnimating];
    return cell;
}

- (UITableViewCell *) HeaderCellForTableView:(UITableView *)tableView{
    HorizontalStackButtonCell *cell = (HorizontalStackButtonCell*)[tableView dequeueReusableCellWithIdentifier:@"HeaderProg"];
    
    NSLog(@"%p",cell.stackView);
    b1 = [UIButton buttonWithType:UIButtonTypeCustom];
    b1.titleLabel.font = [UIFont fontWithName:@"Fugaz One" size:17.0];
    if(!isSearchResult){
        [b1 setTitle:@"ACTUALITÉS" forState:UIControlStateNormal];
    } else {
        [b1 setTitle:@"RESULTATS" forState:UIControlStateNormal];
    }
    //[b1.heightAnchor constraintEqualToConstant:25].active = true;
    //[b1.widthAnchor constraintEqualToConstant:70].active = true;
    [cell.stackView addArrangedSubview:b1];
    [b1 addTarget:self action:@selector(buttonTouched:) forControlEvents:UIControlEventTouchDown];
    
    // Create the views to be add in the arrow stack View
    UIImageView *uiv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"flechejaune"]];
    uiv.contentMode = UIViewContentModeScaleAspectFit;
    UIView *dum1 = [[UIView alloc] init];
    UIView *dum2 = [[UIView alloc] init];
    UIView *dum3 = [[UIView alloc] init];

    if(buttonSelected == 1) {
        [cell.arrowStackView addArrangedSubview: uiv];
    } else {
        [cell.arrowStackView addArrangedSubview: dum1];
    }

    if(!isSearchResult) {
        if( [topWeek count] != 0) {
            b2 = [UIButton buttonWithType:UIButtonTypeCustom];
            b2.titleLabel.font = [UIFont fontWithName:@"Fugaz One" size:15.0];
            [b2 setTitle:@"TOP SEMAINE" forState:UIControlStateNormal];
            //[b2.heightAnchor constraintEqualToConstant:25].active = true;
            //[b2.widthAnchor constraintEqualToConstant:70].active = true;
            [b2 addTarget:self action:@selector(buttonTouched:) forControlEvents:UIControlEventTouchDown];
            [cell.stackView addArrangedSubview:b2];
            if(buttonSelected == 2) {
                [cell.arrowStackView addArrangedSubview: uiv];
            } else {
                [cell.arrowStackView addArrangedSubview: dum2];
            }
        }
        
        if( [topMonth count] != 0) {
            b3 = [UIButton buttonWithType:UIButtonTypeCustom];
            b3.titleLabel.font = [UIFont fontWithName:@"Fugaz One" size:15.0];
            [b3 setTitle:@"TOP MOIS" forState:UIControlStateNormal];
            //[b3.heightAnchor constraintEqualToConstant:25].active = true;
            //[b3.widthAnchor constraintEqualToConstant:70].active = true;
            [cell.stackView addArrangedSubview:b3];
            [b3 addTarget:self action:@selector(buttonTouched:) forControlEvents:UIControlEventTouchDown];
            if(buttonSelected == 3) {
                [cell.arrowStackView addArrangedSubview: uiv];
            } else {
                [cell.arrowStackView addArrangedSubview: dum3];
            }

        }
    }
    
    [cell layoutIfNeeded]; // <- added
    
    NSLog(@"w %f",b1.frame.size.width);
    NSLog(@"h %f",b1.frame.size.height);
    
    cell.stackView.translatesAutoresizingMaskIntoConstraints = false;
    return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;

    if(indexPath.section == 0){
        NSLog(@"idUnivers = %ld",[idUnivers integerValue]);
        if(([idUnivers integerValue] == 0) && !isSearchResult) {
            cell = [self tableView:tableView HotCellForRowAtIndexPath:indexPath];
        } else {
            cell = [self tableView:tableView CoverCellForRowAtIndexPath:indexPath];
        }
    } else {
        if(indexPath.row != [[self getDisplayedArticleList] count]) {
            cell = [self tableView: tableView ArticleCellForRowAtIndexPath:indexPath];
        } else {
            cell = [self tableView: tableView LoadingCellForRowAtIndexPath:indexPath];
        }
    }
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(section == 0)    // This is the hot section so 1 row
        return 1;
    else {
        NSMutableArray *articleList = [self getDisplayedArticleList];
        return [articleList count];
        /*if(isSearchResult || noMoreResults) {
            return [articleList count]; // when this is a search result don't add the activity indicator
        } else {
            return [articleList count] + 1;
        }*/
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

/* // This is just a prevention of functional selection not visual
- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"About to be selected %@ [%d %@]",indexPath,(isSearchResult)?1:0,idUnivers);
    if( ((indexPath.section == 0) && (indexPath.row == 0)) && (isSearchResult || ([idUnivers integerValue] != 0)) ) {
        NSLog(@"Here");
        return nil;
    } else {
        NSLog(@"Or Here");
        return indexPath;
    }
}
*/

- (void) buttonTouched:(UIButton *)sender {
    // A revoir
    int oldButtonSelected = buttonSelected;
    if(sender == b1) {
        //NSLog(@"B1 TOUCHED");
        b3.titleLabel.font = [UIFont fontWithName:@"Fugaz One" size:17.0];
        buttonSelected = 1;
    } else if(sender == b2) {
        //NSLog(@"B2 TOUCHED");
        buttonSelected = 2;
    } else if(sender == b3){
        //NSLog(@"B3 TOUCHED");
        buttonSelected = 3;
    }
    if(oldButtonSelected != buttonSelected) {
        //NSLog(@"B1 RELOAD");
        // This is not very clean, we need to reload only the section headerTouch
        [self.ArticleTableView reloadData];
    }
    // Make the view goes up when we touch the buttons
    // Take the reference of the section frame and put it just under the header section (72)
    CGRect sectionRect = [self.ArticleTableView rectForSection:1];
    sectionRect.origin.y -= 72;
    [self.ArticleTableView setContentOffset:sectionRect.origin animated:YES];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UITableViewCell *cell;
    if(section == 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"Empty"];
    } else {
        cell = [self HeaderCellForTableView:tableView];
    }
    return (UIView*)cell;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView_
{
    CGFloat actualPosition = scrollView_.contentOffset.y;
    CGFloat contentHeight = scrollView_.contentSize.height - (self.ArticleTableView.frame.size.height+200);
    
    CGFloat navBarHeight = 72;
    
    if(!isSearchResult && !noMoreResults && (buttonSelected == 1)) {
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
                                                    univers:idUnivers
                                                       date:dateString
                                         andCompletionBlock:^(NSData *data, NSURLResponse *response, NSError *error) {
                    if(data) {
                        NSMutableArray *newResults = [(NSMutableDictionary*)[NSJSONSerialization
                                                                     JSONObjectWithData:data
                                                                                options:NSJSONReadingMutableContainers
                                                                                  error:&error] objectForKey:@"actus"];
                       if([newResults count] != 0) {
                           // handle response
                           [articleList addObjectsFromArray: newResults];
                           //NSLog(@" %@ ", articleList);
                           [self.ArticleTableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
                           NSLog(@"ReloadedTableView");
                       } else {
                           noMoreResults = true;
                       }
                   }
                   loading = false;
               }];
        }
    }
    
        
    CGFloat fullOpacityHeight = 120.0;
    // navbar background opacity
    //if ((actualPosition<=fullOpacityHeight)&&(actualPosition>0)){
    if ((actualPosition<=fullOpacityHeight)){
        CGFloat opacity = 1.0-(fullOpacityHeight-actualPosition)/fullOpacityHeight;
        //NSLog(@"opacity %f",opacity);
        self.NavBar.backgroundColor = [self.NavBar.backgroundColor colorWithAlphaComponent:opacity];
    } else if (actualPosition>fullOpacityHeight) {
        self.NavBar.backgroundColor = [self.NavBar.backgroundColor colorWithAlphaComponent:1.0];
    }
    
    // avoid header goes under navbar
    
    //NSLog(@"%f",actualPosition);
    if (actualPosition>=navBarHeight) {
        self.ArticleTableView.contentInset = UIEdgeInsetsMake(navBarHeight, 0, 0, 0);
    } else {
        self.ArticleTableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    }
    
    // Do the nice resizing stuffs for carousel
    // Get visible cells on table view.
    NSArray *visibleCells = [self.ArticleTableView visibleCells];
    NSArray *visibleIndexes = [self.ArticleTableView indexPathsForVisibleRows];
    int index = 0;
    for(NSIndexPath *visibleIndex in visibleIndexes) {
        if((visibleIndex.section == 0)&&(visibleIndex.row == 0)) {
            if(([idUnivers integerValue] == 0) && !isSearchResult) {
                UITableViewCell *tvc = [visibleCells objectAtIndex:index];
                SwipeView *swv = (SwipeView*)[tvc.contentView viewWithTag:10];
                HotView *hv = (HotView*)[swv itemViewAtIndex:swv.currentItemIndex];
                CGFloat computedVisiblePart = 255-actualPosition;
                //NSLog(@"visiblePart %f",computedVisiblePart);
                hv.image.frame = (CGRectMake(0,-computedVisiblePart+255, hv.image.frame.size.width, computedVisiblePart));
                hv.colorOverlay.frame = (CGRectMake(0,-computedVisiblePart+255, hv.image.frame.size.width, computedVisiblePart));
                //CGRect cellSize = [self.ArticleTableView rectForRowAtIndexPath:visibleIndex];
            } else {
                //NSLog(@"Universe Thing");
                CGFloat computedVisiblePart = 255-actualPosition;
                UITableViewCell *tvc = [visibleCells objectAtIndex:index];
                UILabel *universLabel = (UILabel *)[tvc.contentView viewWithTag:12];
                if(isSearchResult) {
                    //[universLabel setText:@"RESULTS"];
                    [universLabel setText:@""];
                } else {
                    [universLabel setText:[NSString stringWithFormat:@"!!%d!!",(int)computedVisiblePart]];
                }
            }
        }
        index++;
    }
    /*
    {
        self.NavBar.backgroundColor = [self.NavBar.backgroundColor colorWithAlphaComponent:1.0];
        self.ArticleTableView.contentInset = UIEdgeInsetsMake(navBarHeight, 0, 0, 0);
    }
    */
    
    // HotView Stuffs
    NSArray *views = [sw visibleItemViews];
    for(HotView *hv in views){
        hv.clipsToBounds = false;
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
