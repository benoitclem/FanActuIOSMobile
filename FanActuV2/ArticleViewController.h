//
//  ArticleViewController.h
//  FanActuV2
//
//  Created by Clément BENOIT on 07/03/16.
//  Copyright © 2016 cbenoitp. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ArticleViewController : UIViewController <UITableViewDelegate,UITableViewDataSource> {
    NSDictionary *articleInfos;
    NSArray *articlePages;
    NSArray *articleUnivers;
    NSArray *articleConnex;
    NSMutableDictionary *imgRatiosCache;
    NSMutableArray *composedArticle;
    
    NSString *publicationId;
}
@property (weak, nonatomic) IBOutlet UITableView *articleTable;

- (void) setPublicationId:(NSString*) pId;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
