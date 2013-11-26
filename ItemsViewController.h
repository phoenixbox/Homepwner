//
//  ItemsViewController.h
//  Homepwner
//
//  Created by Shane Rogers on 11/20/13.
//  Copyright (c) 2013 Shane Rogers. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ItemsViewController : UITableViewController <UITableViewDelegate>
{
    IBOutlet UIView *headerView;
}

- (UIView *)headerView;
- (IBAction)addNewItem:(id)sender;
- (IBAction)toggleEditingMode:(id)sender;

@end
