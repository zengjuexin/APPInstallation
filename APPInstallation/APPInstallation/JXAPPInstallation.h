//
//  JXAPPInstallation.h
//  JXAPPInstallation
//
//  Created by 曾觉新 on 2018/11/2.
//  Copyright © 2018 曾觉新. All rights reserved.
//

#import <Foundation/Foundation.h>

@class JXAppInfo;

NS_ASSUME_NONNULL_BEGIN

@interface JXAPPInstallation : NSObject
/**
 * 所有已安装app
 */
+ (NSArray *)allInstalledApplications;
/**
 * 所有app信息
 */
+ (void)allInstalledInfo:(void(^)(NSArray<JXAppInfo *> *allApp))complete;
/**
 * 判断app是否安装
 */
+ (BOOL)isInstalled:(NSString *)bundleId;

@end

@interface JXAppInfo : NSObject

@property (nonatomic, copy) NSString *bundleId;
@property (nonatomic, copy) NSString *appName;
@property (nonatomic, copy) NSString *appType;
@property (nonatomic, copy) NSString *appVersion;
@property (nonatomic, copy) NSString *containerURL;


@end

NS_ASSUME_NONNULL_END
