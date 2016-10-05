//
//  Global.m
//  What I Really Want
//
//  Created by Roland Thomas on 6/9/15.
//  Copyright (c) 2015 Jedisware, LLC. All rights reserved.
//

#import "Global.h"
#import "People.h"
#import "Categories.h"
#import "Gifts.h"

@implementation Global

static People *_floatingPerson;
static Categories *_selectedCategory;
static bool _hasCategoryBeenSet;
static Boolean _reloadFlag;
static NSMutableArray *_imageFileNames;
static Gifts *_gifts;
static NSInteger _lastTabIndex;

#pragma mark Singleton Methods

+ (id)sharedManager
{
    static Global *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
    });
    return sharedManager;
}


- (id)init {
    if (self = [super init])
    {
        _imageFileNames = [[NSMutableArray alloc]init];
    }
    return self;
}

#pragma mark -- Properties
- (People *)activePerson
{
    return _floatingPerson;
}

- (void)activePerson:(People *)floatingPerson
{
    _floatingPerson = floatingPerson;
}

- (Categories *)selectedCategory
{
    return _selectedCategory;
}

- (void)selectedCategory:(Categories *)selectedCategory
{
    _selectedCategory = selectedCategory;
}

- (bool)hasCategoryBeenSet
{
    return _hasCategoryBeenSet;
}

- (void)hasCategoryBeenSet:(bool)hasCategoryBeenSet
{
    _hasCategoryBeenSet = hasCategoryBeenSet;
}

- (Boolean)reloadFlag
{
    return _reloadFlag;
}

- (void)reloadFlag:(Boolean)reloadFlag
{
    _reloadFlag = reloadFlag;
}

- (NSMutableArray *)imageFileNames
{
    return _imageFileNames;
}

- (void)imageFileNames:(NSString *)imageFileNames
{
    [_imageFileNames addObject:imageFileNames];
     
}

- (void)clearImageArray
{
    [_imageFileNames removeAllObjects];
    
}

- (void)gifts:(Gifts *)gifts
{
    _gifts = gifts;
    
}

- (Gifts *)gifts
{
    return _gifts;
    
}

- (void)lastTabIndex:(NSInteger)lastTabIndex
{
    _lastTabIndex = lastTabIndex;
    
}

- (NSInteger)lastTabIndex
{
    return _lastTabIndex;
    
}




@end
