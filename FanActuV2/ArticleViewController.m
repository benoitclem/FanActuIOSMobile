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
@import AVFoundation;
@import AVKit;

@interface ArticleViewController ()

@end

@implementation ArticleViewController

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    NSLog(@"ArticleViewController Load %@",publicationId);

    [FanActuHTTPRequest requestArticleWithId:publicationId 
                               andCompletionBlock:^(NSData *data, NSURLResponse *response, NSError *error) {
                                   // handle response
                                   NSDictionary *articleData = [(NSDictionary*)[NSJSONSerialization
                                                         JSONObjectWithData:data
                                                         options:NSJSONReadingMutableContainers
                                                                  error:&error] objectForKey:@"article"];
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
                                           NSLog(@"BLOCS %@",bloc);
                                           if (([[bloc objectForKey:@"type"] integerValue] == 1) ||
                                               ([[bloc objectForKey:@"type"] integerValue] == 5)) {
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
                                                                       [bloc objectForKey:@"value"],@"id",nil];
                                               [composedArticle addObject:vidDic];
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
                                   
                                   NSLog(@"Connexes %@",articleConnex);
                                   int nConnexes = 0;
                                   for(NSDictionary *article in articleConnex) {
                                       if(nConnexes<5) {
                                           NSDictionary *connexe = [NSDictionary dictionaryWithObjectsAndKeys:
                                                                    [NSNumber numberWithInt:8],@"ident",
                                                                    [article objectForKey:@"titre"],@"title",
                                                                    [article objectForKey:@"datePublication"],@"when",
                                                                    [article objectForKey:@"auteur"],@"who",
                                                                    [article objectForKey:@"image"],@"photo",
                                                                    [article objectForKey:@"shares"],@"shares",nil];
                                           [composedArticle addObject:connexe];
                                           nConnexes++;
                                       }
                                   }
                                   //NSLog(@" %@ ", articleData);
                                   
                                   [self.articleTable performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
                                   
                                   NSLog(@"ReloadedTableView");

                               }];
    
    // Do any additional setup after loading the view, typically from a nib.
    if(NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_7_1) {
        self.articleTable.estimatedRowHeight = 100.0;
        self.articleTable.rowHeight = UITableViewAutomaticDimension;
    }
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
    switch ([blockId integerValue]) {
        case -1: {
            ImageHeaderCell *myCell = (ImageHeaderCell*)[tableView dequeueReusableCellWithIdentifier:@"ImageHeader" forIndexPath:indexPath];
            NSString *visualCoverUrl = (NSString *)[blockOfInterest objectForKey:@"visualCover"];
            NSString *category = (NSString *)[blockOfInterest objectForKey:@"category"];
            [myCell.Image sd_setImageWithURL:[NSURL URLWithString:visualCoverUrl] placeholderImage:[UIImage imageNamed:@"bb8.jpg"]];
            [myCell.Category setText:[category uppercaseString]];
            cell = myCell;
            break;
            }
        case 0: {
            TitleCell *myCell = (TitleCell*)[tableView dequeueReusableCellWithIdentifier:@"Title" forIndexPath:indexPath];
            NSString *title = (NSString *)[blockOfInterest objectForKey:@"title"];
            NSString *when = (NSString *)[blockOfInterest objectForKey:@"when"];
            NSString *who = (NSString *)[blockOfInterest objectForKey:@"who"];
            [myCell.Title setText:[title uppercaseString]];
            [myCell.WhenWho setText:[NSString stringWithFormat:@"%@ | par %@",when,[who uppercaseString]]];
            cell = myCell;
            break;
        }
        case 1: {
            ShareCell *myCell = (ShareCell*)[tableView dequeueReusableCellWithIdentifier:@"Share" forIndexPath:indexPath];
            NSString *shares = [[blockOfInterest objectForKey:@"shares"] stringValue];
            [myCell.shares setText:shares];
            cell = myCell;
            break;
        }
        case 2: {
            ParagraphCell *myCell = (ParagraphCell*)[tableView dequeueReusableCellWithIdentifier:@"Paragraph" forIndexPath:indexPath];
            NSMutableString *richText = [NSMutableString stringWithString: @"<html><head><style type=\"text/css\">* {margin:0;padding:0;};body {font-size: 17px;font-family: Arial;text-align:justify;} p{font-family: Helvetica;text-align:justify;margin-bottom:10px;}</style></head><body>"];
            [richText appendString:[blockOfInterest objectForKey:@"text"]];
            [richText appendString: @"</body></html>"];
            NSAttributedString * attrStr = [[NSAttributedString alloc] initWithData:[richText dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
            myCell.Text.attributedText = attrStr;
            //[myCell.Text setText:richText];
            cell = myCell;
            break;
        }
        case 3: {
            ImageCell *myCell = (ImageCell*)[tableView dequeueReusableCellWithIdentifier:@"Image" forIndexPath:indexPath];
            NSString *imgLink = [blockOfInterest objectForKey:@"imgLink"];
            [myCell.Image sd_setImageWithURL:[NSURL URLWithString:imgLink] placeholderImage:[UIImage imageNamed:@"bb8.jpg"]];
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
            NSString *embedHTML = @"\
            <html>\
            <head>\
            <style type=\"text/css\">body {background-color: transparent; color: black;}</style>\
            </head>\
            <body tstyle=\"margin:0\">\
            <iframe class=\"player\" type=\"text/html\" width=\"100%%\" height=\"100%%\" src=\"%@\" frameborder=\"0\"></iframe>\
            </body>\
            </html>";
            NSString *strHtml = [NSString stringWithFormat:embedHTML,[NSString stringWithFormat:providerUrl,videoId]];
            [myCell.VideoView  loadHTMLString:strHtml baseURL:nil];
            cell = myCell;
            break;
        }
        case 7: {
            cell = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"FooterBar" forIndexPath:indexPath];
            break;
        }
        case 8: {
            WantMoreCell *myCell = (WantMoreCell*)[tableView dequeueReusableCellWithIdentifier:@"WantMore" forIndexPath:indexPath];
            NSString *title = (NSString *)[blockOfInterest objectForKey:@"title"];
            NSString *when = (NSString *)[blockOfInterest objectForKey:@"when"];
            NSString *who = (NSString *)[blockOfInterest objectForKey:@"who"];
            NSString *shares = (NSString *)[blockOfInterest objectForKey:@"shares"];
            NSString *imgLink = (NSString *)[blockOfInterest objectForKey:@"photo"];
            [myCell.Title setText:[title uppercaseString]];
            [myCell.WhoWhen setText:[NSString stringWithFormat:@"%@ | par %@",when,[who uppercaseString]]];
            [myCell.Shares setText:shares];
            [myCell.image sd_setImageWithURL:[NSURL URLWithString:imgLink] placeholderImage:[UIImage imageNamed:@"bb8.jpg"]];
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
            [myCell.image sd_setImageWithURL:[NSURL URLWithString:imgLink] placeholderImage:[UIImage imageNamed:@"bb8.jpg"]];
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

/*
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
