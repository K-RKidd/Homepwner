//
//  ImageViewController.m
//  Homepwner
//
//  Created by Krystle on 3/29/14.
//  Copyright (c) 2014 Krystle Kidd. All rights reserved.
//

#import "ImageViewController.h"

@interface ImageViewController ()

@end

@implementation ImageViewController
@synthesize image;

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    CGSize sz = [[self image]size];
    [scrollView setContentSize:sz];
    [imageView setFrame:CGRectMake(0, 0, sz.width, sz.height)];
    
    [imageView setImage:[self image]];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
