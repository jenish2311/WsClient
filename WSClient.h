//
//  WSClient.h
//  WsClient
//
//  Created by Mac33 on 05/11/16.
//  Copyright © 2016 jenish. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

#import <MobileCoreServices/MobileCoreServices.h>
#import <SystemConfiguration/SystemConfiguration.h>


@interface WSClient : NSObject
+ (WSClient *)sharedClient;
- (NSString *) getQuery:(NSMutableDictionary *) parameters;
 
@end
