//
//  WSClient.m
//  WsClient
//
//  Created by Mac33 on 05/11/16.
//  Copyright © 2016 jenish. All rights reserved.
//

#import "WSClient.h"

@implementation WSClient


+ (WSClient *)sharedClient
{
    static WSClient *sharedAPIClient = nil;
    static dispatch_once_t onceTokenAPIManager;
    dispatch_once(&onceTokenAPIManager, ^{
        sharedAPIClient = [[self alloc] init];
    });
    return sharedAPIClient;
}


#pragma mark - functions
-(NSString *) getQuery:(NSMutableDictionary *) parameters
{
    NSMutableString *query = [NSMutableString string];
    [[parameters allKeys] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if(idx != 0)
        {
            [query appendString:@"&"];
        }
        [query appendFormat:@"%@=%@",obj,[parameters objectForKey:obj]];
    }];
    query = (NSMutableString *)[query stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
  query =[[query stringByReplacingOccurrencesOfString:@"&" withString:@"%26"] mutableCopy];
    
    //query = [query stringByReplacingOccurrencesOfString:@"&" withString:@"%26"];
    //query = [tempString stringByReplacingOccurrencesOfString:@" " withString:@""];
    //query = [query stringByReplacingOccurrencesOfString:@"!" withString:@"%21"];
    query = [[query stringByReplacingOccurrencesOfString:@"'" withString:@"%27"] mutableCopy];
    //query = [query stringByReplacingOccurrencesOfString:@"(" withString:@"%28"];
    //query = [query stringByReplacingOccurrencesOfString:@")" withString:@"%29"];
    //query = [query stringByReplacingOccurrencesOfString:@"*" withString:@"%2A"];
    //query = [query stringByReplacingOccurrencesOfString:@"/" withString:@"%2F"];
    query = [[query stringByReplacingOccurrencesOfString:@"@" withString:@"%40"] mutableCopy];
    //query = [query stringByReplacingOccurrencesOfString:@":" withString:@"%3A"];
    //query = [query stringByReplacingOccurrencesOfString:@";" withString:@"%3B"];
    //query = [query stringByReplacingOccurrencesOfString:@"=" withString:@"%3D"];
    query = [[query stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"] mutableCopy];
    
    return (NSString *)query;
}




@end
