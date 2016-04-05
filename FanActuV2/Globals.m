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

+ (NSString *) getDateStringWithDate:(NSDate*) date{
    NSString *strResult;
    NSDate *now = [NSDate date];
    NSTimeInterval diff = [now timeIntervalSinceDate:date];
    
    NSDateFormatter *fullDate = [[NSDateFormatter alloc] init];
    fullDate.dateFormat = @"dd/MM/yy";
    NSString *strFullDate = [fullDate stringFromDate:date];

    NSDateFormatter *fmtHHmm = [[NSDateFormatter alloc] init];
    fmtHHmm.dateFormat = @"HH:mm";
    NSString *hourMinutes = [fmtHHmm stringFromDate:date];
    
    NSDateFormatter *fmtmm = [[NSDateFormatter alloc] init];
    fmtmm.dateFormat = @"mm";
    NSString *minOnly = [fmtmm stringFromDate:date];
    
    if(diff<3600) {
        // Moins d'une heure -> donne les minutes
        strResult = [NSString stringWithFormat:@"il y à %@ min%@",minOnly,(diff<(60.0*2.0))?@"":@"s"];
    } else if(diff<(3600*24)){
        // Moins d'une journées -> donne les heures
        strResult = [NSString stringWithFormat:@"il y à %d heure%@",(int)(diff/3600.0),(diff<(3600.0*2.0))?@"":@"s"];
    } else if(diff<(3600*24*2)){
        // Moins d'un jour -> donne hier et l'heure
        strResult = [NSString stringWithFormat:@"hier à %@",hourMinutes];
    } else if(diff<(3600*24*7)){
        // Moins d'une semaine -> donne les jour et l'heure
        strResult = [NSString stringWithFormat:@"il y à %d jour%@ à %@",(int)(diff/(3600.0*24.0)),(diff<((3600.0*24.0)*2.0))?@"":@"s",hourMinutes];
    } else {
        // Au dela donne la date et l'heure
        strResult = [NSString stringWithFormat:@"le %@ à %@",strFullDate,hourMinutes];
    }
    return strResult;
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
