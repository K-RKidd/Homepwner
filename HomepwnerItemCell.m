//
//  HomepwnerItemCell.m
//  Homepwner
//
//  Created by Krystle on 3/28/14.
//  Copyright (c) 2014 Krystle Kidd. All rights reserved.
//

#import "HomepwnerItemCell.h"

@implementation HomepwnerItemCell
@synthesize controller;
@synthesize tableView;

- (IBAction)showImage:(id)sender {
    
    //Get this name of this method, "showImage:"
    NSString *selector = NSStringFromSelector(_cmd);
    //Selector is now "showImage:atIndexPath:"
    selector = [selector stringByAppendingString:@"atIndexPath:"];
    
    //Prepare a selector from this string
    SEL newSelector = NSSelectorFromString(selector);
    
    NSIndexPath *indexPath = [[self tableView]indexPathForCell:self];
    
    if(indexPath) {
        if ([[self controller] respondsToSelector:newSelector]){
            [[self controller]performSelector:newSelector withObject:sender withObject:indexPath];}}
    
}
@end
