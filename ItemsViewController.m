//
//  ItemsViewController.m
//  Homepwner
//
//  Created by Shane Rogers on 11/20/13.
//  Copyright (c) 2013 Shane Rogers. All rights reserved.
//

#import "ItemsViewController.h"
#import "BNRItemStore.h"
#import "BNRItem.h"

@implementation ItemsViewController

- (id)init
{
    // Call superclasse's designated intializer
    self = [super initWithStyle:UITableViewStyleGrouped];
    if(self){
        for (int i = 0; i < 5;i++) {
            [[BNRItemStore sharedStore] createItem];
        }
    }
    return self;
}
-(void)addNewItem:(id)sender
{
    // Make an index path for the 0th (first) section, last row
    // int lastRow = [[self tableView] numberOfRowsInSection:0];
    
    BNRItem *newItem = [[BNRItemStore sharedStore]createItem];
    
    int lastRow = [[[BNRItemStore sharedStore]allItems]indexOfObject:newItem];
    
    NSIndexPath *ip = [NSIndexPath indexPathForRow:lastRow inSection:0];
    
    // Insert the new row
    [[self tableView] insertRowsAtIndexPaths:[NSArray arrayWithObject:ip]
                             withRowAnimation:UITableViewRowAnimationTop];
}

-(void)toggleEditingMode:(id)sender
{
    // If in editing mode
    if([self isEditing]){
    // Change text to indicate state
    [sender setTitle:@"Edit" forState:UIControlStateNormal];
    // Turn off editing mode - animating for the slide
    [self setEditing:NO animated:YES];
    } else {
    [sender setTitle:@"Done" forState:UIControlStateNormal];
    [self setEditing:YES animated:YES];
    }
}

-(id)initWithStyle:(UITableViewStyle)style
{
    return [self init];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return( [[[BNRItemStore sharedStore] allItems] count] );
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
    
    // Update to reuse cells
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    
    // If there is no  reusable cell of the right type then create one
    if(!cell){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
    }
    
    BNRItem *p = [[[BNRItemStore sharedStore] allItems] objectAtIndex:[indexPath row]];
                         
    [[cell textLabel] setText:[p description]];
                         
    return cell;
}

-(UIView *)headerView
{
    //    Load the headerView nib if it has not been already
    if(!headerView){
        [[NSBundle mainBundle] loadNibNamed:@"HeaderView" owner:self options:nil];
    }
    return headerView;
}

-(UIView *)tableView:(UITableView *)tv viewForHeaderInSection:(NSInteger)sec
{
    return [self headerView];
}

-(CGFloat)tableView:(UITableView *)tv heightForHeaderInSection:(NSInteger)sec
{
    //    Height of the header view should be determined from the height of the view in the XIB file
    return [[self headerView] bounds].size.height;
}
@end
