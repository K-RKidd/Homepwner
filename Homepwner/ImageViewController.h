//
//  ImageViewController.h
//  Homepwner
//
//  Created by Krystle on 3/29/14.
//  Copyright (c) 2014 Krystle Kidd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageViewController : UIViewController{
    
    __weak IBOutlet UIScrollView *scrollView;
    __weak IBOutlet UIImageView *imageView;
}
@property (nonatomic, strong)UIImage *image;
@end
