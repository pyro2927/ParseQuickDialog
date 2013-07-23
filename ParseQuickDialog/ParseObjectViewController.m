//
//  ParseObjectViewController.m
//  ParseQuickDialog
//
//  Created by Joseph Pintozzi on 7/22/13.
//  Copyright (c) 2013 TinyDragonApps. All rights reserved.
//

#import "ParseObjectViewController.h"
#import "QuickDialog.h"

@interface ParseObjectViewController ()

@end

@implementation ParseObjectViewController

+ (ParseObjectViewController*)objectViewControllerForObject:(PFObject*)parseObject{
    QRootElement *rootElement = [[QRootElement alloc] init];
    rootElement.title = [parseObject parseClassName];
    rootElement.controllerName = NSStringFromClass([self class]);
    rootElement.grouped = YES;
    
    //setup a convenient datetime formatter for immutables
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    QSection *immutableSection = [[QSection alloc] initWithTitle:@""];
    [immutableSection addElement:[[QLabelElement alloc] initWithTitle:@"ObjectID" Value:[parseObject objectId]]];
    [immutableSection addElement:[[QLabelElement alloc] initWithTitle:@"Created At" Value:[dateFormatter stringFromDate:[parseObject createdAt]]]];
    [immutableSection addElement:[[QLabelElement alloc] initWithTitle:@"Updated At" Value:[dateFormatter stringFromDate:[parseObject updatedAt]]]];
    [rootElement addSection:immutableSection];
    
    QSection *objectInfoSection = [[QSection alloc] initWithTitle:@"Attributes"];
    //allkeys leaves out created/update at, objectId
    for (NSString *key in [parseObject allKeys]) {
        [objectInfoSection addElement:[ParseObjectViewController elementForObject:parseObject key:key]];
    }
    [rootElement addSection:objectInfoSection];
    return (ParseObjectViewController*)[QuickDialogController controllerForRoot:rootElement];
}

+ (QElement*)elementForObject:(PFObject*)parseObject key:(NSString*)attribute{
    id value = [parseObject objectForKey:attribute];
    QElement *element = nil;
    if ([value isKindOfClass:[NSString class]]) {
        element = [[QEntryElement alloc] initWithTitle:attribute Value:value Placeholder:@""];
    } else if ([value isKindOfClass:[NSDate class]]) {
        element = [[QDateTimeElement alloc] initWithTitle:attribute date:value];
    } else if ([value isKindOfClass:[PFGeoPoint class]]) {
        element = [[QMapElement alloc] initWithTitle:attribute coordinate:CLLocationCoordinate2DMake([(PFGeoPoint*)value latitude], [(PFGeoPoint*)value longitude])];
    } else if ([value isKindOfClass:[NSNumber class]]) {
        value = [(NSNumber*)value stringValue];
        element = [[QEntryElement alloc] initWithTitle:attribute Value:value Placeholder:@""];
        ((QEntryElement*)element).keyboardType = UIKeyboardTypeDecimalPad;
    } else if ([value isKindOfClass:[PFObject class]]) {
        //PFObject is a pointer to a child object
        element = [[QLabelElement alloc] initWithTitle:attribute Value:[(PFObject*)value objectId]];
        ((QLabelElement*)element).accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        element.controllerAction = @"presentChildObject:";
        element.object = value;
    }
    return element;
}

- (void)presentChildObject:(QElement*)element{
    PFObject *childObject = (PFObject*)element.object;
    //make sure we fetch if necessary
    [childObject fetchIfNeededInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        [self.navigationController pushViewController:[ParseObjectViewController objectViewControllerForObject:object] animated:YES];
    }];
}

@end
