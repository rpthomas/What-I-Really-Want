//
//  CategoryController.m
//  What I Really Want
//
//  Created by Roland Thomas on 6/9/15.
//  Copyright (c) 2015 Jedisware, LLC. All rights reserved.
//

#import "CategoryController.h"
#import "Categories.h"

@implementation CategoryController
Categories *category;



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


- (NSMutableDictionary *) getCategories
{
    sqlite3 *database;
    sqlite3_stmt *statement;
    
    NSString *dbPath = [self getDBPath];
    const char *path = [dbPath UTF8String];
    
    
    
    if (sqlite3_open(path, &database) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat: @"SELECT category_id, categoryName FROM CATEGORIES"];
        
        const char *query_stmt = [querySQL UTF8String];
        
        if (sqlite3_prepare_v2(database, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                if(!_recDict)
                    _recDict = [[NSMutableDictionary dictionary] init];
                
                
                
                category = [[Categories alloc] init];
                
                char *temp = (char *)sqlite3_column_text(statement, 0);
                if (temp!=nil)
                {
                    if (!category.category_id)
                    {
                        category.category_id = [[NSString alloc] init];
                        category.category_id = [NSString stringWithUTF8String:temp];
                    }
                }
                else
                {
                    category.category_id = [[NSString alloc] init];
                    category.category_id = @"";
                }
                
                temp = (char *)sqlite3_column_text(statement, 1);
                if (temp!=nil)
                {
                    if (!category.categoryName)
                    {
                        category.categoryName = [[NSString alloc] init];
                        category.categoryName = [NSString stringWithUTF8String:temp];
                    }
                }
                else
                {
                    category.categoryName = [[NSString alloc] init];
                    category.categoryName = @"";
                }
                

                //Add the Item to the dictionary
                [_recDict setObject:category forKey: category.category_id];
                
                
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(database);
    }
    
    
    return _recDict;
    
}

@end
