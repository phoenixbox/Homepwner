//
//  BNRItemStore.m
//  Homepwner
//
//  Created by Shane Rogers on 11/21/13.
//  Copyright (c) 2013 Shane Rogers. All rights reserved.
//

#import "BNRItemStore.h"
#import "BNRItem.h"

@implementation BNRItemStore

-(id)init
{
    self = [super init];
    if (self){
        allItems = [[NSMutableArray alloc]init];
    }
    return self;
}

-(NSArray *)allItems
{
    return allItems;
}

-(BNRItem *)createItem
{
    BNRItem *p = [BNRItem randomItem];
    
    [allItems addObject:p];
    
    return p;
}

-(void)removeItem:(BNRItem *)p
{
    [allItems removeObjectIdenticalTo:p];
}

+ (BNRItemStore *)sharedStore
{
    static BNRItemStore *sharedStore = nil;
    if(!sharedStore) sharedStore = [[super allocWithZone:nil]init];
    return sharedStore;
}

+(id)allocWithZone:(NSZone *)zone
{
    return [self sharedStore];
}
@end
