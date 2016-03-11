//
//  UICategoryLabel.h
//  FanActuV2
//
//  Created by Clément BENOIT on 11/03/16.
//  Copyright © 2016 cbenoitp. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UICategoryLabel : UILabel

- (CGRect)textRectForBounds:(CGRect)bounds limitedToNumberOfLines:(NSInteger)numberOfLines;
- (void)drawTextInRect:(CGRect)rect;

@property (nonatomic, assign) UIEdgeInsets edgeInsets;

@end
