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
    rootElement.object = parseObject;
    
    //setup a convenient datetime formatter for immutables
    if ([self showsImmutableValues]) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
        [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
        QSection *immutableSection = [[QSection alloc] initWithTitle:@""];
        [immutableSection addElement:[[QLabelElement alloc] initWithTitle:@"ObjectID" Value:[parseObject objectId]]];
        [immutableSection addElement:[[QLabelElement alloc] initWithTitle:@"Created At" Value:[dateFormatter stringFromDate:[parseObject createdAt]]]];
        [immutableSection addElement:[[QLabelElement alloc] initWithTitle:@"Updated At" Value:[dateFormatter stringFromDate:[parseObject updatedAt]]]];
        [rootElement addSection:immutableSection];
    }
    
    QSection *objectInfoSection = [[QSection alloc] initWithTitle:@"Attributes"];
    //allkeys leaves out created/update at, objectId
    for (NSString *key in [self orderedKeysForObject:parseObject]) {
        [objectInfoSection addElement:[self elementForObject:parseObject key:key]];
    }
    [rootElement addSection:objectInfoSection];
    return (ParseObjectViewController*)[QuickDialogController controllerForRoot:rootElement];
}

+ (QElement*)elementForObject:(PFObject*)parseObject key:(NSString*)attribute{
    id value = [parseObject objectForKey:attribute];
    QElement *element = nil;
    NSString *title = [self titleForKey:attribute];
    if ([value isKindOfClass:[NSString class]]) {
        element = [[QEntryElement alloc] initWithTitle:title Value:value Placeholder:@""];
    } else if ([value isKindOfClass:[NSDate class]]) {
        element = [[QDateTimeElement alloc] initWithTitle:title date:value];
    } else if ([value isKindOfClass:[PFGeoPoint class]]) {
        element = [[QMapElement alloc] initWithTitle:title coordinate:CLLocationCoordinate2DMake([(PFGeoPoint*)value latitude], [(PFGeoPoint*)value longitude])];
    } else if ([value isKindOfClass:[NSNumber class]]) {
        value = [(NSNumber*)value stringValue];
        element = [[QEntryElement alloc] initWithTitle:title Value:value Placeholder:@""];
        ((QEntryElement*)element).keyboardType = UIKeyboardTypeDecimalPad;
    } else if ([value isKindOfClass:[PFObject class]]) {
        //PFObject is a pointer to a child object
        element = [[QLabelElement alloc] initWithTitle:title Value:[(PFObject*)value objectId]];
        ((QLabelElement*)element).accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        element.controllerAction = @"presentChildObject:";
        element.object = value;
    }
    element.key = attribute;
    return element;
}

+ (BOOL)showsImmutableValues{
    return YES;
}

+ (NSArray*)orderedKeysForObject:(PFObject*)parseObject{
    return [parseObject allKeys];
}

+ (NSString*)titleForKey:(NSString*)key{
    return key;
}

- (void)presentChildObject:(QElement*)element{
    PFObject *childObject = (PFObject*)element.object;
    //make sure we fetch if necessary
    [childObject fetchIfNeededInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        [self.navigationController pushViewController:[ParseObjectViewController objectViewControllerForObject:object] animated:YES];
    }];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    //TOOD: pull values from keys
    PFObject *parseObject = (PFObject*)self.root.object;
    [self.root fetchValueIntoObject:parseObject];
    //save out any changes we may have made in the background
    [parseObject saveInBackground];
}

@end
