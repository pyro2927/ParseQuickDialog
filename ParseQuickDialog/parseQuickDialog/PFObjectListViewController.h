//
//  PFObjectListViewController.h
//  ParseQuickDialog
//
//  Created by Joseph Pintozzi on 7/22/13.
//  Copyright (c) 2013 TinyDragonApps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QuickDialogController.h"

@interface PFObjectListViewController : QuickDialogController{
    NSString *objectTitleKey;
}

@property (nonatomic) NSString *objectTitleKey; 

+ (PFObjectListViewController*)objectListViewControllerForClassName:(NSString*)parseClassName titleKey:(NSString*)titleKey;

@end