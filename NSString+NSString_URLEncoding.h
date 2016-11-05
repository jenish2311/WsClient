//
//  NSString+NSString_URLEncoding.h
//  WsClient
//
//  Created by Mac33 on 05/11/16.
//  Copyright © 2016 jenish. All rights reserved.
// 
//

#import <Foundation/Foundation.h>


@interface NSString (NSString_URLEncoding)
- (NSString *)urlEncodeUsingEncoding:(CFStringEncoding)encoding;
- (NSString *)urlEncode;
@end
