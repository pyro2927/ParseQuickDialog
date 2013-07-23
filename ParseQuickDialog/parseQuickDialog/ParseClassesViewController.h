//
//  ParseClassesViewController.h
//  ParseQuickDialog
//
//  Created by Joseph Pintozzi on 7/22/13.
//  Copyright (c) 2013 TinyDragonApps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QuickDialog.h"

@interface ParseClassesViewController : QuickDialogController

+ (ParseClassesViewController*)classesViewControllerWithClasses:(NSArray*)classes;

@end
