//
//  Globals.m
//  FanActuV2
//
//  Created by Clément BENOIT on 15/03/16.
//  Copyright © 2016 cbenoitp. All rights reserved.
//

#import "Globals.h"

static NSArray *univers = nil;
static NSMutableArray *hots = nil;
static NSMutableArray *actus = nil;
static NSMutableArray *topsWeek = nil;
static NSMutableArray *topsMonth = nil;

@implementation Globals

// Utils
+ (NSString *) getEncodedDate:(NSString*) dateString{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    if(dateString == nil) {
        formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss ZZZ";
        dateString = [formatter stringFromDate:[NSDate date]];
    }
    return [dateString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
}

// Storage Stuffs
+ (NSArray*) getUnivers {
    return univers;
}

+ (void) setUnivers:(NSArray*) array {
    univers = [[NSMutableArray alloc] initWithArray:array copyItems:YES];
}

+ (NSMutableArray*) getHots {
    return hots;
}

+ (void) setHots:(NSMutableArray*) hotlist {
    hots = [[NSMutableArray alloc] initWithArray:hotlist copyItems:YES];
}

+ (NSMutableArray*) getActus {
    return actus;
}

+ (void) setActus:(NSMutableArray*) articlesList {
    actus = [[NSMutableArray alloc] initWithArray:articlesList copyItems:YES];
}

+ (NSMutableArray*) getTopsWeek {
    return topsWeek;
}

+ (void) setTopsWeek:(NSMutableArray*) articlesList {
    topsWeek = [[NSMutableArray alloc] initWithArray:articlesList copyItems:YES];
}

+ (NSMutableArray*) getTopsMonth {
    return topsMonth;
}

+ (void) setTopsMonth:(NSMutableArray*) articlesList {
    topsMonth = [[NSMutableArray alloc] initWithArray:articlesList copyItems:YES];
}

@end
