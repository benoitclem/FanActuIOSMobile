//
//  UIButtonWithData.m
//  FanActuV2
//
//  Created by Clément BENOIT on 22/03/16.
//  Copyright © 2016 cbenoitp. All rights reserved.
//

#import "UIButtonWithData.h"

@implementation UIButtonWithData

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void) setValue:(NSString*) lIdPub {
    idPub = [NSString stringWithString:lIdPub];
}

- (NSString*) getValue {
    return idPub;
}

@end
