//
//  PFObjectListViewController.m
//  ParseQuickDialog
//
//  Created by Joseph Pintozzi on 7/22/13.
//  Copyright (c) 2013 TinyDragonApps. All rights reserved.
//

#import "PFObjectListViewController.h"
#import <Parse/Parse.h>
#import "QuickDialog.h"
#import "ParseObjectViewController.h"
#import "ParseQuickDialog.h"

@implementation PFObjectListViewController
@synthesize objectTitleKey;

+ (PFObjectListViewController*)objectListViewControllerForClassName:(NSString*)parseClassName titleKey:(NSString*)titleKey{
    QRootElement *rootElement = [[QRootElement alloc] init];
    rootElement.title = [parseClassName stringByAppendingString:@" Objects"];
    rootElement.controllerName = NSStringFromClass([self class]);
    rootElement.grouped = YES;
    
    PFObjectListViewController *viewController = (PFObjectListViewController*)[QuickDialogController controllerForRoot:rootElement];
    viewController.objectTitleKey = titleKey;
    
    PFQuery *query = [PFQuery queryWithClassName:parseClassName];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error) {
            [[[UIAlertView alloc] initWithTitle:@"Error" message:error.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        } else {
            [viewController addRowsForObjects:objects];
        }
    }];
    return viewController;
}

// add a section with QElements created from PFObjects
- (void)addRowsForObjects:(NSArray*)objects{
    QSection *section = [[QSection alloc] init];
    for (PFObject *object in objects) {
        QLabelElement *labelElement = [[QLabelElement alloc] init];
        if (self.objectTitleKey && self.objectTitleKey.length){
            labelElement.title = [object objectForKey:self.objectTitleKey];
            labelElement.value = [object objectId];
        } else {
            //check a few commonly used keys to see if we can find a name/title/etc
            for (NSString *key in @[@"name", @"title"]) {
                id val = [object objectForKey:key];
                if (val && [val isKindOfClass:[NSString class]]) {
                    labelElement.title = val;
                    labelElement.value = [object objectId];
                    self.objectTitleKey = key;
                    break;
                }
            }
            
            //if we still have no title, just use the objectId
            if (!labelElement.title) {
                labelElement.title = [object objectId];
            }
        }
        labelElement.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        labelElement.controllerAction = @"showObjectViewController:";
        labelElement.object = object;
        [section addElement:labelElement];
    }
    [self.root addSection:section];
    [self.quickDialogTableView reloadData];
}

- (void)showObjectViewController:(QElement*)element{
    PFObject *object = element.object;
    //TODO: push another view controller for this object
    [self.navigationController pushViewController:[ParseQuickDialog viewControllerForParseObject:object] animated:YES];
}


@end
