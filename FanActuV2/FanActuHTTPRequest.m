//
//  FanActuHTTPRequest.m
//  FanActuV2
//
//  Created by Clément BENOIT on 04/03/16.
//  Copyright © 2016 cbenoitp. All rights reserved.
//

#import "FanActuHTTPRequest.h"

static NSString *baseArticlesListURL = @"http://m.fanactu.com/load/";
static NSString *baseArticleURL = @"http://m.fanactu.com/article/%@/";

@implementation FanActuHTTPRequest

+ (void)requestArticlesWithDate:(NSString*) date andCompletionBlock:(FanActuHTTPREquestCompletionHandler) completionBlock {
    NSURLSession *session = [NSURLSession sharedSession];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:baseArticlesListURL]];
    [request setHTTPMethod:@"POST"];
    NSString *postString = [NSString stringWithFormat:@"idType=0&idUnivers=0&date=%@&newSection=1",date];
    [request setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
    [[session dataTaskWithRequest:request completionHandler: completionBlock] resume];
}

+ (void)requestArticleWithId:(NSString*) articleId andCompletionBlock:(FanActuHTTPREquestCompletionHandler) completionBlock {
    NSURLSession *session = [NSURLSession sharedSession];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:baseArticleURL,articleId]]];
    [[session dataTaskWithRequest:request completionHandler: completionBlock] resume];
}

+ (void)requestImageWithUrlString:(NSString*) urlString andCompletionBlock:(FanActuHTTPREquestCompletionHandler) completionBlock{
    NSURLSession *session = [NSURLSession sharedSession];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:urlString]];
    [[session dataTaskWithRequest:request completionHandler: completionBlock] resume];
}

+ (NSString*)getParameter:(NSString*) strKey fromArticles:(NSArray*) list withIndex:(NSInteger) integer {
    return (NSString*) [(NSDictionary*)[list objectAtIndex:integer] objectForKey:strKey];
}

@end
