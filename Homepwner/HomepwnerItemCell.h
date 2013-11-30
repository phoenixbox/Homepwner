//
//  HomepwnerItemCell.h
//  Homepwner
//
//  Created by Shane Rogers on 11/29/13.
//  Copyright (c) 2013 Shane Rogers. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HomepwnerItemCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *thumbnailView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *serialNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *valueLabel;
- (IBAction)showImage:(id)sender;

// Cell pointers to its controller and table
@property (weak, nonatomic) id controller;
@property (weak, nonatomic) UITableView *tableView;

@end
