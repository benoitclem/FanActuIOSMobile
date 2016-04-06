//
//  ArticleViewController.m
//  FanActuV2
//
//  Created by Clément BENOIT on 07/03/16.
//  Copyright © 2016 cbenoitp. All rights reserved.
//

#import "ArticleViewController.h"
#import "CustomTableViewCells.h"
#import "UIImageView+WebCache.h"
#import "FanActuHTTPRequest.h"
#import "Globals.h"

#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKShareKit/FBSDKShareKit.h>
//#import <FBSDKLoginKit/FBSDKLoginKit.h>

@import AVFoundation;
@import AVKit;

@interface ArticleViewController ()

@end

@implementation ArticleViewController

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void) loadNetworkData {
    [FanActuHTTPRequest requestArticleWithId:publicationId
                          andCompletionBlock:^(NSData *data, NSURLResponse *response, NSError *error) {
                              // handle response
                              NSDictionary *articleData = [(NSDictionary*)[NSJSONSerialization
                                                                           JSONObjectWithData:data
                                                                           options:NSJSONReadingMutableContainers
                                                                           error:&error] objectForKey:@"article"];
                              
                              NSLog(@"articleData %@", articleData);
                              
                              articleInfos = [articleData objectForKey:@"infos"];
                              articlePages = [[articleData objectForKey:@"content"] objectForKey:@"pages"];
                              articleUnivers = [articleData objectForKey:@"univers"];
                              articleConnex = [articleData objectForKey:@"recommandations"];
                              
                              NSDictionary *coverDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                                        [NSNumber numberWithInt:-1],@"ident",
                                                        [articleInfos objectForKey:@"visuelCover"],@"visualCover",
                                                        [articleInfos objectForKey:@"categorie"],@"category",nil];
                              NSDictionary *titleDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                                        [NSNumber numberWithInt:0],@"ident",
                                                        [articleInfos objectForKey:@"titre"],@"title",
                                                        [articleInfos objectForKey:@"datePublication"],@"when",
                                                        [articleInfos objectForKey:@"auteur"],@"who",nil];
                              NSDictionary *shareDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                                        [NSNumber numberWithInt:1],@"ident",
                                                        [articleInfos objectForKey:@"shares"],@"shares",nil];
                              
                              composedArticle = [NSMutableArray arrayWithObjects:coverDic,titleDic,shareDic,nil];
                              
                              
                              for(NSDictionary *page in articlePages) {
                                  NSArray *blocs = [page objectForKey:@"blocs"];
                                  for(NSDictionary *bloc in blocs) {
                                      //NSLog(@"BLOCS %@",bloc);
                                      if ([[bloc objectForKey:@"type"] integerValue] == 1){
                                          // Paragraph
                                          if([(NSString*)[bloc objectForKey:@"value"] compare:@""] != NSOrderedSame) {
                                              NSDictionary *paragDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                                                        [ NSNumber numberWithInt:2],@"ident",
                                                                        [bloc objectForKey:@"value"],@"text",nil];
                                              // NSLog(@"%@",paragDic);
                                              [composedArticle addObject:paragDic];
                                          }
                                      } else if ([[bloc objectForKey:@"type"] integerValue] == 2) {
                                          // Image
                                          NSDictionary *imgDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                                                  [ NSNumber numberWithInt:3],@"ident",
                                                                  [bloc objectForKey:@"value"],@"imgLink",
                                                                  [bloc objectForKey:@"copyright"],@"copyright",nil];
                                          [composedArticle addObject:imgDic];
                                          // This is a dynamic load
                                          SDWebImageManager *manager = [SDWebImageManager sharedManager];
                                          [manager downloadImageWithURL:[NSURL URLWithString:[bloc objectForKey:@"value"]]
                                                                options:0
                                                               progress:^(NSInteger receivedSize, NSInteger expectedSize)
                                           {
                                               //NSLog(@"Loading image %@ - %ld/%ld",[bloc objectForKey:@"value"],receivedSize,expectedSize);
                                           }
                                                              completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageUrl) {
                                                                  //NSLog(@"Error %@",error);
                                                                  long n = [((NSNumber*)[bloc objectForKey:@"idBloc"]) integerValue];
                                                                  float ratio = image.size.width / image.size.height;
                                                                  //NSLog(@"Caching images %f",ratio);
                                                                  [imgRatiosCache setValue:[NSNumber numberWithFloat:ratio] forKey:[NSString stringWithFormat:@"%ld",n ]] ;
                                                              }
                                           ];
                                      } else if (([[bloc objectForKey:@"type"] integerValue] == 3) ||
                                                 ([[bloc objectForKey:@"type"] integerValue] == 4) ||
                                                 ([[bloc objectForKey:@"type"] integerValue] == 6)) {
                                          int ident = 0;
                                          switch([[bloc objectForKey:@"type"] integerValue]) {
                                              case 3:
                                                  ident = 4;
                                                  break;
                                              case 4:
                                                  ident = 5;
                                                  break;
                                              case 6:
                                                  ident = 6;
                                                  break;
                                          }
                                          // Youtube
                                          NSDictionary *vidDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                                                  [ NSNumber numberWithInt:ident],@"ident",
                                                                  [bloc objectForKey:@"value"],@"id",
                                                                  [NSNumber numberWithFloat:1.5],@"ratio", nil];
                                          [composedArticle addObject:vidDic];
                                      } else if ([[bloc objectForKey:@"type"] integerValue] == 5) {
                                          NSDictionary *annecDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                                                    [NSNumber numberWithInt:10],@"ident",
                                                                    [bloc objectForKey:@"value"],@"subtitle", nil];
                                          
                                          [composedArticle addObject:annecDic];
                                      } else if ([[bloc objectForKey:@"type"] integerValue] == 8) {
                                          NSDictionary *annecDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                                                    [NSNumber numberWithInt:9],@"ident",
                                                                    [bloc objectForKey:@"titre"],@"title",
                                                                    [bloc objectForKey:@"value"],@"anecdote",
                                                                    [bloc objectForKey:@"photo"],@"photo",
                                                                    [bloc objectForKey:@"copyright"],@"copyright",nil];
                                          
                                          [composedArticle addObject:annecDic];
                                      }
                                  }
                              }
                              
                              NSDictionary *footBar = [NSDictionary dictionaryWithObjectsAndKeys:
                                                       [NSNumber numberWithInt:7],@"ident",nil];
                              [composedArticle addObject:footBar];
                              
                              //NSLog(@"Connexes %@",articleConnex);
                              int nConnexes = 0;
                              for(NSDictionary *article in articleConnex) {
                                  if(nConnexes<5) {
                                      NSDictionary *connexe = [NSDictionary dictionaryWithObjectsAndKeys:
                                                               [NSNumber numberWithInt:8],@"ident",
                                                               [article objectForKey:@"titre"],@"title",
                                                               [article objectForKey:@"datePublication"],@"when",
                                                               [article objectForKey:@"idPublication"],@"idPub",
                                                               [article objectForKey:@"auteur"],@"who",
                                                               [article objectForKey:@"image"],@"photo",
                                                               [article objectForKey:@"shares"],@"shares",nil];
                                      [composedArticle addObject:connexe];
                                      nConnexes++;
                                  }
                              }
                              //NSLog(@" %@ ", articleData);
                              
                              [self performSelectorOnMainThread:@selector(reloadAndRewind) withObject:nil waitUntilDone:NO];
                              
                              NSLog(@"ReloadedTableView");
                              
                          }];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    imgRatiosCache = [NSMutableDictionary dictionary];
    
    //NSLog(@"frame %f, %f",self.view.frame.size.width,self.view.frame.size.height);
    
    NSLog(@"ArticleViewController Load %@",publicationId);

    [self loadNetworkData];
    
    // Do any additional setup after loading the view, typically from a nib.
    if(NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_7_1) {
        self.articleTable.estimatedRowHeight = 100.0;
        self.articleTable.rowHeight = UITableViewAutomaticDimension;
    }
}

- (void) reloadAndRewind{
    [self.articleTable reloadData];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.articleTable scrollToRowAtIndexPath:indexPath
                         atScrollPosition:UITableViewScrollPositionTop
                                 animated:YES];
    //[self.articleTable setContentOffset:CGPointZero animated:YES];
}

- (void)attributedLabel:(TTTAttributedLabel *)label
   didSelectLinkWithURL:(NSURL *)url {
    NSLog(@"Clicked URL: %@",url);
    NSString *sUrl = [url absoluteString];
    NSArray *aUrl = [sUrl componentsSeparatedByString:@"/"];
    NSLog(@"%@",aUrl);
    if([(NSString*)[aUrl objectAtIndex:2] isEqualToString:@"www.fanactu.com"]){
        NSLog(@"Internal link");
        if([(NSString*)[aUrl objectAtIndex:3] isEqualToString:@"univers"]){
            NSLog(@"You clicked on Univers %@",[aUrl objectAtIndex:5]);
        } else {
            NSLog(@"You clicked on Article %@",[aUrl objectAtIndex:5]);
            publicationId = [NSString stringWithString: [aUrl objectAtIndex:5]];
            [self loadNetworkData];
        }
    } else {
        NSLog(@"External link");
        [[UIApplication sharedApplication] openURL:url];
    }
    //NSURL *myURL = [NSURL URLWithString:@"todolist://www.acme.com?Quarterly%20Report#200806231300"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) setPublicationId:(NSString*) pId {
    publicationId = [NSString stringWithString:pId];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    return [composedArticle count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    // Get the Cell type
    NSDictionary *blockOfInterest = (NSDictionary*)[composedArticle objectAtIndex:indexPath.row];
    NSNumber *blockId = (NSNumber*)[blockOfInterest objectForKey:@"ident"];
    NSLog(@"HERE %@ - %ld",blockId, indexPath.row);
    switch ([blockId integerValue]) {
        case -1: {
            ImageHeaderCell *myCell = (ImageHeaderCell*)[tableView dequeueReusableCellWithIdentifier:@"ImageHeader" forIndexPath:indexPath];
            NSString *visualCoverUrl = (NSString *)[blockOfInterest objectForKey:@"visualCover"];
            NSString *category = (NSString *)[blockOfInterest objectForKey:@"category"];
            //NSLog(@"%@",visualCoverUrl);
            [myCell.Image sd_setImageWithURL:[NSURL URLWithString:visualCoverUrl] placeholderImage:[UIImage imageNamed:@"placeholderImg.jpg"]];
            myCell.Image.clipsToBounds = true;
            [myCell.Category setText:[category uppercaseString]];
            cell = myCell;
            break;
            }
        case 0: {
            TitleCell *myCell = (TitleCell*)[tableView dequeueReusableCellWithIdentifier:@"Title" forIndexPath:indexPath];
            NSString *title = (NSString *)[blockOfInterest objectForKey:@"title"];
            NSString *when = (NSString *)[blockOfInterest objectForKey:@"when"];
            NSString *who = (NSString *)[blockOfInterest objectForKey:@"who"];
            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
            paragraphStyle.minimumLineHeight = 32.f;
            paragraphStyle.maximumLineHeight = 32.f;
        
            UIFont *font = [UIFont fontWithName:@"RobotoCondensed-Bold" size:29.f];
            //UIFont *font = [UIFont fontWithName:@"AmericanTypewriter" size:18.f];
            NSDictionary *attributtes = @{
                                          NSParagraphStyleAttributeName : paragraphStyle,
                                          };
            myCell.Title.font = font;
            myCell.Title.attributedText = [[NSAttributedString alloc] initWithString:[title uppercaseString]
                                                                           attributes:attributtes];
            //[myCell.Title setText:[title uppercaseString]];
            NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
            [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            NSDate *date = [dateFormat dateFromString:when];
            NSString *strDate = [Globals getDateStringWithDate:date];
            [myCell.WhenWho setText:[NSString stringWithFormat:@"%@ | Par %@",strDate,[who uppercaseString]]];
            cell = myCell;
            break;
        }
        case 1: {
            ShareCell *myCell = (ShareCell*)[tableView dequeueReusableCellWithIdentifier:@"Share" forIndexPath:indexPath];
            NSNumber *nShares = [blockOfInterest objectForKey:@"shares"];
            NSString *shares;
            if([nShares integerValue]> 100000) {
                shares = [NSString stringWithFormat:@"%.0fK",([nShares floatValue]/1000.0)];
            } else if ([nShares integerValue]> 10000) {
                shares = [NSString stringWithFormat:@"%.1fK",([nShares floatValue]/1000.0)];
            } else if ([nShares integerValue]> 1000) {
                shares = [NSString stringWithFormat:@"%.1fK",([nShares floatValue]/1000.0)];
            } else {
                shares = [NSString stringWithFormat:@"%ld",[nShares integerValue]];
            }
            [myCell.shares setText:shares];
            /*
            http://www.facebook.com/sharer.php?u=http%3A%2F%2Fwww.fanactu.com%2Fdossiers%2Fcinema%2F5388%2Fune-premiere-bande-annonce-pour-dejante-swiss-army-man-avec-daniel-radcliffe.html
             */
            /*
            FBSDKLikeControl *button = [[FBSDKLikeControl alloc] init];
            button.objectID = @"https://www.facebook.com/FacebookDevelopers";
            */
            /*
            FBSDKLikeButton *button = [[FBSDKLikeButton alloc] init];
            button.objectID =  @"https://www.facebook.com/FacebookDevelopers";
            [myCell addSubview:button];*/
            cell = myCell;
            break;
        }
        case 2: {
            ParagraphCell *myCell = (ParagraphCell*)[tableView dequeueReusableCellWithIdentifier:@"Paragraph" forIndexPath:indexPath];
            
            NSMutableString *richText = [NSMutableString stringWithFormat: @"<style>body{font-family:'Arial';font-size:%fpx; text-align:justify; margin-top:0px; margin-botom:0px;}</style>",myCell.Text.font.pointSize];
            [richText appendString:[blockOfInterest objectForKey:@"text"]];
            NSData *richTextData = [richText dataUsingEncoding:NSUnicodeStringEncoding];
            NSDictionary *options = @{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,
                                     NSCharacterEncodingDocumentAttribute: @(NSUnicodeStringEncoding)};
            
            NSAttributedString *attString2 = [[NSAttributedString alloc] initWithData:richTextData
                                             options:options
                                  documentAttributes:nil
                                               error:nil];
            
            myCell.Text.attributedText = attString2;
            
            //NSLog(@"attString2 %@",richText);
            
            [attString2 enumerateAttribute:NSLinkAttributeName inRange:NSMakeRange(0, attString2.length) options:0 usingBlock:^(id value, NSRange range, BOOL *stop) {
                if (value) {
                    NSLog(@"value %ld,%ld - %@",range.location,range.length,value);
                    [myCell.Text addLinkToURL:value withRange:range];
                }
            }];
            
            // Configure TTTAttributedLAbel
            myCell.Text.delegate = self;
            myCell.Text.userInteractionEnabled=YES;
            
            //[myCell.Text setText:richText];
            cell = myCell;
            break;
             
        }
        case 3: {
            ImageCell *myCell = (ImageCell*)[tableView dequeueReusableCellWithIdentifier:@"Image" forIndexPath:indexPath];
            NSString *imgLink = [blockOfInterest objectForKey:@"imgLink"];
            [myCell.Image sd_setImageWithURL:[NSURL URLWithString:imgLink] placeholderImage:[UIImage imageNamed:@"placeholderImg.jpg"]];
            /*[myCell.Image sd_setImageWithURL:[NSURL URLWithString:imgLink]
                            placeholderImage:[UIImage imageNamed:@"placeholderImg.jpg"]
                                   completed:^(UIImage *image, NSError *error, SDImageCacheType cacheTpe, NSURL *imgUrl){
                                       // save height of an image to some cache
                                       NSNumber *imHeight = [NSNumber numberWithFloat:image.size.height];
                                       [imgHeightsCache setObject:imHeight forKey:indexPath];
                                       
                                       //[self.tableView beginUpdates];
                                       [self.tableView reloadRowsAtIndexPaths:@[indexPath]
                                                        withRowAnimation:UITableViewRowAnimationFade];
                                       //[self.tableView endUpdates];
                                   }];*/
            
            cell = myCell;
            break;
        }
        case 4:
        case 5:
        case 6:{
            VideoCell *myCell = (VideoCell*)[tableView dequeueReusableCellWithIdentifier:@"Video" forIndexPath:indexPath];
            NSString *videoId = [blockOfInterest objectForKey:@"id"];
            NSString *providerUrl;
            switch([blockId integerValue]){
                case 4:
                    providerUrl = @"http://www.youtube.com/embed/%@";
                    break;
                case 5:
                    providerUrl = @"http://www.dailymotion.com/embed/video/%@?autoplay=1&mute=1";
                    break;
                case 6:
                    providerUrl = @"http://www.youtube.com/embed/%@";
                    break;
            }
            float width = myCell.frame.size.width - 16*2;
            float height = myCell.frame.size.height - 8*2;
            NSString *embedHTML = @"\
            <html>\
            <head>\
            <style type=\"text/css\">html,body,iframe{background-color: transparent; color: black; margin:0; padding:0;}</style>\
            </head>\
            <body>\
            <iframe class=\"player\" type=\"text/html\" width=\"%fpx\" height=\"%fpx\" src=\"%@\" frameborder=\"0\"></iframe>\
            </body>\
            </html>";
            NSString *strHtml = [NSString stringWithFormat:embedHTML,width,height,[NSString stringWithFormat:providerUrl,videoId]];
            [myCell.VideoView  loadHTMLString:strHtml baseURL:nil];
            myCell.VideoView.scrollView.scrollEnabled = NO;
            myCell.VideoView.scrollView.bounces = NO;
            cell = myCell;
            break;
        }
        case 7: {
            cell = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"FooterBar" forIndexPath:indexPath];
            /*UIImage *arrow = [UIImage imageNamed:@"flechejaune"];
            CGFloat imgW = arrow.size.width;
            CGFloat imgH = arrow.size.height;
            UIImageView *arrowView = [[UIImageView alloc] initWithFrame:CGRectMake(cell.frame.size.width/2-imgW/2,cell
                                                                                   .frame.size.height-3, imgW, imgH)];
            arrowView.image = arrow;
            [cell addSubview:arrowView];*/
            cell.clipsToBounds = false;
            break;
        }
        case 8: {
            WantMoreCell *myCell = (WantMoreCell*)[tableView dequeueReusableCellWithIdentifier:@"WantMore" forIndexPath:indexPath];
            NSString *title = (NSString *)[blockOfInterest objectForKey:@"title"];
            NSString *when = (NSString *)[blockOfInterest objectForKey:@"when"];
            NSString *who = (NSString *)[blockOfInterest objectForKey:@"who"];
            NSString *idPub = (NSString *)[blockOfInterest objectForKey:@"idPub"];
            NSNumber *nShares = [blockOfInterest objectForKey:@"shares"];
            NSString *shares;
            if([nShares integerValue]> 100000) {
                shares = [NSString stringWithFormat:@"%.0fK",([nShares floatValue]/1000.0)];
            } else if ([nShares integerValue]> 10000) {
                shares = [NSString stringWithFormat:@"%.1fK",([nShares floatValue]/1000.0)];
            } else if ([nShares integerValue]> 1000) {
                shares = [NSString stringWithFormat:@"%.1fK",([nShares floatValue]/1000.0)];
            } else {
                shares = [NSString stringWithFormat:@"%ld",[nShares integerValue]];
            }
            NSString *imgLink = (NSString *)[blockOfInterest objectForKey:@"photo"];
            [myCell.Title setText:[title uppercaseString]];
            [myCell.WhoWhen setText:[NSString stringWithFormat:@"%@ | par %@",when,[who uppercaseString]]];
            [myCell.Shares setText:shares];
            [myCell.image sd_setImageWithURL:[NSURL URLWithString:imgLink] placeholderImage:[UIImage imageNamed:@"placeholderImg.jpg"]];
            
            [myCell.SensitiveOverlay setValue:idPub];
            [myCell.SensitiveOverlay addTarget:self action:@selector(wantMoreTouched:) forControlEvents:UIControlEventTouchUpInside];
            cell = myCell;
            break;
        }
        case 9: {
            AnecdoteCell *myCell = (AnecdoteCell*)[tableView dequeueReusableCellWithIdentifier:@"Anecdote" forIndexPath:indexPath];
            NSString *title = (NSString *)[blockOfInterest objectForKey:@"title"];
            NSString *imgLink = (NSString *)[blockOfInterest objectForKey:@"photo"];
            NSString *anecdoteString = (NSString *)[blockOfInterest objectForKey:@"anecdote"];
            NSLog(@"title %@", title);
            NSLog(@"anecdote %@", anecdoteString);
            [myCell.title setText:title];
            [myCell.anecdote setText:anecdoteString];
            [myCell.image sd_setImageWithURL:[NSURL URLWithString:imgLink] placeholderImage:[UIImage imageNamed:@"placeholderImg.jpg"]];
            cell = myCell;
            break;
        }
        case 10: {
            //NSLog(@"CACA");
            SubtitleCell *myCell = (SubtitleCell*)[tableView dequeueReusableCellWithIdentifier:@"Subtitle" forIndexPath:indexPath];
            NSString *Subtitle = (NSString *)[blockOfInterest objectForKey:@"subtitle"];
            NSLog(@"Subtitle: %@",Subtitle);
            //[myCell.Subtitle setText:[Subtitle uppercaseString]];
            
            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
            paragraphStyle.minimumLineHeight = 25.f;
            paragraphStyle.maximumLineHeight = 25.f;
            
            UIFont *font = [UIFont fontWithName:@"RobotoCondensed-Bold" size:22.f];
            //UIFont *font = [UIFont fontWithName:@"AmericanTypewriter" size:18.f];
            NSDictionary *attributtes = @{
                                          NSParagraphStyleAttributeName : paragraphStyle,
                                          };
            myCell.Subtitle.font = font;
            myCell.Subtitle.attributedText = [[NSAttributedString alloc] initWithString:[Subtitle uppercaseString]
                                                                          attributes:attributtes];
            
            cell = myCell;
            break;
        }
        default: {
            EmptyCell *myCell = (EmptyCell*)[tableView dequeueReusableCellWithIdentifier:@"Empty" forIndexPath:indexPath];
            cell = myCell;
            break;
        }
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    // try to get image height from your own heights cache
    // if its is not there return default one
    NSDictionary *blockOfInterest = (NSDictionary*)[composedArticle objectAtIndex:indexPath.row];
    NSNumber *blockId = (NSNumber*)[blockOfInterest objectForKey:@"ident"];
    float margin = 8.0;
    float width = self.view.frame.size.width - 2*margin;
    switch ([blockId integerValue]) { //Img
        case 3: {
            
            if(indexPath.row>2) {
                
                NSNumber *ratio = [imgRatiosCache objectForKey:[NSString stringWithFormat:@"%ld",(long)indexPath.row-2]];
                //NSLog(@"1 -%@",ratio);
                if(ratio) {
                    float height = width/[ratio floatValue];
                    //NSLog(@"1 heightForRow %f",height);
                    return height+2*margin;
                }
            }
        }
        case 4:
        case 5:
        case 6: {
            NSNumber *ratio = [blockOfInterest objectForKey:@"ratio"];
            if(ratio){
                float height = width/[ratio floatValue];
                //NSLog(@"2 heightForRow %f",height);
                return height+2*margin;
            }
        }
        default: {
            return UITableViewAutomaticDimension;
        }
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView_
{
    CGFloat actualPosition = scrollView_.contentOffset.y;
    
    // Do the nice resizing stuffs for carousel
    // Get visible cells on table view.
    NSArray *visibleCells = [self.tableView visibleCells];
    NSArray *visibleIndexes = [self.tableView indexPathsForVisibleRows];
    int index = 0;
    for(NSIndexPath *visibleIndex in visibleIndexes) {
        if((visibleIndex.section == 0)&&(visibleIndex.row == 0)) {
            //NSLog(@"%ld %ld",visibleIndex.section,visibleIndex.row);
            UITableViewCell *cell = [visibleCells objectAtIndex:index];
            // /!\ sometime the lenght of visibleCells and indexPAthForVisibleRows
            // are not the same so check nature for woring cell
            if([cell isKindOfClass:[ImageHeaderCell class]] ) {
                ImageHeaderCell *ivc = (ImageHeaderCell*)cell;
                CGFloat computedVisiblePart = 197-actualPosition;
                //NSLog(@"visiblePart %f",computedVisiblePart);
                ivc.clipsToBounds = computedVisiblePart<197;
                ivc.Image.frame = (CGRectMake(0,-computedVisiblePart+197, ivc.Image.frame.size.width, computedVisiblePart));
            }
        }
        index++;
    }
}

- (void) wantMoreTouched:(id) sender {
    UIButtonWithData *but = (UIButtonWithData*) sender;
    NSString *idPub = [but getValue];
    publicationId = idPub;
    NSLog(@"WantMoreTouhed %@",idPub);
    [self loadNetworkData];
}

/*
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}
*/

#pragma mark - Navigation
/*
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSLog(@"what %@",segue.identifier);
    if([segue.identifier isEqualToString:@"toSelf"]) {
        NSLog(@"what %@",segue.identifier);
        UIButtonWithData *but = (UIButtonWithData*) sender;
        NSString *idPub = [but getValue];
        NSLog(@"WantMoreTouhed %@",idPub);
        ArticleViewController *avc = (ArticleViewController*) segue.destinationViewController;
        [avc setPublicationId:idPub];
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
}
*/
@end
