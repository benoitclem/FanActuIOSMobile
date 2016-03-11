//
//  MenuViewController.h
//  FanActuV2
//
//  Created by Clément BENOIT on 07/03/16.
//  Copyright © 2016 cbenoitp. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MenuViewController : UIViewController <UITableViewDataSource,UITableViewDelegate> {
    NSInteger ActuRows;
    NSInteger UniversRows;
}
@property (weak, nonatomic) IBOutlet UITableView *menuTable;
@property (weak, nonatomic) IBOutlet UIImageView *image;

@end
