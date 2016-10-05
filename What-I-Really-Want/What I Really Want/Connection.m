//
//  Connection.m
//  What I Really Want
//
//  Created by Roland Thomas on 6/9/15.
//  Copyright (c) 2015 Jedisware, LLC. All rights reserved.
//

#import "Connection.h"

@implementation Connection
- (NSString *)dataFilePath
{
    
    NSString *docsDir;
    NSArray *dirPaths;
    
    // Get the documents directory
    dirPaths = NSSearchPathForDirectoriesInDomains(
                                                   NSDocumentDirectory, NSUserDomainMask, YES);
    
    docsDir = dirPaths[0];
    
    // Build the path to the database file
    NSString *_databasePath = [[NSString alloc]
                               initWithString: [docsDir stringByAppendingPathComponent:
                                                @"WhatIWant.db"]];
    return _databasePath;
}

- (NSString *)getDBPath
{
    NSString *dbPath = [self dataFilePath];
    return dbPath;
}

- (sqlite3 *)openDatabase:(sqlite3 *) database dbPath:(const char *)path
{
    if (sqlite3_open(path, &database) == SQLITE_OK)
    {
        return database;
    }
    
    
    return nil;
}


-(Boolean) doesTableExists:(sqlite3 *) database table:(NSString *)tableName
{
    sqlite3_stmt *statementChk;
    
    NSMutableString *query = [[NSMutableString alloc]init];
    [query appendString:@"SELECT name FROM sqlite_master WHERE type='table' AND name='"];
    [query appendString:tableName];
    [query appendString:@"'"];
    
    sqlite3_prepare_v2(database, "SELECT name FROM sqlite_master WHERE type='table' AND name='util_nums';", -1, &statementChk, nil);
    
    bool exists = FALSE;
    
    if (sqlite3_step(statementChk) == SQLITE_ROW) {
        exists = TRUE;
    }
    sqlite3_finalize(statementChk);
    
    return exists;
}

@end
