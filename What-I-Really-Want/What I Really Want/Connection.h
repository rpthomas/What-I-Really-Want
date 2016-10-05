//
//  Connection.h
//  What I Really Want
//
//  Created by Roland Thomas on 6/9/15.
//  Copyright (c) 2015 Jedisware, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface Connection : NSObject
- (NSString *)getDBPath;
-(Boolean) doesTableExists:(sqlite3 *) database table:(NSString *)tableName;

@end
