//
//  ParseObjectViewController.h
//  ParseQuickDialog
//
//  Created by Joseph Pintozzi on 7/22/13.
//  Copyright (c) 2013 TinyDragonApps. All rights reserved.
//

#import "QuickDialogController.h"
#import <Parse/Parse.h>

@interface ParseObjectViewController : QuickDialogController

+ (ParseObjectViewController*)objectViewControllerForObject:(PFObject*)parseObject;

@end