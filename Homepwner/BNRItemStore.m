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
        // Read in the application core data model file
        model = [NSManagedObjectModel mergedModelFromBundles:nil];
        
        NSPersistentStoreCoordinator *psc = [[NSPersistentStoreCoordinator alloc]initWithManagedObjectModel:model];
        
        // Find out where the SQLite file goes
        NSString *path = [self itemArchivePath];
        NSURL *storeURL = [NSURL fileURLWithPath:path];
        
        NSError *error = nil;
        
        if(![psc addPersistentStoreWithType:NSSQLiteStoreType
                              configuration:nil
                                        URL:storeURL
                                    options:nil
                                      error:&error]){
            [NSException raise:@"Sorry Open Failed :("
                        format:@"Reason: %@",[error localizedDescription]];
        }
        
        // Create the managed object context
        context = [[NSManagedObjectContext alloc]init];
        [context setPersistentStoreCoordinator:psc];
        
        //The managed object context can manage undo but it is not needed
        [context setUndoManager:nil];
        
        [self loadAllItems];
    }
    return self;
}

-(NSArray *)allItems
{
    return allItems;
}

-(BNRItem *)createItem
{
    double order;
    if([allItems count] == 0){
        order = 1.0;
    } else {
        order = [[allItems lastObject]orderingValue]+1.0;
    }
    
    NSLog(@"Adding after %d items, order = %.2f", [allItems count], order);
    
    BNRItem *p = [NSEntityDescription insertNewObjectForEntityForName:@"BNRItem"
                                               inManagedObjectContext:context];
    
    [p setOrderingValue:order];
    
    [allItems addObject:p];
    
    return p;
}

-(void)removeItem:(BNRItem *)p
{
    // Get the items imageKey attribute and use it to lookup and delete from the store
    NSString *key = [p imageKey];
    [[BNRImageStore sharedStore]deleteImageForKey:key];
    [context deleteObject:p];
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
    
    // Compute a new orderValue for the object that was moved
    double lowerBound = 0.0;
    
    // See if there is an object before it in the array
    if (to > 0){
        lowerBound = [[allItems objectAtIndex:to - 1]orderingValue];
    } else {
        lowerBound = [[allItems objectAtIndex:1]orderingValue] -2.0;
    }
    
    double upperBound = 0.0;
    
    // See if there is an object after it in the array
    if (to < [allItems count]-1){
        upperBound = [[allItems objectAtIndex:to +1]orderingValue];
    } else {
        upperBound = [[allItems objectAtIndex:to - 1]orderingValue]+2.0;
    }
    
    double newOrderValue = (lowerBound + upperBound)/2.0;
    
    NSLog(@"moving to order %f", newOrderValue);
    [p setOrderingValue:newOrderValue];
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
    return [documentDirectory stringByAppendingPathComponent:@"store.data"];
}
-(BOOL)saveChanges
{
    NSError *err = nil;
    BOOL successful = [context save:&err];
    if(!successful){
        NSLog(@"Error saving: %@", [err localizedDescription]);
    }
    return successful;
}
-(void)loadAllItems
{
    if(!allItems){
        NSFetchRequest *request = [[NSFetchRequest alloc]init];
        
        NSEntityDescription *e = [[model entitiesByName] objectForKey:@"BNRItem"];
        [request setEntity:e];
        
        NSSortDescriptor *sd = [NSSortDescriptor
                                sortDescriptorWithKey:@"orderingValue" ascending:YES];
        [request setSortDescriptors:[NSArray arrayWithObjects:sd,nil]];
        
        NSError *error;
        // Execute the fetch
        NSArray *result = [context executeFetchRequest:request error:&error];
        
        if(!result){
            [NSException raise:@"Fetch failed"
                        format:@"Reason %@", [error localizedDescription]];
        }
        allItems = [[NSMutableArray alloc]initWithArray:result];
    }
}
@end