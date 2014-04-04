//
//  DetailViewController.m
//  Homepwner
//
//  Created by Krystle on 2/19/14.
//  Copyright (c) 2014 Krystle Kidd. All rights reserved.
//

#import "DetailViewController.h"
#import "BNRItem.h"
#import "BNRImageStore.h"
#import "BNRItemStore.h"
#import "AssetTypePickter.h"

@interface DetailViewController ()

@end

@implementation DetailViewController
@synthesize item;
@synthesize dismissBlock;

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [nameField setText:[item itemName]];
    [serialNumberField setText:[item serialNumber]];
    [valueField setText:[NSString stringWithFormat:@ "%d", [item valueInDollars]]];
    
    //Create a NSDateFormatter that will turn a date into a simple date string
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    
    //Convert time interval to NSDate
    NSDate *date = [NSDate dateWithTimeIntervalSinceReferenceDate:[item dateCreated]];
    [dateLabel setText:[dateFormatter stringFromDate:date]];
    
    
    NSString *imageKey = [item imageKey];
    
    if(imageKey){
        //Get image for image key from image store
        UIImage *imageToDisplay = [[BNRImageStore sharedStore]imageForKey:imageKey];
        
        //Use that image to put on the screen in imageView
        [imageView setImage:imageToDisplay];
    }else {
        //Clear the imageView
        [imageView setImage:nil];
    }
    NSString *typeLabel = [[item assetType] valueForKey:@"label"];
    if (!typeLabel)
        typeLabel = @"None";
    
    [assetTypeButton setTitle:[NSString stringWithFormat:@"Type: %@", typeLabel] forState:UIControlStateNormal];
}

-(void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    //Clear first responder
    [[self view] endEditing:YES];
    
    // Save changes to item
    [item setItemName:[nameField text]];
    [item setSerialNumber:[serialNumberField text]];
    [item setValueInDollars:[[valueField text] intValue]];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    UIColor *clr= nil;
    if ([[UIDevice currentDevice]userInterfaceIdiom] == UIUserInterfaceIdiomPad){
        clr = [UIColor colorWithRed:0.875 green:0.88 blue:0.91 alpha:1];
    }else {
        clr = [UIColor groupTableViewBackgroundColor];
    }
    [[self view]setBackgroundColor:clr];
}
-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)io{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad){
        return YES;
    }else {
        return (io= UIInterfaceOrientationPortrait);
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) setItem:(BNRItem *)i {
    item = i;
    [[self navigationItem] setTitle: [item itemName]];
}

- (IBAction)takePicture:(id)sender {
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc]init];
    if ([imagePickerPopover isPopoverVisible]){
        //If the popover is visiable get rid of it
        [imagePickerPopover dismissPopoverAnimated:YES];
        imagePickerPopover=nil;
        return;
    }
   
    //If our device has a camera we want to take otherwise we just pick one from the library
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        [imagePicker setSourceType:UIImagePickerControllerSourceTypeCamera];
    }else {
        [imagePicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        
    }
    //allow user to edit image
    [imagePicker setAllowsEditing:YES];
    [imagePicker setDelegate:self];
    
    //Place image picker on the screen
   
    //Check for iPad device before instantiation the popover controller
    if ([[UIDevice currentDevice]userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        imagePickerPopover = [[UIPopoverController alloc] initWithContentViewController:imagePicker];
        
        [imagePickerPopover setDelegate:self];
        
        //Display the popover controller; sender is the camera bar button item
        [imagePickerPopover presentPopoverFromBarButtonItem:sender permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    }else{
         [self presentViewController:imagePicker animated:YES completion:nil];
    }
}

- (IBAction)backgroundTapped:(id)sender {
    [[self view] endEditing:YES];
    [valueField resignFirstResponder];
}
//// action for button so when presses takes away image
- (IBAction)clearImage:(id)sender {
    [imageView setImage:nil];
}
-(void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *oldKey = [item imageKey];
    
    //Did the item already have an image"
    if (oldKey) {
        //Delete the old image
        [[BNRImageStore sharedStore]deleteImageForKey:oldKey];
    }
    
    //Get Picked image from info dictionary
    UIImage *image = [info objectForKey: UIImagePickerControllerOriginalImage];
    
    [item setThumbnailDataFromImage:image];
    
    //Create a CFUUID object
    CFUUIDRef newUniqueID = CFUUIDCreate(kCFAllocatorDefault);
    
    //Create a string from unique identifer
    CFStringRef newUniqueIDString = CFUUIDCreateString(kCFAllocatorDefault, newUniqueID);
    //Use that id to set our item's image key
    NSString *key = (__bridge NSString *) newUniqueIDString;
    [item setImageKey:key];
    //store image in the BNRItemStore with this key
    [[BNRImageStore sharedStore] setImage:image forKey:[item imageKey]];
    
    CFRelease(newUniqueIDString);
    CFRelease(newUniqueID);
    
    //Put that image onto the screen in our image view
    [imageView setImage:image];
    
    //Take image picker off the screen
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone){
        //If on the phone, the image picker is presented modally. Dismiss it
        [self dismissViewControllerAnimated:YES completion:nil];
    }else{
        //IF on the pad, the image picker is in the popover. Dismiss the popover
        [imagePickerPopover dismissPopoverAnimated:YES];
        imagePickerPopover = nil;
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
-(void) popoverControllerDidDismissPopover:(UIPopoverController *)popoverController{
    NSLog(@"User dismissed popover");
    imagePickerPopover = nil;
}
-(id)initForNewItem:(BOOL)isNew {
    if (self) {
        if(isNew) {
            UIBarButtonItem *doneItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(save:)];
            [[self navigationItem]setRightBarButtonItem:doneItem];
            
            UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel:)];
            [[self navigationItem] setLeftBarButtonItem:cancelItem];
        }
    }
    return self;
}

-(id) initWithNibName:(NSString *)nibName bundle:(NSBundle *)bundle{
    @throw [NSException exceptionWithName:@"Wrong initializer" reason:@ "Use initForNewItem:"userInfo:nil];
    return nil;
}
-(void)save: (id)sender{
    [[self presentingViewController]dismissViewControllerAnimated:YES completion:dismissBlock];
}
-(void)cancel: (id)sender {
    //If the user cancelled, then remove the BNRItem from the store
    [[BNRItemStore sharedStore]removeItem:item];
    
    [[self presentingViewController]dismissViewControllerAnimated:YES completion:dismissBlock];
}
- (IBAction)showAssetTypePicker:(id)sender {
    [[self view]endEditing:YES];
    
    AssetTypePickter *assetTypePicker = [[AssetTypePickter alloc]init];
    [assetTypePicker setItem: item];
    
    [[self navigationController] pushViewController:assetTypePicker animated:YES];
}
@end
