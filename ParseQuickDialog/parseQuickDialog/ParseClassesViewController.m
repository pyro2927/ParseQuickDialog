//
//  ParseClassesViewController.m
//  ParseQuickDialog
//
//  Created by Joseph Pintozzi on 7/22/13.
//  Copyright (c) 2013 TinyDragonApps. All rights reserved.
//

#import "ParseClassesViewController.h"
#import "PFObjectListViewController.h"

@implementation ParseClassesViewController

+ (ParseClassesViewController*)classesViewControllerWithClasses:(NSArray*)classes{
    QRootElement *rootElement = [[QRootElement alloc] init];
    rootElement.title = @"Parse";
    rootElement.controllerName = NSStringFromClass([self class]);
    rootElement.grouped = YES;
    QSection *classesSection = [[QSection alloc] initWithTitle:@"Classes"];
    for (NSString *class in classes) {
        QLabelElement *labelElement = [[QLabelElement alloc] initWithTitle:class Value:@""];
        labelElement.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        labelElement.controllerAction = @"presentClassObjectList:";
        [classesSection addElement:labelElement];
    }
    if (classes.count) {
        [classesSection setFooter:@"https://parse.com/"];
    } else {
        [classesSection setFooter:@"Please add/set classes, as well as your APP_ID and CLIENT_KEY"];
    }
    [rootElement addSection:classesSection];
    return (ParseClassesViewController*)[QuickDialogController controllerForRoot:rootElement];
}

- (void)presentClassObjectList:(QLabelElement*)labelElement{
    NSString *className = [labelElement title];
    [self.navigationController pushViewController:[PFObjectListViewController objectListViewControllerForClassName:className titleKey:nil] animated:YES];
}

@end
