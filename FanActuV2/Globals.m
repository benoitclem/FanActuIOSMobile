//
//  Globals.m
//  FanActuV2
//
//  Created by Clément BENOIT on 15/03/16.
//  Copyright © 2016 cbenoitp. All rights reserved.
//

#import "Globals.h"

static NSArray *univers = nil;

@implementation Globals

+ (NSArray*) getUnivers {
    return univers;
}

+ (void) setUnivers:(NSArray*) array {
    univers = [[NSMutableArray alloc] initWithArray:array copyItems:YES];
}

@end
