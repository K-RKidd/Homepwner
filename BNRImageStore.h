//
//  BNRImageStore.h
//  Homepwner
//
//  Created by Krystle on 2/21/14.
//  Copyright (c) 2014 Krystle Kidd. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface BNRImageStore : NSObject
{
    NSMutableDictionary *dictionary;
}
+(BNRImageStore *) sharedStore;

-(void) setImage: (UIImage *)i forKey:(NSString *)s;
-(UIImage *)imageForKey: (NSString *) s;
-(void) deleteImageForKey: (NSString *) s;
-(NSString *)imagePathForKey: (NSString *)key;
@end
