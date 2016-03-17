//
//  Globals.h
//  FanActuV2
//
//  Created by Clément BENOIT on 15/03/16.
//  Copyright © 2016 cbenoitp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Globals : NSObject 

// Utils
+ (NSString *) getEncodedDate:(NSString*) dateString;

// Storage
+ (NSArray*) getUnivers;
+ (void) setUnivers:(NSArray*) array;
+ (NSMutableArray*) getHots;
+ (void) setHots:(NSMutableArray*) hots;
+ (NSMutableArray*) getActus;
+ (void) setActus:(NSMutableArray*) articles;
+ (NSMutableArray*) getTopsWeek;
+ (void) setTopsWeek:(NSMutableArray*) articlesList;
+ (NSMutableArray*) getTopsMonth;
+ (void) setTopsMonth:(NSMutableArray*) articlesList;

@end
