//
//  ParseObjectViewController.h
//  ParseQuickDialog
//
//  Created by Joseph Pintozzi on 7/22/13.
//  Copyright (c) 2013 TinyDragonApps. All rights reserved.
//

#import "QuickDialog.h"
#import <Parse/Parse.h>

@interface ParseObjectViewController : QuickDialogController

+ (ParseObjectViewController*)objectViewControllerForObject:(PFObject*)parseObject;

// Controls whether or not the objectId, createdAt, and updatedAt be shown in a section
+ (BOOL)showsImmutableValues;

// Controls what keys to show and allow users to edit
+ (NSArray*)orderedKeysForObject:(PFObject*)parseObject;

// Controls what title to show for a specified key
+ (NSString*)titleForKey:(NSString*)key;

// Controls what QuickDialog elements will be used for specific keys
+ (id)elementForObject:(PFObject*)parseObject key:(NSString*)attribute;

@end