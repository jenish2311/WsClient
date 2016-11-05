//
//  WSClient+CallAPI.h
//  WsClient
//
//  Created by Mac33 on 05/11/16.
//  Copyright © 2016 jenish. All rights reserved.
//

#import "WSClient.h"
#import "WSClient+APIFunctions.h"

@interface WSClient (CallAPI)
- (void)callWithParameters:(NSMutableDictionary *)parameters API:(WSAPI)wsapi complete:(void (^)(id responseObject, NSError *error))complete;
- (void)callWithImageParameters:(NSMutableDictionary *)parameters API:(WSAPI)wsapi complete:(void (^)(id responseObject, NSError *error))complete;
- (void)UploadPhoto:(NSMutableDictionary *)parameters complete:(void (^)(id responseObject, NSError *error))complete;

@end
