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
    [rootElement addSection:objectInfoSection];
    
    //allkeys leaves out created/update at, objectId
    for (NSString *key in [self orderedKeysForObject:parseObject]) {
        // a QSection will be returned if there is a PFRelation attached to this object, add as it's own section
        id nextElement = [self elementForObject:parseObject key:key];
        if ([nextElement isKindOfClass:[QSection class]]) {
            [rootElement addSection:(QSection*)nextElement];
        } else {
            [objectInfoSection addElement:nextElement];
        }
    }
    
    //add in our save/delete buttons
    QSection *buttonSection = [[QSection alloc] initWithTitle:@""];
    //save button
    QButtonElement *saveButton = [[QButtonElement alloc] initWithTitle:@"Save & Close"];
    saveButton.controllerAction = @"saveParseObject:";
    //delete button
    QButtonElement *deleteButton = [[QButtonElement alloc] initWithTitle:@"Delete"];
    saveButton.controllerAction = @"deleteParseObject:";
    
    [buttonSection addElement:saveButton];
    [buttonSection addElement:deleteButton];
    [rootElement addSection:buttonSection];
    
    return (ParseObjectViewController*)[QuickDialogController controllerForRoot:rootElement];
}

+ (QLabelElement*)elementLinkingToObject:(PFObject*)parseObject{
    QLabelElement *element = [[QLabelElement alloc] initWithTitle:[parseObject objectId] Value:@""];
    element.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    element.controllerAction = @"presentChildObject:";
    element.object = parseObject;
    return element;
}

+ (id)elementForObject:(PFObject*)parseObject key:(NSString*)attribute{
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
        element = [[QDecimalElement alloc] initWithTitle:title value:value];
    } else if ([value isKindOfClass:[PFObject class]]) {
        //PFObject is a pointer to a child object
        element = [self elementLinkingToObject:(PFObject*)value];
        [(QLabelElement*)element setTitle:title];
        [(QLabelElement*)element setValue:[(PFObject*)value objectId]];
    } else if ([value isKindOfClass:[PFRelation class]]) {
        //if we receive a PFRelation, fetch the child objects related to this and return a section with them in it
        QSection *relationSection = [[QSection alloc] initWithTitle:title];
        PFQuery *query =[(PFRelation*)value query];
        NSArray *pfobjects = [query findObjects];
        for (PFObject *object in pfobjects) {
            [relationSection addElement:[self elementLinkingToObject:object]];
        }
        return relationSection;
    } else if ([value isKindOfClass:[PFFile class]]) {
        //TODO: handle PFFiles by fetching required information
        PFFile *file = (PFFile*)value;
        element = [[QWebElement alloc] initWithTitle:title url:[file url]];
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

#pragma mark Controller actions

- (void)presentChildObject:(QElement*)element{
    PFObject *childObject = (PFObject*)element.object;
    //make sure we fetch if necessary
    [childObject fetchIfNeededInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        [self.navigationController pushViewController:[ParseObjectViewController objectViewControllerForObject:object] animated:YES];
    }];
}

- (void)saveParseObject:(id)sender{
    PFObject *parseObject = (PFObject*)self.root.object;
    [self.root fetchValueIntoObject:parseObject];
    //save out any changes we may have made in the background
    [parseObject saveInBackground];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)deleteParseObject:(id)sender{
    PFObject *parseObject = (PFObject*)self.root.object;
    [parseObject delete];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
