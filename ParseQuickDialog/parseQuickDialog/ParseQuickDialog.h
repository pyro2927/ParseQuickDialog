//
//  ParseQuickDialog.h
//  ParseQuickDialog
//
//  Created by Joseph Pintozzi on 7/23/13.
//  Copyright (c) 2013 TinyDragonApps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>
#import "PFObjectListViewController.h"
#import "ParseObjectViewController.h"
#import "ParseClassesViewController.h"

@interface ParseQuickDialog : NSObject

+ (id)sharedInstance;
+ (void)setApplicationId:(NSString *)applicationId clientKey:(NSString *)clientKey;
+ (void)registerClass:(Class)objCClass forParseClassName:(NSString*)parseClass;
+ (void)addClasses:(NSArray*)parseClasses;
+ (Class)classForParseClassName:(NSString*)parseClass;
+ (ParseClassesViewController*)classesViewController;
+ (ParseObjectViewController*)viewControllerForParseObject:(PFObject*)parseObject;

@end