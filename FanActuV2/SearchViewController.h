//
//  SearchViewController.h
//  FanActuV2
//
//  Created by Clément BENOIT on 07/03/16.
//  Copyright © 2016 cbenoitp. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchViewController : UIViewController <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *SearchTextField;

@end
