//
//  FanActuHTTPRequest.m
//  FanActuV2
//
//  Created by Clément BENOIT on 04/03/16.
//  Copyright © 2016 cbenoitp. All rights reserved.
//

#import "FanActuHTTPRequest.h"
#import <UIKit/UIKit.h>

static NSString *baseURL = @"http://m.fanactu.com/device";
static NSString *articlesListURN = @"load";
static NSString *articleURN = @"article";
static NSString *universURN = @"univers";
static NSString *universUpdateURN = @"univers/update";

@implementation FanActuHTTPRequest

+ (NSString*)getDeviceUID {
    return [[[[UIDevice currentDevice] identifierForVendor] UUIDString] lowercaseString];
}

+ (void)request:(NSString*)url withPostString:(NSString*)postString andCompletionBlock:(FanActuHTTPREquestCompletionHandler) completionBlock  {
    // Request
    NSURLSession *session = [NSURLSession sharedSession];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
    if(postString!=nil){
        NSLog(@"%@ - %@",url,postString);
        [request setHTTPMethod:@"POST"];
        [request setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
    } else {
        NSLog(@"%@",url);
    }
    [[session dataTaskWithRequest:request completionHandler: completionBlock] resume];
}

+ (void)requestArticlesWithCategory:(NSNumber*)idCategory
                            univers:(NSNumber*)idUnivers
                               date:(NSString*) date
                 andCompletionBlock:(FanActuHTTPREquestCompletionHandler) completionBlock {
    // Compose Url for requesting the ArticlesList
    NSString *url = [NSString stringWithFormat:@"%@/%@/%@/",baseURL,[FanActuHTTPRequest getDeviceUID],articlesListURN];
    // Compose PostString
    NSString *postString = [NSString stringWithFormat:@"idCategorie=%ld&idUnivers=%ld&date=%@&newSection=1",[idCategory integerValue],[idUnivers integerValue],date];
    // Do the request
    [FanActuHTTPRequest request:url withPostString:postString andCompletionBlock:completionBlock];
}

+ (void)requestArticlesWithKeyWords:(NSString*)keywords
                 andCompletionBlock:(FanActuHTTPREquestCompletionHandler) completionBlock {
    // Compose Url for requesting the ArticlesList
    NSString *url = [NSString stringWithFormat:@"%@/%@/%@/",baseURL,[FanActuHTTPRequest getDeviceUID],articlesListURN];
    // Compose PostString
    NSString *postString = [NSString stringWithFormat:@"k=%@&newSection=1",keywords];
    // Do the request
    [FanActuHTTPRequest request:url withPostString:postString andCompletionBlock:completionBlock];
}

+ (void)requestArticleWithId:(NSString*) articleId andCompletionBlock:(FanActuHTTPREquestCompletionHandler) completionBlock {
    // Compose Url for requesting the Article
    NSString *url = [NSString stringWithFormat:@"%@/%@/%@/%@/",baseURL,[FanActuHTTPRequest getDeviceUID],articleURN,articleId];
    // Do the request
    [FanActuHTTPRequest request:url withPostString:nil andCompletionBlock:completionBlock];
}

+ (void)requestUniversWithCompletionBlock:(FanActuHTTPREquestCompletionHandler) completionBlock {
    // Compose Url for requesting the Univers
    NSString *url = [NSString stringWithFormat:@"%@/%@/%@/",baseURL,[FanActuHTTPRequest getDeviceUID],universURN];
    // Do the request
    [FanActuHTTPRequest request:url withPostString:nil andCompletionBlock:completionBlock];
}

+ (void)updateUniversWithId:(NSString*) idUnivers andLevel:(NSNumber*) level andCompletionBlock:(FanActuHTTPREquestCompletionHandler) completionBlock {
    // Compose Url for requesting the Univers
    NSString *url = [NSString stringWithFormat:@"%@/%@/%@/%@/%@/",baseURL,[FanActuHTTPRequest getDeviceUID],universUpdateURN,idUnivers,level];
    // Do the request
    [FanActuHTTPRequest request:url withPostString:nil andCompletionBlock:completionBlock];
}

+ (void)requestImageWithUrlString:(NSString*) urlString andCompletionBlock:(FanActuHTTPREquestCompletionHandler) completionBlock{
    NSURLSession *session = [NSURLSession sharedSession];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:urlString]];
    [[session dataTaskWithRequest:request completionHandler: completionBlock] resume];
}

+ (NSString*)getParameter:(NSString*) strKey fromArticles:(NSArray*) list withIndex:(NSInteger) integer {
    return (NSString*) [(NSDictionary*)[list objectAtIndex:integer] objectForKey:strKey];
}

+ (NSNumber*)getNumberParameter:(NSString*) strKey fromArticles:(NSArray*) list withIndex:(NSInteger) integer {
    return (NSNumber*) [(NSDictionary*)[list objectAtIndex:integer] objectForKey:strKey];
}

@end
