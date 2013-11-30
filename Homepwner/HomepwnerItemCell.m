//
//  HomepwnerItemCell.m
//  Homepwner
//
//  Created by Shane Rogers on 11/29/13.
//  Copyright (c) 2013 Shane Rogers. All rights reserved.
//

#import "HomepwnerItemCell.h"

@implementation HomepwnerItemCell
@synthesize thumbnailView;
@synthesize nameLabel;
@synthesize valueLabel;
@synthesize serialNumberLabel;

@synthesize controller, tableView;

- (IBAction)showImage:(id)sender {
    // Get the name of this method, 'showImage'
    NSString *selector = NSStringFromSelector(_cmd);
    // Append the right selector string to it 'atIndexPath'
    selector = [selector stringByAppendingString:@"atIndexPath:"];
    
    // Create a new selector from this constructed string
    SEL newSelector = NSSelectorFromString(selector);
    
    NSIndexPath *indexPath = [[self tableView] indexPathForCell:self];
    
    if(indexPath){
        if([[self controller] respondsToSelector:newSelector]){
            [[self controller] performSelector:newSelector
                                    withObject:sender
                                    withObject:indexPath];
        }
    }
}
@end
