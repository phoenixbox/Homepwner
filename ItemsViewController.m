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
    self = [super initWithStyle:UITableViewStyleGrouped];
    if(self){
        for (int i=0; i<5;i++){
            [[BNRItemStore sharedStore]createItem];
        }
    }
    
    return self;
}

-(id)initWithStyle:(UITableViewStyle)style
{
    return [self init];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return([[[BNRItemStore sharedStore] allItems] count]);
}
@end
