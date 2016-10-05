//
//  Utilities.h
//  What I Really Want
//
//  Created by Roland Thomas on 6/5/15.
//  Copyright (c) 2015 Jedisware, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Utilities : NSObject
-(NSString *)newGuid;
@property (strong, nonatomic) NSMutableArray *utilArray;
- (NSArray *)convertDict_To_Array:(NSMutableDictionary *)recDict sortArray:(Boolean)sort descriptor:(NSString *)descriptor;
- (NSArray *)convertDict_To_ArrayGiftOverload:(NSMutableDictionary *)recDict sortArray:(Boolean)sort descriptor:(NSString *)descriptor;

-(NSString *)createFileName;
@end
