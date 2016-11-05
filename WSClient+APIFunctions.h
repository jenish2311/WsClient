//
//  WSClient+APIFunctions.h
//  WsClient
//
//  Created by Mac33 on 05/11/16.
//  Copyright © 2016 jenish. All rights reserved.
//

#import "WSClient.h"

typedef enum {
    WSAPITest = 1,
    WSAPIAddMedia
    
} WSAPI;

@interface WSClient (APIFunctions)
-(NSString *) getAPI:(WSAPI)wsapi;
-(NSString *) requestURLFor:(WSAPI)wsapi;

@end
