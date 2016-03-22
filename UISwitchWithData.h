//
//  UISwitch+Data.h
//  FanActuV2
//
//  Created by Clément BENOIT on 18/03/16.
//  Copyright © 2016 cbenoitp. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UISwitchWithData : UISwitch{
    NSUInteger value;
}

- (void) setValue:(NSUInteger) i;
- (NSUInteger) getValue;

@end
