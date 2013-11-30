//
//  BNRItemStore.m
//  Homepwner
//
//  Created by Shane Rogers on 11/21/13.
//  Copyright (c) 2013 Shane Rogers. All rights reserved.
//

#import "BNRItemStore.h"
#import "BNRItem.h"
#import "BNRImageStore.h"

@implementation BNRItemStore

-(id)init
{
    self = [super init];
    if (self){
        allItems = [[NSMutableArray alloc]init];
        NSString *path = [self itemArchivePath];
        
        allItems = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
        // If the array hadnt been saved previously, create a new empty one
        if (!allItems){
            allItems = [[NSMutableArray alloc]init];
        }
        
    }
    return self;
}

-(NSArray *)allItems
{
    return allItems;
}

-(BNRItem *)createItem
{
    BNRItem *p = [[BNRItem alloc]init];
    
    [allItems addObject:p];
    
    return p;
}

-(void)removeItem:(BNRItem *)p
{
    // Get the items imageKey attribute and use it to lookup and delete from the store
    NSString *key = [p imageKey];
    [[BNRImageStore sharedStore]deleteImageForKey:key];
    
    [allItems removeObjectIdenticalTo:p];
}

-(void)moveItemAtIndex:(int)from toIndex:(int)to
{
    if(from == to){
        return;
    }
    
    BNRItem *p = [allItems objectAtIndex:from];
    
    [allItems removeObjectAtIndex:from];
    
    [allItems insertObject:p atIndex:to];
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
-(NSString *)itemArchivePath
{
    // get all iOS directories for Document
    NSArray *documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    // get the one that pertains the application
    NSString *documentDirectory = [documentDirectories objectAtIndex:0];
    // return this directory with the correct extension
    return [documentDirectory stringByAppendingPathComponent:@"items.archive"];
}
-(BOOL)saveChanges
{
    // returns success or failure
    NSString *path = [self itemArchivePath];
    
    return [NSKeyedArchiver archiveRootObject:allItems
                                       toFile:path];
}
@end
