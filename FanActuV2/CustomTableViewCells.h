//
//  CustomTableViewCell.h
//  FanActuV2
//
//  Created by Clément BENOIT on 08/03/16.
//  Copyright © 2016 cbenoitp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UICategoryLabel.h"

// ARTICLE

@interface ImageHeaderCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *Image;
@property (weak, nonatomic) IBOutlet UICategoryLabel *Category;

@end

@interface TitleCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *Title;
@property (weak, nonatomic) IBOutlet UILabel *WhenWho;

@end

@interface ShareCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *shares;

@end

@interface ParagraphCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *Text;

@end

@interface ImageCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *Image;

@end

@interface AnecdoteCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UILabel *anecdote;
@end

@interface VideoCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIWebView *VideoView;

@end

@interface WantMoreCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *Shares;
@property (weak, nonatomic) IBOutlet UILabel *CAtegory;
@property (weak, nonatomic) IBOutlet UILabel *Title;
@property (weak, nonatomic) IBOutlet UILabel *WhoWhen;
@property (weak, nonatomic) IBOutlet UIImageView *image;

@end

@interface EmptyCell : UITableViewCell

@end

