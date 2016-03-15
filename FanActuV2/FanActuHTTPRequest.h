//
//  FanActuHTTPRequest.h
//  FanActuV2
//
//  Created by Clément BENOIT on 04/03/16.
//  Copyright © 2016 cbenoitp. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^FanActuHTTPREquestCompletionHandler)(NSData *data, NSURLResponse *response, NSError *error);

@interface FanActuHTTPRequest : NSObject

+ (void)requestUniversWithCompletionBlock:(FanActuHTTPREquestCompletionHandler) completionBlock;
+ (void)requestArticlesWithDate:(NSString*) date andCompletionBlock:(FanActuHTTPREquestCompletionHandler)completionBlock;
+ (void)requestArticleWithId:(NSString*) articleId andCompletionBlock:(FanActuHTTPREquestCompletionHandler) completionBlock;
+ (void)requestImageWithUrlString:(NSString*) urlString andCompletionBlock:(FanActuHTTPREquestCompletionHandler) completionBlock;
+ (NSString*)getParameter:(NSString*) strKey fromArticles:(NSArray*) list withIndex:(NSInteger) integer;
+ (NSNumber*)getNumberParameter:(NSString*) strKey fromArticles:(NSArray*) list withIndex:(NSInteger) integer;
@end
