//
//  BNRItemStore.h
//  Homepwner
//
//  Created by Shane Rogers on 11/21/13.
//  Copyright (c) 2013 Shane Rogers. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BNRItem;

@interface BNRItemStore : NSObject
{
    NSMutableArray *allItems;
}

+ (BNRItemStore *)sharedStore;

- (NSArray *)allItems;
- (BNRItem *)createItem;
-(void)removeItem:(BNRItem *)p;

@end
