//
//  ViewController.m
//  NotificationForever
//
//  Created by ruiwendaier on 2018/12/28.
//  Copyright © 2018年 瑞文戴尔. All rights reserved.
//

#import "ViewController.h"
#import <UserNotifications/UserNotifications.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    [button addTarget:self action:@selector(sendNotification) forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:@"发送一个3s后显示的通知" forState:UIControlStateNormal];
    button.frame = CGRectMake(0, 200, [UIScreen mainScreen].bounds.size.width, 100);
    [self.view addSubview:button];
}

//发送一个通知
- (void)sendNotification {
    UNTimeIntervalNotificationTrigger *timeTrigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:3.0f repeats:NO];
    UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
    content.title = @"App探索-NotFound";
    content.body = @"[App探索]JSBox中幽灵触发器的实现原理探索";
    content.badge = @1;
    content.categoryIdentifier = @"NotificationForeverCategory";
    UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:@"requestIdentifier" content:content trigger:timeTrigger];
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    [center addNotificationRequest:request withCompletionHandler: nil];
}


@end
