//
//  ItemsViewController.m
//  Homepwner
//
//  Created by Krystle on 2/10/14.
//  Copyright (c) 2014 Krystle Kidd. All rights reserved.
//

#import "ItemsViewController.h"
#import "BNRItemStore.h"
#import "BNRItem.h"
#import "BNRImageStore.h"
#import "ImageViewController.h"

@implementation ItemsViewController

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DetailViewController *detailViewController = [[DetailViewController alloc]initForNewItem:NO];
    
    NSArray *items = [[BNRItemStore sharedStore] allItems];
    BNRItem *selectedItem = [items objectAtIndex:[indexPath row]];
    
    //Give detail view controller a pointer to the item object in row
    [detailViewController setItem:selectedItem];
    
    //Push it onto the top of the navigation controller's stack
    [[self navigationController] pushViewController:detailViewController animated:YES];
}


-(id)init
{
    //initalize and create 5 items
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self)
    {
        UINavigationItem *n =[self navigationItem];
        [n setTitle:NSLocalizedString(@"Homepwner", @"Name of the application")];
        
        //Create a new bar button item that will send addNewItem to itemsVieController
        UIBarButtonItem *bbi = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addNewItem:)];
        
        //Set this bar button item as the right item in the navigation item
        [[self navigationItem] setRightBarButtonItem:bbi];
        
        [[self navigationItem] setLeftBarButtonItem:[self editButtonItem]];
        
        for(int i =0; i <5; i++){
            [[BNRItemStore sharedStore] createItem];
        }
    }
    return self;

}
-(id) initWithStyle:(UITableViewStyle)style
{
    return [self init];
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[BNRItemStore sharedStore] allItems] count];
}


-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    
    //Set the text on the cell with the description of the item
    BNRItem *p = [[[BNRItemStore sharedStore] allItems] objectAtIndex:[indexPath row]];
    
    //Get the new or recycled cell
    HomepwnerItemCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HomepwnerItemCell"];
    
    [cell setController:self];
    [cell setTableView:tableView];
    
    //Configure the cell with the BNRItem
    [[cell nameLabel] setText:[p  itemName]];
    [[cell serialNumberLabel]setText:[p serialNumber]];
   
    
    NSString *currencySymbol = [[NSLocale currentLocale]objectForKey:NSLocaleCurrencySymbol];
    [[cell valueLabel] setText:[NSString stringWithFormat:@"%@%d", currencySymbol, [p valueInDollars]]];
    


    [[cell thumbnailView] setImage:[p thumbnail]];
    return cell;

}



-(IBAction)addNewItem:(id)sender {
    BNRItem *newItem = [[BNRItemStore sharedStore]createItem];
    DetailViewController *detailViewController = [[DetailViewController alloc]initForNewItem:YES];
    
    [detailViewController setItem:newItem];
    [detailViewController setDismissBlock:^{ [[self tableView]reloadData];}];
    
    UINavigationController *navController = [[UINavigationController alloc]initWithRootViewController:detailViewController];
    [navController setModalPresentationStyle:UIModalPresentationFormSheet];
    [navController setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
    [self presentViewController:navController animated:YES completion:nil];
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    //If the table view is asking to commit a delete command....
    if (editingStyle == UITableViewCellEditingStyleDelete){
        BNRItemStore *ps = [BNRItemStore sharedStore];
        NSArray *items = [ps allItems];
        BNRItem *p = [items objectAtIndex:[indexPath row]];
        [ps removeItem:p];
        
        //We also remove that row from the table view with an animation
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
    
}
-(void) tableView:(UITableView *) tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    [[BNRItemStore sharedStore] moveItemAtIndex:[sourceIndexPath row] toIndex:[destinationIndexPath row]];
}
-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[self tableView] reloadData];
}
-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)io{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad){
        return YES;
    }else {
        return (io= UIInterfaceOrientationPortrait);
    }
}
-(void)viewDidLoad{
    [super viewDidLoad];
    
    //Load the NIB file
    UINib *nib = [UINib nibWithNibName:@ "HomepwnerItemCell" bundle:nil];
    
    //Register this Nib which contains the cell
    [[self tableView] registerNib:nib forCellReuseIdentifier:@ "HomepwnerItemCell"];
}

-(void)showImage:(id)sender atIndexPath: (NSIndexPath *)ip{
    NSLog(@"Going to show the image for %@", ip);
    
    if ([[UIDevice currentDevice]userInterfaceIdiom] == UIUserInterfaceIdiomPad){
        //Get the item for the index path
        BNRItem *i = [[[BNRItemStore sharedStore]allItems]objectAtIndex:[ip row]];
        
        NSString *imageKey = [i imageKey];
        
        //If there is no image we don't need to display anything
        UIImage *img = [[BNRImageStore sharedStore]imageForKey:imageKey];
        if (!img)
            return;
        //Make a rectangle that the fram of the button relative to our table view
        CGRect rect = [[self view] convertRect:[sender bounds] fromView:sender];
        //Create a new ImageViewController and set its image
        ImageViewController *ivc = [[ImageViewController alloc]init];
        [ivc setImage:img];
        
        //Present a 600x600 popover from the rect
        imagePopover = [[UIPopoverController alloc]initWithContentViewController:ivc];
        [imagePopover setDelegate:self];
        [imagePopover setPopoverContentSize:CGSizeMake(600, 600)];
        [imagePopover presentPopoverFromRect:rect inView:[self view] permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    }
}
-(void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController{
    [imagePopover dismissPopoverAnimated:YES];
    imagePopover = nil;
}
@end
