//
//  BNRItemStore.h
//  Homepwner
//
//  Created by Krystle on 2/10/14.
//  Copyright (c) 2014 Krystle Kidd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class BNRItem;

@interface BNRItemStore : NSObject
{
    NSMutableArray *allItems;
    NSMutableArray *allAssetType;
    NSManagedObjectContext *context;
    NSManagedObjectModel *model;
    
}
+(BNRItemStore *) sharedStore;
-(NSArray *) allItems;
-(BNRItem *) createItem;
-(void)removeItem: (BNRItem *)p;
-(void)moveItemAtIndex:(int)from toIndex: (int)to;
-(NSString *) itemArchivePath;
-(BOOL) saveChanges;
-(void)loadAllItems;
-(NSArray *)allAssetTypes;
@end

