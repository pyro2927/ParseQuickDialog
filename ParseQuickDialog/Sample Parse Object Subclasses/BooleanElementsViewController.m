//
//  BooleanElementsViewController.m
//  ParseQuickDialog
//
//  Created by Joseph Pintozzi on 7/23/13.
//  Copyright (c) 2013 TinyDragonApps. All rights reserved.
//

#import "BooleanElementsViewController.h"

@implementation BooleanElementsViewController

+ (QElement*)elementForObject:(PFObject*)parseObject key:(NSString*)attribute{
    id val = [parseObject objectForKey:attribute];
    if ([val isKindOfClass:[NSNumber class]]) {
        return [[QBooleanElement alloc] initWithTitle:[self titleForKey:attribute] BoolValue:[val boolValue]];
    }
    return [super elementForObject:parseObject key:attribute];
}

@end
