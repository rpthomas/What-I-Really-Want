//
//  PeopleController.h
//  What I Really Want
//
//  Created by Roland Thomas on 6/7/15.
//  Copyright (c) 2015 Jedisware, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "People.h"

@interface PeopleController : NSObject
@property (nonatomic, retain) NSMutableDictionary *recDict;
- (NSMutableDictionary *) getPeople;
- (Boolean)InsertUpdatePerson:(People *)personData shouldUpdate:(Boolean)shouldUpdate;
- (Boolean)DeleteThisPerson:(People *)personData;
@end
