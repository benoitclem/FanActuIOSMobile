//
//  HotView.h
//  FanActuV2
//
//  Created by Clément BENOIT on 07/03/16.
//  Copyright © 2016 cbenoitp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ArticleListViewController.h"
#import "UICategoryLabel.h"

@interface HotView : UIView {
    UIPageControl *pControl;
    NSString *publicationId;
    ArticleListViewController *vc;
}

- (void) setPublicationId:(NSString*) pubId;
- (void) setCallBack:(ArticleListViewController*) lvc;

@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UIView *colorOverlay;
@property (weak, nonatomic) IBOutlet UICategoryLabel *category;
@property (weak, nonatomic) IBOutlet UILabel *Title;
//@property (weak, nonatomic) IBOutlet UILabel *WhenWho;
@property (weak, nonatomic) IBOutlet UIButton *SensitiveTouch;

@end
