//
//  UICategoryLabel.m
//  FanActuV2
//
//  Created by Clément BENOIT on 11/03/16.
//  Copyright © 2016 cbenoitp. All rights reserved.
//

#import "UICategoryLabel.h"

@implementation UICategoryLabel

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (CGRect)textRectForBounds:(CGRect)bounds limitedToNumberOfLines:(NSInteger)numberOfLines
{
    UIEdgeInsets insets = {0, 5, 0, 7};
    CGRect rect = [super textRectForBounds:UIEdgeInsetsInsetRect(bounds, insets)
                    limitedToNumberOfLines:numberOfLines];
    
    rect.origin.x    -= insets.left;
    rect.origin.y    -= insets.top;
    rect.size.width  += (insets.left + insets.right);
    rect.size.height += (insets.top + insets.bottom);
    
    return rect;
}


- (void)drawTextInRect:(CGRect)rect {
    UIEdgeInsets insets = {0, 5, 0, 7};
    [super drawTextInRect:UIEdgeInsetsInsetRect(rect, insets)];
}

-(void) setText:(NSString *)text{
    [super setText:text];
    if([text compare:@"CIMÉMA"] == NSOrderedSame) {
        self.backgroundColor = [UIColor colorWithRed:231.0/255.0 green:62.0/255.0 blue:68.0/255.0  alpha:1.0];
    } else if([text compare:@"SÉRIES TV"] == NSOrderedSame) {
        self.backgroundColor = [UIColor colorWithRed:230.0/255.0 green:118.0/255.0 blue:27.0/255.0 alpha:1.0];
    } else if([text compare:@"JEUX VIDÉO"] == NSOrderedSame) {
        self.backgroundColor = [UIColor colorWithRed:8.0/255.0 green:228.0/255.0 blue:163.0/255.0 alpha:1.0];
    } else if([text compare:@"INCLASSABLE"] == NSOrderedSame) {
        self.backgroundColor = [UIColor colorWithRed:170.0/255.0 green:27.0/255.0 blue:230.0/255.0 alpha:1.0];
    } else if ([text compare:@"ANIMATION"] == NSOrderedSame) {
        self.backgroundColor = [UIColor colorWithRed:39.0/255.0 green:124.0/255.0 blue:252.0/255.0 alpha:1.0];
    }
}



@end
