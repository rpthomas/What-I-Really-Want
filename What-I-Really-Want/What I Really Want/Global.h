//
//  Global.h
//  What I Really Want
//
//  Created by Roland Thomas on 6/9/15.
//  Copyright (c) 2015 Jedisware, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "People.h"
#import "Categories.h"
#import "Gifts.h"


@interface Global : NSObject
+ (id)sharedManager;
- (People *)activePerson;
- (void)activePerson:(People *)floatingPerson;
- (Categories *)selectedCategory;
- (void)selectedCategory:(Categories *)selectedCategory;
- (bool)hasCategoryBeenSet;
- (void)hasCategoryBeenSet:(bool)hasCategoryBeenSet;
- (Boolean)reloadFlag;
- (void)reloadFlag:(Boolean)reloadFlag;
- (NSMutableArray *)imageFileNames;
- (void)imageFileNames:(NSString *)imageFileNames;
- (void)clearImageArray;
- (void)gifts:(Gifts *)gifts;
- (Gifts *)gifts;
- (void)lastTabIndex:(NSInteger)lastTabIndex;
- (NSInteger)lastTabIndex;
@end
