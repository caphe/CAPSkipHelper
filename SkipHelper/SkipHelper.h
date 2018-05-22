//
//  SkipHelper.h
//  SkipHelper
//
//  Created by kdatm on 2018/5/18.
//  Copyright © 2018年 kdatm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
@interface SkipHelper : NSObject
+ (instancetype)shareHelper;
/* 必须先 设置appid **/
@property (nonatomic,strong)NSString *appId;
@end
