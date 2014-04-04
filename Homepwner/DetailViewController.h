//
//  DetailViewController.h
//  Homepwner
//
//  Created by Krystle on 2/19/14.
//  Copyright (c) 2014 Krystle Kidd. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BNRItem;


@interface DetailViewController : UIViewController
    < UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate, UIPopoverControllerDelegate >
{
    __weak IBOutlet UITextField *nameField;

    __weak IBOutlet UITextField *serialNumberField;
    
    __weak IBOutlet UITextField *valueField;
    __weak IBOutlet UILabel *dateLabel;
    __weak IBOutlet UIImageView *imageView;
    __weak IBOutlet UIButton *assetTypeButton;
    
    UIPopoverController *imagePickerPopover;
}
- (IBAction)showAssetTypePicker:(id)sender;
@property (nonatomic, strong) BNRItem *item;
- (IBAction)takePicture:(id)sender;
- (IBAction)backgroundTapped:(id)sender;
- (IBAction)clearImage:(id)sender;
-(id) initForNewItem: (BOOL)isNew;
@property (nonatomic, copy) void (^dismissBlock)(void);

@end
