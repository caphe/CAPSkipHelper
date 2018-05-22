//
//  NSString+ATMSecurity.m
//  Weather
//
//  Created by admin  on 2017/7/11.
//  Copyright © 2017年 zhenhui huang. All rights reserved.
//

#import "NSString+_Security.h"
#import "_Security.h"
#import "GTMBase64.h"



@implementation NSString (_Security)

- (NSString *)aesEncrypt
{
    NSData *data = [_Security aes256EncryptWithString:self];
    if (data)
    {
        return  [GTMBase64 stringByEncodingData:data];
    }
    return nil;
}

- (NSString *)aesDecrypt
{
    NSData *data = [GTMBase64 decodeString:self];
    return  [_Security aes256DecryptStringWithData:data];
}

@end
