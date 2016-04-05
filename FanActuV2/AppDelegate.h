//
//  AppDelegate.h
//  FanActuV2
//
//  Created by Clément BENOIT on 04/03/16.
//  Copyright © 2016 cbenoitp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

- (void)cancelOldNotifications;
- (void) scheduleNotificationWithTitle:(NSString*) title andBody:(NSString*) body;

- (void) registerForNotificationWithApplication:(UIApplication*) application;

@end

