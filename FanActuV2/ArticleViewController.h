//
//  ArticleViewController.h
//  FanActuV2
//
//  Created by Clément BENOIT on 07/03/16.
//  Copyright © 2016 cbenoitp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTTAttributedLabel.h"

@interface ArticleViewController : UIViewController <UITableViewDelegate,UITableViewDataSource,TTTAttributedLabelDelegate> {
    NSDictionary *articleInfos;
    NSArray *articlePages;
    NSArray *articleUnivers;
    NSArray *articleConnex;
    NSMutableDictionary *imgRatiosCache;
    NSMutableArray *composedArticle;
    
    NSString *publicationId;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITableView *articleTable;

- (void) loadNetworkData;
- (void) setPublicationId:(NSString*) pId;

// Protocol delegate
- (void)attributedLabel:(TTTAttributedLabel *)label
   didSelectLinkWithURL:(NSURL *)url;

@end
