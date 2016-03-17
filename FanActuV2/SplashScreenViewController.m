//
//  SplashScreenViewController.m
//  FanActuV2
//
//  Created by Clément BENOIT on 16/03/16.
//  Copyright © 2016 cbenoitp. All rights reserved.
//

#import "SplashScreenViewController.h"
#import "Globals.h"
#import "FanActuHTTPRequest.h"

#define MIN_SPLASH_TIME 3.0

@interface SplashScreenViewController ()

@end

@implementation SplashScreenViewController

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.BackGround setImage:[UIImage imageNamed:@"splash_screen6.jpg"]];
    [self.Logo setImage:[UIImage imageNamed:@"logo_splash6.png"]];
    
    CAKeyframeAnimation *breath = [CAKeyframeAnimation animation];
    breath.keyPath = @"transform.scale";
    breath.values = @[@1.05,@1.0,@1.05];
    breath.keyTimes = @[@0,@0.4,@1];
    breath.duration = 4.0f;
    breath.repeatCount = HUGE_VALF;
    breath.delegate = self;
    [self.Logo.layer addAnimation:breath forKey:@"breath"];
    
    NSDate *startTime = [NSDate date];
    
    NSString *encodedDate = [Globals getEncodedDate:nil];
    NSLog(@"Date %@",encodedDate);
    // Register UDID
    [FanActuHTTPRequest requestUniversWithCompletionBlock:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSArray *univers = [(NSDictionary*)[NSJSONSerialization
                                            JSONObjectWithData:data
                                            options:NSJSONReadingMutableContainers
                                            error:&error] objectForKey:@"univers"];
        NSLog(@"univers %@",univers);
        // Keep the univers in globals
        [Globals setUnivers:univers];
    }];
    // Get content

    [FanActuHTTPRequest requestArticlesWithCategory:@0
                                            univers:@0
                                               date:encodedDate
                                 andCompletionBlock:^(NSData *data, NSURLResponse *response, NSError *error){
                            NSMutableDictionary * all = [NSJSONSerialization
                                                             JSONObjectWithData:data
                                                             options:NSJSONReadingMutableContainers
                                                             error:&error];

                                     // handle response
                                     NSMutableArray *hotList = [all objectForKey:@"hot"];
                                     NSLog(@"Hot %@ ", hotList);
                                     [Globals setHots:hotList];

                                     NSMutableArray *actuList = [all objectForKey:@"actus"];
                                     NSLog(@"Actus %@ ", actuList);
                                     [Globals setActus:actuList];

                                     NSMutableArray *topsWeek = [all objectForKey:@"topWeek"];
                                     NSLog(@"week %@ ", topsWeek);
                                     [Globals setTopsWeek:topsWeek];
                                     
                                     NSMutableArray *topsMonth = [all objectForKey:@"topMonth"];
                                     NSLog(@"month %@ ", topsMonth);
                                     [Globals setTopsMonth:topsMonth];

                                     NSDate *endTime = [NSDate date];
                                     NSTimeInterval executionTime = [endTime timeIntervalSinceDate:startTime];

                                     //NSLog(@"ExecTime %f",executionTime);
                                     if(executionTime<MIN_SPLASH_TIME) {
                                         //NSLog(@"%f",MIN_SPLASH_TIME-executionTime);
                                         sleep(MIN_SPLASH_TIME-executionTime);
                                     }

                                     dispatch_async(dispatch_get_main_queue(), ^{
                                         [self performSegueWithIdentifier:@"toMain" sender: self];
                                     });
                                 }];

    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    //sleep(5);
    //[self performSegueWithIdentifier:@"toMain" sender:self];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
