//
//  BNRItem.m
//  RandomPossessions
//
//  Created by joeconway on 7/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "BNRItem.h"

@implementation BNRItem
@synthesize container;
@synthesize containedItem;
@synthesize itemName, serialNumber, dateCreated, valueInDollars;
@synthesize imageKey;
// Image thumbnail implementation
@synthesize thumbnail, thumbnailData;

+ (id)randomItem
{
    // Create an array of three adjectives
    NSArray *randomAdjectiveList = [NSArray arrayWithObjects:@"Fluffy",
                                    @"Rusty",
                                    @"Shiny", nil];
    // Create an array of three nouns
    NSArray *randomNounList = [NSArray arrayWithObjects:@"Bear",
                               @"Spork",
                               @"Mac", nil];
    // Get the index of a random adjective/noun from the lists
    // Note: The % operator, called the modulo operator, gives
    // you the remainder. So adjectiveIndex is a random number
    // from 0 to 2 inclusive.
    NSInteger adjectiveIndex = rand() % [randomAdjectiveList count];
    NSInteger nounIndex = rand() % [randomNounList count];
    
    // Note that NSInteger is not an object, but a type definition
    // for "unsigned long"
    
    NSString *randomName = [NSString stringWithFormat:@"%@ %@",
                            [randomAdjectiveList objectAtIndex:adjectiveIndex],
                            [randomNounList objectAtIndex:nounIndex]];
    int randomValue = rand() % 100;
    NSString *randomSerialNumber = [NSString stringWithFormat:@"%c%c%c%c%c",
                                    '0' + rand() % 10,
                                    'A' + rand() % 26,
                                    '0' + rand() % 10,
                                    'A' + rand() % 26,
                                    '0' + rand() % 10];
    // Once again, ignore the memory problems with this method
    BNRItem *newItem =
    [[self alloc] initWithItemName:randomName
                    valueInDollars:randomValue
                      serialNumber:randomSerialNumber];
    return newItem;
}

- (id)initWithItemName:(NSString *)name
        valueInDollars:(int)value
          serialNumber:(NSString *)sNumber
{
    // Call the superclass's designated initializer
    self = [super init];
    
    // Did the superclass's designated initializer succeed?
    if(self) {
        // Give the instance variables initial values
        [self setItemName:name];
        [self setSerialNumber:sNumber];
        [self setValueInDollars:value];
        dateCreated = [[NSDate alloc] init];
    }
    
    // Return the address of the newly initialized object
    return self;
}

- (id)init 
{
    return [self initWithItemName:@"Sample Item"
                   valueInDollars:0
                     serialNumber:@"12345"];
}


- (void)setContainedItem:(BNRItem *)i
{
    containedItem = i;
    [i setContainer:self];
}

- (NSString *)description
{
    NSString *descriptionString =
    [[NSString alloc] initWithFormat:@"%@ (%@): Worth $%d, recorded on %@",
     itemName,
     serialNumber,
     valueInDollars,
     dateCreated];
    return descriptionString;
}
- (void)dealloc
{
    NSLog(@"Destroyed: %@ ", self);
}
-(void)encodeWithCoder:(NSCoder *)aCoder
{
    // Encode all the instance variables - key naming convention is the string name of the instance variable
    [aCoder encodeObject:itemName forKey:@"itemName"];
    [aCoder encodeObject:serialNumber forKey:@"serialNumber"];
    [aCoder encodeObject:dateCreated forKey:@"dateCreated"];
    [aCoder encodeObject:imageKey forKey:@"imageKey"];
    
    [aCoder encodeObject:thumbnailData forKey:@"thumbnailData"];
    
    [aCoder encodeInt:valueInDollars forKey:@"valueInDollars"];
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        [self setItemName:[aDecoder decodeObjectForKey:@"itemName"]];
        [self setSerialNumber:[aDecoder decodeObjectForKey:@"serialNumber"]];
        [self setImageKey:[aDecoder decodeObjectForKey:@"imageKey"]];
        [self setValueInDollars:[aDecoder decodeIntForKey:@"valueInDollars"]];
        
        dateCreated = [aDecoder decodeObjectForKey:@"dateCreated"];
        
        thumbnailData = [aDecoder decodeObjectForKey:@"thumbnailData"];
    }
    return self;
}

-(UIImage *)thumbnail
{
    // If there is no thumbnail data available on the instance, then there is nothing to return
    if(!thumbnailData){
        return nil;
    }
    // If no thumbnail has been created from the data, create it
    if(!thumbnail){
        // Create the image from the data
        thumbnail = [UIImage imageWithData:thumbnailData];
    }
    return thumbnail;
}
-(void)setThumbnailDataFromImage:(UIImage *)image
{
    CGSize origImageSize = [image size];
    
    // Thumnail Rectangle
    CGRect newRect = CGRectMake(0,0,40,40);
    
    // Figure out scaling ratio so we maintain same aspect ratio
    float ratio = MAX(newRect.size.width / origImageSize.width,
                      newRect.size.height / origImageSize.height);
    
    // Transparent bitmap context with a scaling factor equal to the screen - A new CGContextRef is created – becomes the current context
    UIGraphicsBeginImageContextWithOptions(newRect.size,NO,0.0);
    
    // Create a path that is a rounded rectangle - mask that will clip the image
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:newRect
                                                    cornerRadius:0.5];
    
    // Make all subsequent drawings be clipped to the path of the rounded rectangle
    [path addClip];
    
    // Center the image in the thumnail rectangle
    CGRect projectRect;
    projectRect.size.width = ratio * origImageSize.width;
    projectRect.size.height = ratio * origImageSize.height;
    projectRect.origin.x = (newRect.size.width - projectRect.size.width)/2.0;
    projectRect.origin.y = (newRect.size.height - projectRect.size.height)/2.0;
    
    // Draw the image on the rectange
    [image drawInRect:projectRect];
    
    // Get the image from the image context - keep it as the thumbnail
    UIImage *smallImage = UIGraphicsGetImageFromCurrentImageContext();
    [self setThumbnail:smallImage];
    
    // Get the PNG representation of the image and set it as our archivable data
    NSData *data = UIImagePNGRepresentation(smallImage);
    [self setThumbnailData:data];
    
    // Cleanup the image context resources
    UIGraphicsEndImageContext();
    
}
@end
