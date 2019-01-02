//
//  AppDelegate.m
//  NotificationForever
//
//  Created by ruiwendaier on 2018/12/28.
//  Copyright © 2018年 瑞文戴尔. All rights reserved.
//

#import "AppDelegate.h"
#import <UserNotifications/UserNotifications.h>

#define kAppCategoryIdentifier @"NotificationForeverCategory"

@interface AppDelegate () <UNUserNotificationCenterDelegate>

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [self applyPushNotificationAuthorization:application];//请求发送通知授权
    [self addNotificationAction];//添加自定义通知操作扩展
    [self sendNotification];//发送一个通知
    return YES;
}
//请求发送通知授权
- (void)applyPushNotificationAuthorization:(UIApplication *)application{
    if (([[[UIDevice currentDevice] systemVersion] floatValue] >= 10.0)) {
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        center.delegate = self;
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionBadge | UNAuthorizationOptionSound | UNAuthorizationOptionAlert) completionHandler:^(BOOL granted, NSError * _Nullable error) {
            if (!error && granted) {
                NSLog(@"注册成功");
            }else{
                NSLog(@"注册失败");
            }

        }];
        [center getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
            NSLog(@"settings========%@",settings);
        }];
    } else if (([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)){
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound ) categories:nil]];
    }
    [application registerForRemoteNotifications];
}

//添加自定义通知操作扩展
- (void)addNotificationAction {
    UNNotificationAction *openAction = [UNNotificationAction actionWithIdentifier:@"NotificationForeverCategory.action.look" title:@"打开App" options:UNNotificationActionOptionForeground];
    UNNotificationAction *cancelAction = [UNNotificationAction actionWithIdentifier:@"NotificationForeverCategory.action.cancel" title:@"取消" options:UNNotificationActionOptionDestructive];
    UNNotificationCategory *notificationCategory = [UNNotificationCategory categoryWithIdentifier:kAppCategoryIdentifier actions:@[openAction, cancelAction] intentIdentifiers:@[] options:UNNotificationCategoryOptionCustomDismissAction];
    [[UNUserNotificationCenter currentNotificationCenter] setNotificationCategories:[NSSet setWithObject:notificationCategory]];
}
//发送一个通知
- (void)sendNotification {
    UNTimeIntervalNotificationTrigger *timeTrigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:1.0f repeats:NO];
    UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
    content.title = @"App探索-NotFound";
    content.body = @"[App探索]JSBox中幽灵触发器的实现原理探索";
    content.badge = @1;
    content.categoryIdentifier = kAppCategoryIdentifier;
    UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:@"requestIdentifier" content:content trigger:timeTrigger];
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    [center addNotificationRequest:request withCompletionHandler: nil];
}

# pragma mark UNUserNotificationCenterDelegate
//app处于前台时，通知即将展示时的回调方法，不实现会导致通知显示不了
- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions options))completionHandler{
    completionHandler(UNNotificationPresentationOptionBadge|
                      UNNotificationPresentationOptionSound|
                      UNNotificationPresentationOptionAlert);
}

//app处于后台或者未运行状态时，用户点击操作的回调
- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void(^)(void))completionHandler {
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    if ([response.actionIdentifier isEqualToString:UNNotificationDismissActionIdentifier]) {//点击系统的清除按钮
        UNTimeIntervalNotificationTrigger *timeTrigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:0.0001f repeats:NO];
        UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
        content.title = @"App探索-NotFound";
        content.body = @"[App探索]JSBox中幽灵触发器的实现原理探索";
        content.badge = @1;
        content.categoryIdentifier = kAppCategoryIdentifier;
        UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:response.notification.request.identifier content:content trigger:timeTrigger];
        [[UNUserNotificationCenter currentNotificationCenter] addNotificationRequest:request withCompletionHandler:nil];
    }
    completionHandler();
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
