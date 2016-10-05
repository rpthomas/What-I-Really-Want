//
//  Gifts.h
//  What I Really Want
//
//  Created by Roland Thomas on 6/9/15.
//  Copyright (c) 2015 Jedisware, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Gifts : NSObject

@property (nonatomic, retain) NSString *gift_id;
@property (nonatomic, retain) NSString *category_id;
@property (nonatomic, retain) NSString *people_id;
@property (nonatomic, retain) NSString *itemType;
@property (nonatomic, retain) NSString *itemBrand;
@property (nonatomic, retain) NSString *size;
@property (nonatomic, retain) NSString *waist;
@property (nonatomic, retain) NSString *details;
@property (nonatomic, retain) NSString *categoryName;
@property (nonatomic, retain) NSArray *imageNames;
@property (nonatomic, retain) NSMutableDictionary *imageDict;

@end
