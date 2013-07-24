//
//  CapitalKeyParseObjectViewController.m
//  ParseQuickDialog
//
//  Created by Joseph Pintozzi on 7/23/13.
//  Copyright (c) 2013 TinyDragonApps. All rights reserved.
//

#import "CapitalKeyParseObjectViewController.h"

@implementation CapitalKeyParseObjectViewController

+ (NSString*)titleForKey:(NSString*)key{
    return [[[key substringToIndex:1] uppercaseString] stringByAppendingString:[key substringFromIndex:1]];
}

@end