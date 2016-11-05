//
//  WSClient+APIFunctions.m
//  WsClient
//
//  Created by Mac33 on 05/11/16.
//  Copyright © 2016 jenish. All rights reserved.
//

#import "WSClient+APIFunctions.h"

@implementation WSClient (APIFunctions)

-(NSString *) getAPI:(WSAPI)wsapi
{
    NSString *apiname = @"";
    switch (wsapi) {
            
        case WSAPITest:
            apiname = @"system";
            break;
        case WSAPIAddMedia:
            apiname = @"media";
            break;
               default:
            break;
    }
    return apiname;
}


-(NSString *) requestURLFor:(WSAPI)wsapi
{
    NSString *urlString = @"http://52.206.86.112/infosystem/ver2.6/index.php?r=api";
    
    
    
    return [NSString stringWithFormat:@"%@/%@",urlString,[self getAPI:wsapi]];
}

@end
