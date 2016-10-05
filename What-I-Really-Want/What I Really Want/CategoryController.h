//
//  CategoryController.h
//  What I Really Want
//
//  Created by Roland Thomas on 6/9/15.
//  Copyright (c) 2015 Jedisware, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface CategoryController : NSObject
@property (nonatomic, retain) NSMutableDictionary *recDict;
- (NSMutableDictionary *) getCategories;
@end
