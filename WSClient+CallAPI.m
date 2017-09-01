//
//  WSClient+CallAPI.m
//  WsClient
//
//  Created by Mac33 on 05/11/16.
//  Copyright © 2016 jenish. All rights reserved.
//

#import "WSClient+CallAPI.h"
#import "NSString+NSString_URLEncoding.h"
#import "Comman_Function.h"

@implementation WSClient (CallAPI)

- (void)callWithParameters:(NSMutableDictionary *)parameters API:(WSAPI)wsapi complete:(void (^)(id responseObject, NSError *error))complete
{
    NSString *apipath = [self requestURLFor:wsapi];
    if(parameters != nil)
    {
        //apipath = [NSString stringWithFormat:@"%@?%@",apipath,[self getQuery:parameters]];
    }
    
    
   
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:apipath]];
     [request setHTTPBody:[[self getQuery:parameters] dataUsingEncoding:NSUTF8StringEncoding]];
   
    
    

    [request setHTTPMethod:@"POST"];
    
    @autoreleasepool {
        AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];

        [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
           
            
            complete(responseObject,nil);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            complete(nil,error);
            NSLog(@"%ld",(long)[operation.responseObject statusCode]);

            if (error.code == -1001) {
                

               // alertMessage(localize(@"heavy_traffic_message"), alertMessge);
                
                
            }else if(error.code == -1004 || error.code == -1003 || error.code == -1000 || error.code == -1005 || error.code == -1009 || error.code == -1002)
            {
                

                //alertMessage(localize(@"offline_message"), alertMessge);
                
            }
            
             
        }];
        operation.responseSerializer = [AFJSONResponseSerializer serializer];
        [operation start];
    }
}


- (void)callWithImageParameters:(NSMutableDictionary *)parameters API:(WSAPI)wsapi complete:(void (^)(id responseObject, NSError *error))complete
{
    NSString *apipath = [self requestURLFor:wsapi];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:apipath]];
    [request setHTTPMethod:@"POST"];
    
    //Add Image
    NSMutableString *query = [NSMutableString string];
    [[parameters allKeys] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if(idx != 0)
        {
            [query appendString:@"&"];
        }
        [query appendFormat:@"%@=%@",obj,[[parameters objectForKey:obj] urlEncode]];
    }];
    
    NSData *requestData = [NSData dataWithBytes: [query UTF8String] length: [query length]]; // Convert string to data to send to web service
    [request setHTTPBody:requestData];
    requestData = nil;
    
    @autoreleasepool {
        AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
        [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            complete(responseObject,nil);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            if(error.code == -1004 || error.code == -1003 || error.code == -1001 || error.code == -1000 || error.code == -1005 || error.code == -1009 || error.code == -1002)
            {
                //alertMessage(error.localizedDescription, alertMessge);
            }
            complete(nil,error);
        }];
        operation.responseSerializer = [AFJSONResponseSerializer serializer];
        [operation start];
    }
    
}

- (void)UploadPhoto:(NSMutableDictionary *)parameters complete:(void (^)(id responseObject, NSError *error))complete
{
    UIImage *image = [parameters objectForKey:@"filedata"];
    //NSLog(@"image %@",image);
    
    [parameters removeObjectForKey:@"filedata"];
    
    NSString *apiPath = [self requestURLFor:WSAPIAddMedia];
   
    if (image)
    {
        [[AFHTTPRequestOperationManager manager] POST:apiPath parameters:E_ConvertDictToJSON(parameters) constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            NSLog(@"image %@",image);
            [formData appendPartWithFileData:UIImageJPEGRepresentation(image, 0.3) name:@"filedata" fileName:@"filedata.jpg" mimeType:@"image/jpeg"];//0.8
            //    NSData *imageData1 = [[NSData alloc] initWithData:UIImageJPEGRepresentation(image, 0.5)];
            //   NSData *imageData2 = [[NSData alloc] initWithData:UIImageJPEGRepresentation(image, 0.3)];
            
            //  int imageSize = imageData1.length;
            // int imageSize2 = imageData2.length;
            // NSLog(@"SIZE OF IMAGE: %.2f Mb | %.2f Mb ", (float)imageSize/1024/1024,(float)imageSize2/1024/1024);
            
        } success:^(AFHTTPRequestOperation *operation, id responseObject)
        {
            
            complete(responseObject,nil);
        }
        failure:^(AFHTTPRequestOperation *operation, NSError *error)
        {            
            complete(nil,error);
        }];
    }
    else
    {
        [[AFHTTPRequestOperationManager manager] POST:apiPath parameters:E_ConvertDictToJSON(parameters)  success:^(AFHTTPRequestOperation *operation, id responseObject) {
            complete(responseObject,nil);
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            complete(nil,error);
            
        }];
    }
    
}

@end
