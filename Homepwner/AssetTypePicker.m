//
//  AssetTypePicker.m
//  Homepwner
//
//  Created by Shane Rogers on 11/30/13.
//  Copyright (c) 2013 Shane Rogers. All rights reserved.
//

#import "AssetTypePicker.h"
#import "BNRItemStore.h"
#import "BNRItem.h"

@implementation AssetTypePicker

@synthesize item;

-(id)init
{
    return [super initWithStyle:UITableViewStyleGrouped];
}
-(id)initWithStyle:(UITableViewStyle)style
{
    return [self init];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[BNRItemStore sharedStore] allAssetTypes]count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)ip
{
    UITableViewCell *cell =
    [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:@"UITableViewCell"];
    }
    NSArray *allAssets = [[BNRItemStore sharedStore] allAssetTypes];
    NSManagedObject *assetType = [allAssets objectAtIndex:[ip row]];
    // Use key-value coding to get the asset type's label
    NSString *assetLabel = [assetType valueForKey:@"label"];
    [[cell textLabel] setText:assetLabel];
    // Checkmark the one that is currently selected
    if (assetType == [item assetType]) {
        [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
    } else {
        [cell setAccessoryType:UITableViewCellAccessoryNone];
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)ip
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:ip];
    [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
    NSArray *allAssets = [[BNRItemStore sharedStore] allAssetTypes];
    NSManagedObject *assetType = [allAssets objectAtIndex:[ip row]];
    [item setAssetType:assetType];
    [[self navigationController] popViewControllerAnimated:YES];
}
@end
