//
//  DataBase.m
//  What I Really Want
//
//  Created by Roland Thomas on 6/5/15.
//  Copyright (c) 2015 Jedisware, LLC. All rights reserved.
//

#import "DataBase.h"
#import "Utilities.h"
#import "Connection.h"

@implementation DataBase





- (void)checkForDatabase
{
    sqlite3 *database = nil;
    
    NSFileManager *filemgr = [NSFileManager defaultManager];
    
    Connection *globalConnection = [[Connection alloc]init];
    NSString *dbPath = [globalConnection getDBPath];
    
    const char *path = [dbPath UTF8String];
    
    if ([filemgr fileExistsAtPath: dbPath] == NO)
    {
        //Create the Database and tables
        
        [self createTables:path];
        [self populateDefaultData:database dbPath:path];
    }
}

- (void)createTables:(const char *)path
{
    //(sqlite3 *) database dbPath:
    sqlite3 *database;
    
    if (sqlite3_open(path, &database) == SQLITE_OK)
    {
        
        Connection *globalConnection = [[Connection alloc]init];

        if (![globalConnection doesTableExists:database table:@"PEOPLE"])
        {
            //Create People Table
            char *createPeople = "CREATE TABLE IF NOT EXISTS PEOPLE "
            "(people_id TEXT PRIMARY KEY, "
            "fName TEXT, lName TEXT);";
            
            char *errorMsg1;
            if (sqlite3_exec(database, createPeople, NULL, NULL, &errorMsg1) != SQLITE_OK)
            {
                //sqlite3_close(database);
                
                // NSLog(@"Error creating Categories table: %s", errorMsg1);
                database = nil;
            }
        }
        
        if (![globalConnection doesTableExists:database table:@"CATEGORIES"])
        {
            //Create People Table
            char *createCategories = "CREATE TABLE IF NOT EXISTS CATEGORIES "
            "(category_id TEXT PRIMARY KEY, "
            "categoryName TEXT);";
            
            char *errorMsg1;
            if (sqlite3_exec(database, createCategories, NULL, NULL, &errorMsg1) != SQLITE_OK)
            {
                //sqlite3_close(database);
                
                // NSLog(@"Error creating Categories table: %s", errorMsg1);
                database = nil;
            }
        }
        
        
        if (![globalConnection doesTableExists:database table:@"GIFTS"])
        {
            //Create People Table
            char *createGifts = "CREATE TABLE IF NOT EXISTS GIFTS "
            "(gift_id TEXT PRIMARY KEY, "
            "category_id TEXT, people_id TEXT, itemType TEXT, itemBrand TEXT, size TEXT, waist TEXT, details TEXT);";
            
            char *errorMsg1;
            if (sqlite3_exec(database, createGifts, NULL, NULL, &errorMsg1) != SQLITE_OK)
            {
                //sqlite3_close(database);
                
                // NSLog(@"Error creating Categories table: %s", errorMsg1);
                database = nil;
            }
        }
        
        
        if (![globalConnection doesTableExists:database table:@"PHOTOS"])
        {
            //Create People Table
            char *createPhotos = "CREATE TABLE IF NOT EXISTS PHOTOS "
            "(photo_id TEXT PRIMARY KEY, "
            "gift_id TEXT, photoName TEXT);";
            
            char *errorMsg1;
            if (sqlite3_exec(database, createPhotos, NULL, NULL, &errorMsg1) != SQLITE_OK)
            {
                //sqlite3_close(database);
                
                // NSLog(@"Error creating Categories table: %s", errorMsg1);
                database = nil;
            }
        }

        

        
        sqlite3_close(database);
        
    }
    
}

- (void) populateDefaultData:(sqlite3 *) database dbPath:(const char *)path
{
    sqlite3_stmt    *statement;
    Utilities *util = [[Utilities alloc]init];
    
    NSString *uid = [util newGuid];
    NSString *fName = @"MySelf";
    NSString *lName = @"";
    
    if (sqlite3_open(path, &database) == SQLITE_OK)
    {

        NSString *insertSQLThree = [NSString stringWithFormat:
                                    @"INSERT INTO PEOPLE (people_id, fName, lName) VALUES (\"%@\", \"%@\", \"%@\")",
                                    uid, fName, lName];
        
        const char *insert_stmt_three = [insertSQLThree UTF8String];
        sqlite3_prepare_v2(database, insert_stmt_three,
                           -1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            //Confirm Here
            // NSLog(@"Good Creation");
        } else {
            // NSLog(@"Failed to insert data");
        }
        
        sqlite3_finalize(statement);
        
        //NEXT
        
        sqlite3_stmt    *statement2;
        NSMutableArray *categoryArray = [[NSMutableArray alloc] init];
        [categoryArray addObject:@"Automotive"];
        [categoryArray addObject:@"Clothing"];
        [categoryArray addObject:@"Electronics"];
        [categoryArray addObject:@"Footwear"];
        [categoryArray addObject:@"Fragrances"];
        [categoryArray addObject:@"Gift Cards"];
        [categoryArray addObject:@"Handbags / Accessories"];
        [categoryArray addObject:@"Hardware"];
        [categoryArray addObject:@"Jewelry"];
        [categoryArray addObject:@"Just For Fun"];
        [categoryArray addObject:@"Software"];
        [categoryArray addObject:@"Toys and Games"];
        
        
        NSInteger categoryMax = [categoryArray count];
        NSInteger itemCount;
        
        
        if (sqlite3_open(path, &database) == SQLITE_OK)
        {
            NSMutableString *theID = [[NSMutableString alloc]init];
            
            for (itemCount = 1; itemCount < categoryMax; itemCount++)
            {
                //Create a new Guid
                [theID setString:[util newGuid]];
                
                NSString *insertSQLOne = [NSString stringWithFormat:
                                          @"INSERT INTO CATEGORIES (category_id, categoryName) VALUES (\"%@\", \"%@\")", [NSString stringWithString: theID], [categoryArray objectAtIndex:itemCount - 1]];
                
                const char *insert_stmt_one = [insertSQLOne UTF8String];
                sqlite3_prepare_v2(database, insert_stmt_one,
                                   -1, &statement2, NULL);
                if (sqlite3_step(statement2) == SQLITE_DONE)
                {
                    //SQLite provides a method to get the last primary key inserted by using
                    //primaryKey = (long)sqlite3_last_insert_rowid(database);
                    
                    //NSLog(@"Category ID: %@", theID);
                    //NSLog(@"Category: %@", [categoryArray objectAtIndex:itemCount - 1]);
                    
                } else {
                     //NSLog(@"Failed to insert data");
                }
                sqlite3_finalize(statement2);
                
            }
        }

        
        
        sqlite3_close(database);
        
    }
    //return database;
}







@end
