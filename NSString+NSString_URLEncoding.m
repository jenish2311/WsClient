//
//  NSString+NSString_URLEncoding.m
//  WsClient
//
//  Created by Mac33 on 05/11/16.
//  Copyright © 2016 jenish. All rights reserved.
//

#import "NSString+NSString_URLEncoding.h"

@implementation NSString (NSString_URLEncoding)
- (NSString *)urlEncodeUsingEncoding:(CFStringEncoding)encoding {    
    return CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                     (__bridge CFStringRef)self,
                                                                     NULL,
                                                                     CFSTR("!*'();:@&=+$,/?%#[]"),
                                                                     encoding));
}

- (NSString *)urlEncode {    
    return [self urlEncodeUsingEncoding:kCFStringEncodingUTF8];
}
@end
