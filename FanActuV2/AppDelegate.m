//
//  AppDelegate.m
//  FanActuV2
//
//  Created by Clément BENOIT on 04/03/16.
//  Copyright © 2016 cbenoitp. All rights reserved.
//

#import "AppDelegate.h"
#import "FanActuHTTPRequest.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    // Apple notification stuffs
    [self registerForNotificationWithApplication: application];
    
    // Facebook stuffs
    [[FBSDKApplicationDelegate sharedInstance] application:application
                             didFinishLaunchingWithOptions:launchOptions];
    // Register fetch
    //[application setMinimumBackgroundFetchInterval: UIApplicationBackgroundFetchIntervalMinimum];
    //sleep(1);
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    NSLog(@"Create Notif shedule");
    //[self scheduleAlarmForDate:[NSDate dateWithTimeIntervalSinceNow:10]];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    NSLog(@"Create Notif shedule");
    //[self cancelOldNotifications];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [FBSDKAppEvents activateApp];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

// Fb something
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [[FBSDKApplicationDelegate sharedInstance] application:application
                                                          openURL:url
                                                sourceApplication:sourceApplication
                                                       annotation:annotation];
}

- (void)application:(UIApplication *)application performFetchWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    NSLog(@"Do some networking task");
    [FanActuHTTPRequest requestNotificationWithCompletionBlock:^(NSData *data, NSURLResponse *response, NSError *error){
        if(data) {
            // There is some data
            NSMutableDictionary * all = [NSJSONSerialization
                                         JSONObjectWithData:data
                                         options:NSJSONReadingMutableContainers
                                         error:&error] ;
            NSLog(@"all %@",all);
            NSMutableArray *notification = [all objectForKey:@"notifications"];
            if(notification) {
                if([notification count] >= 1) {
                    NSMutableDictionary *notificationContent = [notification objectAtIndex:0];
                    NSString *title = [notificationContent objectForKey:@"title"];
                    NSString *desc = [notificationContent objectForKey:@"description"];
                    NSLog(@"%@ %@", title, desc);
                    [self scheduleNotificationWithTitle:title andBody:desc];
                }
            }
            
            if (completionHandler)
                completionHandler(UIBackgroundFetchResultNewData);
        } else {
            // No Data
            if (completionHandler)
                completionHandler(UIBackgroundFetchResultNoData);
        }
    }];
}

#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "cbenoitp.FanActuV2" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"FanActuV2" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"FanActuV2.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

- (void)cancelOldNotifications{
    UIApplication* app = [UIApplication sharedApplication];
    NSArray*    oldNotifications = [app scheduledLocalNotifications];
    
    // Clear out the old notification before scheduling a new one.
    if ([oldNotifications count] > 0)
        [app cancelAllLocalNotifications];
}

- (void) scheduleNotificationWithTitle:(NSString*) title andBody:(NSString*) body{
    // Cancel old notifications if need
    [self cancelOldNotifications];
    
    // Create a new notification.
    UILocalNotification* notif = [[UILocalNotification alloc] init];
    if (notif) {

        notif.fireDate = [NSDate dateWithTimeIntervalSinceNow:2];
        notif.timeZone = [NSTimeZone defaultTimeZone];
        notif.repeatInterval = 0;
        notif.soundName = @"alarmsound.caf";
        notif.alertTitle = title;
        notif.alertBody = body;
         NSLog(@" on trigg la demande de notif");
        UIApplication* app = [UIApplication sharedApplication];
        [app scheduleLocalNotification:notif];
    }
}

- (void) registerForNotificationWithApplication:(UIApplication*) application {
    // Register for local notification
    UIUserNotificationType types = UIUserNotificationTypeBadge |
    UIUserNotificationTypeSound |
    UIUserNotificationTypeAlert;
    
    UIUserNotificationSettings *mySettings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
    [application registerUserNotificationSettings:mySettings];
    
    // Start Registering remote notification system
    [application registerForRemoteNotifications];
}

- (void) application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    NSLog(@"Registered with id %@", deviceToken );
}

- (void) application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
    NSLog(@"Failed to register for remote notification");
    NSLog(@"%@",error);
}


@end
