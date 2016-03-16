//
//  SplashScreenViewController.h
//  FanActuV2
//
//  Created by Clément BENOIT on 16/03/16.
//  Copyright © 2016 cbenoitp. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SplashScreenViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *BackGround;
@property (weak, nonatomic) IBOutlet UIImageView *Logo;

- (void) seguePlease;   

@end
