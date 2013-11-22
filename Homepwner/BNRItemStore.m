//
//  BNRItemStore.m
//  Homepwner
//
//  Created by Shane Rogers on 11/21/13.
//  Copyright (c) 2013 Shane Rogers. All rights reserved.
//

#import "BNRItemStore.h"

@implementation BNRItemStore

+ (BNRItemStore *)sharedStored
{
    static BNRItemStore *sharedStore = nil;
    if(!sharedStore)
        sharedStore = [[super allocWithZone:nil]init];
    return sharedStore;
}

+(id)allocWithZone:(NSZone *)zone
{
    return [self sharedStored];
}
@end
