//
//  BNRImageStore.h
//  Homepwner
//
//  Created by Shane Rogers on 11/28/13.
//  Copyright (c) 2013 Shane Rogers. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BNRImageStore : NSObject
{
    NSMutableDictionary *dictionary;
}
+(BNRImageStore *)sharedStore;
-(void)setImage:(UIImage *)i forKey:(NSString *)s;
-(UIImage *)imageForKey:(NSString *)s;
-(void)deleteImageForKey:(NSString *)s;

@end
