//
//  BNRImageStore.m
//  Homepwner
//
//  Created by Shane Rogers on 11/28/13.
//  Copyright (c) 2013 Shane Rogers. All rights reserved.
//

#import "BNRImageStore.h"

@implementation BNRImageStore

+(id)allocWithZone:(NSZone *)zone
{
    return [self sharedStore];
}

+(BNRImageStore *)sharedStore
{
    static BNRImageStore *sharedStore = nil;
    if(!sharedStore){
        // Create the singleton
        sharedStore = [[super allocWithZone:NULL]init];
    }
    return sharedStore;
}

-(id)init
{
    self = [super init];
    if (self) {
        dictionary = [[NSMutableDictionary alloc]init];
    }
    return self;
}

-(void)setImage:(UIImage *)i forKey:(NSString *)s
{
    [dictionary setObject:i forKey:s];
    
    //Create the full path for the image
    NSString *imagePath = [self imagePathForKey:s];
    
    // Turn Image into JPEG data
    NSData *d = UIImageJPEGRepresentation(i,0.5);
    
    // Write it to full path
    [d writeToFile:imagePath atomically:YES];
}

-(UIImage *)imageForKey:(NSString *)s
{
    // Retrieve from the dictionary if possible
    UIImage *result = [dictionary objectForKey:s];
    
    if(!result){
        // Create UIImage object from file
        result = [UIImage imageWithContentsOfFile:[self imagePathForKey:s]];
        // If there is an image - place it in the dictionary - cache it
        if(result){
            [dictionary setObject:result forKey:s];
        } else {
            NSLog(@"Error, unable to find image: %@",[self imagePathForKey:s]);
        }
    }
    return result;
}

-(void)deleteImageForKey:(NSString *)s
{
    if(!s){
        return;
        [dictionary removeObjectForKey:s];
        
        NSString *path = [self imagePathForKey:s];
        [[NSFileManager defaultManager] removeItemAtPath:path
                                                   error:NULL];
    }
}

-(NSString *)imagePathForKey:(NSString *)key
{
    NSArray *documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *documentDirectory = [documentDirectories objectAtIndex:0];
    
    return [documentDirectory stringByAppendingPathComponent:key];
}
@end
