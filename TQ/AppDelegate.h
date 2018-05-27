//
//  AppDelegate.h
//  TQ
//
//  Created by 杨宗维 on 2018/5/26.
//  Copyright © 2018年 Icecooll. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

