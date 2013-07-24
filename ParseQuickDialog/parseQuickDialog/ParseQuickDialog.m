//
//  ParseQuickDialog.m
//  ParseQuickDialog
//
//  Created by Joseph Pintozzi on 7/23/13.
//  Copyright (c) 2013 TinyDragonApps. All rights reserved.
//

#import "ParseQuickDialog.h"

@interface ParseQuickDialog (){
    NSMutableDictionary *registeredClasses;
}

@property (nonatomic) NSMutableDictionary *registeredClasses;

@end

@implementation ParseQuickDialog
@synthesize registeredClasses;

+ (id)sharedInstance{
    static dispatch_once_t pred = 0;
    __strong static id _sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[ParseQuickDialog alloc] init]; // or some other init method
        ((ParseQuickDialog*)_sharedObject).registeredClasses = [NSMutableDictionary dictionary];
    });
    return _sharedObject;
}

+ (void)setApplicationId:(NSString *)applicationId clientKey:(NSString *)clientKey{
    [Parse setApplicationId:applicationId clientKey:clientKey];
    //TODO: automagically fetch available classes when API is updated
    // see: https://www.parse.com/questions/why-doesnt-the-parse-rest-api-have-an-endpoint-for-getting-all-the-classes-in-an-app
}

+ (void)addClasses:(NSArray*)parseClasses{
    for (NSString *parseClass in parseClasses) {
        //make sure we don't overwrite existing key/vals if already there
        if (![[[[ParseQuickDialog sharedInstance] registeredClasses] allKeys] containsObject:parseClass]) {
            [self registerClass:[ParseObjectViewController class] forParseClassName:parseClass];
        }
    }
}

+ (void)registerClass:(Class)objCClass forParseClassName:(NSString*)parseClass{
    [[[ParseQuickDialog sharedInstance] registeredClasses] setValue:objCClass forKey:parseClass];
}

+ (Class)classForParseClassName:(NSString*)parseClass{
    return [[[ParseQuickDialog sharedInstance] registeredClasses] valueForKey:parseClass];
}

#pragma Handy UIViewControllers

+ (ParseClassesViewController*)classesViewController{
    return [ParseClassesViewController classesViewControllerWithClasses:[[[ParseQuickDialog sharedInstance] registeredClasses] allKeys]];
}

+ (ParseObjectViewController*)viewControllerForParseObject:(PFObject*)parseObject{
    Class class = [ParseObjectViewController class];
    Class registeredClass = [ParseQuickDialog classForParseClassName:[parseObject parseClassName]];
    //make sure the registered class is a subclass of our superclass
    if (registeredClass && [registeredClass isSubclassOfClass:class]) {
        class = registeredClass;
    }
    return [class objectViewControllerForObject:parseObject];
}

@end