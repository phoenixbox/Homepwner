//
//  BNRItem.h
//  Homepwner
//
//  Created by Shane Rogers on 11/30/13.
//  Copyright (c) 2013 Shane Rogers. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface BNRItem : NSManagedObject

@property (nonatomic, retain) NSString * itemName;
@property (nonatomic, retain) NSString * serialNumber;
@property (nonatomic) int32_t valueInDollars;
@property (nonatomic, retain) NSString * imageKey;
@property (nonatomic, retain) NSData * thumbnailData;
@property UNKNOWN_TYPE UNKNOWN_TYPE thumbnail;
@property (nonatomic) NSTimeInterval dateCreated;
@property (nonatomic) double orderingValue;
@property UNKNOWN_TYPE UNKNOWN_TYPE attribute;
@property (nonatomic, retain) NSManagedObject *assetType;

@end
