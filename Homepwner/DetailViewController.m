//
//  DetailViewController.m
//  Homepwner
//
//  Created by Shane Rogers on 11/25/13.
//  Copyright (c) 2013 Shane Rogers. All rights reserved.
//

#import "DetailViewController.h"
#import "BNRItem.h"
#import "BNRImageStore.h"

@interface DetailViewController ()

@end

@implementation DetailViewController

@synthesize item;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [[self view]setBackgroundColor:[UIColor groupTableViewBackgroundColor ]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL) animated
{
    [super viewWillAppear:animated];
    
    [nameField setText:[item itemName]];
    [serialNumberField setText:[item serialNumber]];
    [valueField setText:[NSString stringWithFormat:@"%d",[item valueInDollars]]];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    
    [dateLabel setText:[dateFormatter stringFromDate:[item dateCreated]]];
    
    // Get the items imageKey string value for the BNRImageStore dictionary lookup
    NSString *imageKey = [item imageKey];
    // Do the lookup
    if (imageKey){
        UIImage *imageToDisplay = [[BNRImageStore sharedStore] imageForKey:imageKey];
        // Set it in the imageView property for the objects DetailView
        [imageView setImage:imageToDisplay];
    } else {
        // Clear the imageView
        [imageView setImage:nil];
    }
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];

    // Clear the first responder - will dismiss the keyboard
    [[self view]endEditing:(YES)];
    
    // Save changes to item
    [item setItemName:[nameField text]];
    [item setSerialNumber:[serialNumberField text]];
    [item setValueInDollars:[[valueField text] intValue]];
    
}
-(void)setItem:(BNRItem *)i
{
    item = i;
    [[self navigationItem] setTitle:[item itemName]];
}

- (IBAction)takePicture:(id)sender {
    UIImagePickerController *imagePicker= [[UIImagePickerController alloc]init];
    
    // Chech the device for a camera - NO - then pick photo from photo library
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        [imagePicker setSourceType:UIImagePickerControllerSourceTypeCamera];
    } else {
        [imagePicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    }
    [imagePicker setDelegate:self];
    
    [self presentViewController:imagePicker animated:YES completion:nil];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString * oldKey = [item imageKey];
    
    if(oldKey){
        [[BNRImageStore sharedStore]deleteImageForKey:oldKey];
    }
    // Get the picked image info from the info Dictionary
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    // Create the UUID for the image
    CFUUIDRef newUniqueID = CFUUIDCreate(kCFAllocatorDefault);
    // Convert CFUUID from bytes to strings
    CFStringRef newUniqueIDString = CFUUIDCreateString(kCFAllocatorDefault, newUniqueID);
    
    // Typecase the C id to be used as the images String type key
    NSString *key = (__bridge NSString *)newUniqueIDString;
    [item setImageKey:key];
    
    // Store the image in the BNRImageStore with this typecasted id
    [[BNRImageStore sharedStore] setImage:image
                                   forKey:[item imageKey]];
    
    CFRelease(newUniqueID);
    CFRelease(newUniqueIDString);
    
    // Put that image onto the screen in the imageView
    [imageView setImage:(image)];
    // Remove image picker from screen with a dismiss method
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
