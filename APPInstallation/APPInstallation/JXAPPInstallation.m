//
//  JXAPPInstallation.m
//  JXAPPInstallation
//
//  Created by 曾觉新 on 2018/11/2.
//  Copyright © 2018 曾觉新. All rights reserved.
//

#import "JXAPPInstallation.h"
#import <UIKit/UIKit.h>
#import <objc/runtime.h>

@implementation JXAPPInstallation


+ (Class)LSApplicationWorkspace_class
{
    return objc_getClass("LSApplicationWorkspace");
}
+ (Class)LSApplicationProxy_class
{
    return objc_getClass("LSApplicationProxy");
}

+ (NSArray *)allInstalledApplications
{
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 11) {//11以后无效
        return @[];
    }
    
    Class lsaws_class = [self LSApplicationWorkspace_class];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
    NSObject* workspace = [lsaws_class performSelector:@selector(defaultWorkspace)];
    
    NSArray *apps = [workspace performSelector:@selector(allInstalledApplications)];
    
    return apps;
}

+ (void)allInstalledInfo:(void(^)(NSArray<JXAppInfo *> *allApp))complete
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSArray *allApp = [self allInstalledApplications];
        
        Class LSApplicationProxy_class = [self LSApplicationProxy_class];
        NSMutableArray *allAppInfo = [NSMutableArray array];
        
        for (int i = 0; i < allApp.count; i++) {
            NSObject *temp = allApp[i];
            if ([temp isKindOfClass:LSApplicationProxy_class]) {
                
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
                //应用的bundleId
                NSString *appBundleId = [temp performSelector:@selector(applicationIdentifier)];
                //应用的名称
                NSString *appName = [temp performSelector:@selector(localizedName)];
                //应用的类型是系统的应用还是第三方的应用
                NSString * type = [temp performSelector:@selector(applicationType)];
                //应用的版本
                NSString * shortVersionString = [temp performSelector:@selector(shortVersionString)];
                
                NSString * resourcesDirectoryURL = [temp performSelector:@selector(containerURL)];//资源路劲
#pragma clang diagnostic pop
                
                if (![type isEqualToString:@"System"]) {//过滤掉系统应用
                    JXAppInfo *appInfo = [JXAppInfo new];
                    appInfo.bundleId = appBundleId ?: @"";
                    appInfo.appName = appName ?: @"";
                    appInfo.appType = type ?: @"";
                    appInfo.appVersion = shortVersionString ?: @"";
                    appInfo.containerURL = resourcesDirectoryURL ?: @"";
                    
                    [allAppInfo addObject:appInfo];
                }
            }
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            complete(allAppInfo);
        });
    });
}


+ (BOOL)isInstalled:(NSString *)bundleId
{
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 11) {
        NSBundle *container = [NSBundle bundleWithPath:@"/System/Library/PrivateFrameworks/MobileContainerManager.framework"];
        if ([container load]) {
            Class appContainer = NSClassFromString(@"MCMAppContainer");
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
            id container = [appContainer performSelector:@selector(containerWithIdentifier:error:) withObject:bundleId withObject:nil];
#pragma clang diagnostic pop
            if (container) {
                return YES;
            } else {
                return NO;
            }
        }
        return NO;
    } else {
        Class proxyClass = [self LSApplicationProxy_class];
        id proxy = [proxyClass performSelector:@selector(applicationProxyForIdentifier:) withObject:bundleId];
        return [proxy performSelector:@selector(isInstalled)];
    }
    
}


@end

@implementation JXAppInfo

@end
