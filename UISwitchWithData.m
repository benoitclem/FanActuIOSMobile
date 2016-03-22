//
//  UISwitchWithData.m
//  FanActuV2
//
//  Created by Clément BENOIT on 18/03/16.
//  Copyright © 2016 cbenoitp. All rights reserved.
//

#import "UISwitchWithData.h"

@implementation UISwitchWithData

- (void) setValue:(NSUInteger) i {
    value = i;
}
- (NSUInteger) getValue {
    return value;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
