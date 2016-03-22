//
//  UIButtonWithData.h
//  FanActuV2
//
//  Created by Clément BENOIT on 22/03/16.
//  Copyright © 2016 cbenoitp. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButtonWithData : UIButton {
    NSString *idPub;
}

- (void) setValue:(NSString*) lIdPub;
- (NSString*) getValue;


@end
