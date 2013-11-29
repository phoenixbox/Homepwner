//
//  DetailViewController.h
//  Homepwner
//
//  Created by Shane Rogers on 11/25/13.
//  Copyright (c) 2013 Shane Rogers. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BNRItem.h"

@interface DetailViewController : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate, UIPopoverControllerDelegate>

{
    __weak IBOutlet UITextField *nameField;
    __weak IBOutlet UITextField *serialNumberField;
    __weak IBOutlet UITextField *valueField;
    __weak IBOutlet UILabel *dateLabel;
    __weak IBOutlet UIImageView *imageView;
    
    UIPopoverController *imagePickerPopover;
}
@property(nonatomic, strong)BNRItem *item;
- (IBAction)takePicture:(id)sender;
- (IBAction)backgroundTapped:(id)sender;

@end
