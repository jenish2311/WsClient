//
//  Comman_Function.m
//  WsClient
//
//  Created by Mac33 on 05/11/16.
//  Copyright © 2016 jenish. All rights reserved.
//

#import "Comman_Function.h"

@implementation Comman_Function
NSMutableDictionary*  E_ConvertDictToJSON(NSDictionary* dict)
{
    
    
    
    NSError * err;
    NSData * jsonData = [NSJSONSerialization dataWithJSONObject:dict options:0 error:&err];
    NSString * myString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    return [NSMutableDictionary dictionaryWithObjectsAndKeys:myString,@"params", nil];
    
}
@end
