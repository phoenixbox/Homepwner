//
//  BNRItem.m
//  Homepwner
//
//  Created by Shane Rogers on 11/30/13.
//  Copyright (c) 2013 Shane Rogers. All rights reserved.
//

#import "BNRItem.h"


@implementation BNRItem

@dynamic itemName;
@dynamic serialNumber;
@dynamic valueInDollars;
@dynamic imageKey;
@dynamic thumbnailData;
@dynamic thumbnail;
@dynamic dateCreated;
@dynamic orderingValue;
@dynamic assetType;

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

-(void)awakeFromFetch
{
    [super awakeFromFetch];
    
    UIImage *tn = [UIImage imageWithData:[self thumbnailData]];
    [self setPrimitiveValue:tn forKey:@"thumbnail"];
}

-(void)awakeFromInsert
{
    [super awakeFromInsert];
    NSTimeInterval t = [[NSDate date] timeIntervalSinceReferenceDate];
    [self setDateCreated:t];
}

@end
