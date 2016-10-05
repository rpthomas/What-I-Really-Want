//
//  GiftController.h
//  What I Really Want
//
//  Created by Roland Thomas on 6/9/15.
//  Copyright (c) 2015 Jedisware, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "Gifts.h"

@interface GiftController : NSObject
@property (nonatomic, retain) NSMutableDictionary *recDict;
- (NSMutableDictionary *)loadGiftsByPeopleID:(NSString *)people_id;
- (Boolean)InsertUpdateGift:(Gifts *)giftData shouldUpdate:(Boolean)shouldUpdate;
- (Boolean)DeleteGift:(Gifts *)giftData;
- (Boolean)deleteImage:(NSString *)fileName;
@end
