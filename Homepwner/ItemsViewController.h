//
//  ItemsViewController.h
//  Homepwner
//
//  Created by Krystle on 2/10/14.
//  Copyright (c) 2014 Krystle Kidd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DetailViewController.h"
#import "HomepwnerItemCell.h"

@interface ItemsViewController : UITableViewController<UIPopoverControllerDelegate>
{
    UIPopoverController *imagePopover;
}



-(IBAction)addNewItem:(id)sender;


@end
