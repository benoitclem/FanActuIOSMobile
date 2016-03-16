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
static NSMutableArray *articles = nil;

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

+ (NSMutableArray*) getArticles {
    return articles;
}

+ (void) setArticles:(NSMutableArray*) articlesList {
   articles = [[NSMutableArray alloc] initWithArray:articlesList copyItems:YES];
}

@end
