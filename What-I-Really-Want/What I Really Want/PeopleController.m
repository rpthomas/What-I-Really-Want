//
//  PeopleController.m
//  What I Really Want
//
//  Created by Roland Thomas on 6/7/15.
//  Copyright (c) 2015 Jedisware, LLC. All rights reserved.
//

#import "PeopleController.h"
#import "Utilities.h"
#import "Connection.h"

@implementation PeopleController

People *newPerson;



- (NSMutableDictionary *) getPeople
{
    sqlite3 *database;
    sqlite3_stmt *statement;
    
    Connection *globalConnection = [[Connection alloc]init];
    
    NSString *dbPath = [globalConnection getDBPath];
    const char *path = [dbPath UTF8String];

    
    if (sqlite3_open(path, &database) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat: @"SELECT people_id, fName, lName FROM PEOPLE"];
        
        const char *query_stmt = [querySQL UTF8String];
        
        if (sqlite3_prepare_v2(database, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                if(!_recDict)
                    _recDict = [[NSMutableDictionary dictionary] init];
                
                
                
                newPerson = [[People alloc] init];
                
                char *temp = (char *)sqlite3_column_text(statement, 0);
                if (temp!=nil)
                {
                    if (!newPerson.people_id)
                    {
                        newPerson.people_id = [[NSString alloc] init];
                        newPerson.people_id = [NSString stringWithUTF8String:temp];
                    }
                }
                else
                {
                    newPerson.people_id = [[NSString alloc] init];
                    newPerson.people_id = @"";
                }
                
                temp = (char *)sqlite3_column_text(statement, 1);
                if (temp!=nil)
                {
                    if (!newPerson.fName)
                    {
                        newPerson.fName = [[NSString alloc] init];
                        newPerson.fName = [NSString stringWithUTF8String:temp];
                    }
                }
                else
                {
                    newPerson.fName = [[NSString alloc] init];
                    newPerson.fName = @"";
                }
                
                
                temp = (char *)sqlite3_column_text(statement, 2);
                if (temp!=nil)
                {
                    if (!newPerson.lName)
                    {
                        newPerson.lName = [[NSString alloc] init];
                        newPerson.lName = [NSString stringWithUTF8String:temp];
                    }
                }
                else
                {
                    newPerson.lName = [[NSString alloc] init];
                    newPerson.lName = @"";
                }
                
                
                //Add the Item to the dictionary
                [_recDict setObject:newPerson forKey: newPerson.people_id];
                
                
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(database);
    }
    
    
    return _recDict;
    
}


- (Boolean)InsertUpdatePerson:(People *)personData shouldUpdate:(Boolean)shouldUpdate
{
    return [self InsertUpdateMember:personData shouldUpdate:shouldUpdate];
}


- (Boolean)InsertUpdateMember:(People *)personData shouldUpdate:(Boolean)shouldUpdate
{
    sqlite3 *database;
    sqlite3_stmt *statement;
    Boolean result = false;
    int64_t id = 0;
    
    Connection *globalConnection = [[Connection alloc]init];
    
    NSString *dbPath = [globalConnection getDBPath];
    const char *path = [dbPath UTF8String];

    
    //NSLog(@"PersonID: %@", personData.people_id);
    //NSLog(@"First Name: %@", personData.fName );
    //NSLog(@"Last Name: %@", personData.lName);
    
    @try {
        if (shouldUpdate)
        {
            if (sqlite3_open(path, &database) == SQLITE_OK)
            {
                const char *sql = "UPDATE PEOPLE SET fName = ?, lName = ? Where people_id = ?";
                if(sqlite3_prepare_v2(database, sql, -1, &statement, NULL)==SQLITE_OK)
                {
                    sqlite3_bind_text(statement, 3, [personData.people_id UTF8String], -1, SQLITE_TRANSIENT);
                    sqlite3_bind_text(statement, 1, [personData.fName UTF8String], -1, SQLITE_TRANSIENT);
                    sqlite3_bind_text(statement, 2, [personData.lName UTF8String], -1, SQLITE_TRANSIENT);
                }
            }
            char* errmsg;
            sqlite3_exec(database, "COMMIT", NULL, NULL, &errmsg);
            
            if (sqlite3_step(statement) == SQLITE_DONE)
            {
                //SQLite provides a method to get the last primary key inserted by using sqlite3_last_insert_rowid
                result = true;
            } else {
                //  NSLog(@"Failed to UPDATE data");
                result = false;
            }
            sqlite3_finalize(statement);
        }
        else
        {
            if (sqlite3_open(path, &database) == SQLITE_OK)
            {
                Utilities *util = [[Utilities alloc]init];
                NSString *uid = [util newGuid];
                
                NSString *insertSQL = [NSString stringWithFormat:
                                       @"INSERT INTO PEOPLE (people_id, fName, lName) VALUES (\"%@\", \"%@\", \"%@\")",
                                       uid, personData.fName, personData.lName];
                
                
                const char *insert_stmt = [insertSQL UTF8String];
                
                sqlite3_prepare_v2(database, insert_stmt,
                                   -1, &statement, NULL);
                if (sqlite3_step(statement) == SQLITE_DONE)
                {
                    //SQLite provides a method to get the last primary key inserted by using sqlite3_last_insert_rowid
                    id = sqlite3_last_insert_rowid(database);
                    result = true;
                } else {
                    //NSLog(@"Failed to insert data");
                    result = false;
                    
                }
                sqlite3_finalize(statement);
                
            }
            sqlite3_close(database);
        }
    }
    @catch (NSException *exception) {
        return false;
    }
    return result;
}


- (Boolean)DeleteThisPerson:(People *)personData
{
    return [self DeletePerson:personData];
}

- (Boolean)DeletePerson:(People *)personData
{
    sqlite3 *database;
    sqlite3_stmt *deleteStmt;
    Boolean result = false;
    
    
    Connection *globalConnection = [[Connection alloc]init];
    
    NSString *dbPath = [globalConnection getDBPath];
    const char *path = [dbPath UTF8String];
    
    
    @try {
        
        if (sqlite3_open(path, &database) == SQLITE_OK)
        {
            const char *sql = "DELETE FROM PEOPLE Where people_id = ?";
            
            if(sqlite3_prepare_v2(database, sql, -1, &deleteStmt, NULL)==SQLITE_OK)
            {
                
                sqlite3_bind_text(deleteStmt, 1, [personData.people_id UTF8String], -1, SQLITE_TRANSIENT);
                
            }
        }
        char* errmsg;
        sqlite3_exec(database, "COMMIT", NULL, NULL, &errmsg);
        
        if (sqlite3_step(deleteStmt) == SQLITE_DONE)
        {
            //SQLite provides a method to get the last primary key inserted by using sqlite3_last_insert_rowid
            sqlite3_finalize(deleteStmt);
            result = [self DeleteThisPersonsGifts:personData];
            
            [self DeleteUnAssociatedImages];

        } else {
            //  NSLog(@"Failed to UPDATE data");
            result = false;
        }
        
        
        
        sqlite3_close(database);
        
    }
    @catch (NSException *exception) {
        return false;
    }
    return result;
}

- (Boolean)DeleteThisPersonsGifts:(People *)personData
{
    sqlite3 *database;
    sqlite3_stmt *deleteStmt;
    Boolean result = false;
    
    
    Connection *globalConnection = [[Connection alloc]init];
    
    NSString *dbPath = [globalConnection getDBPath];
    const char *path = [dbPath UTF8String];
    
    
    @try {
        
        if (sqlite3_open(path, &database) == SQLITE_OK)
        {
            const char *sql = "DELETE FROM GIFTS Where people_id = ?";
            
            if(sqlite3_prepare_v2(database, sql, -1, &deleteStmt, NULL)==SQLITE_OK)
            {
                
                sqlite3_bind_text(deleteStmt, 1, [personData.people_id UTF8String], -1, SQLITE_TRANSIENT);
                
            }
        }
        char* errmsg;
        sqlite3_exec(database, "COMMIT", NULL, NULL, &errmsg);
        
        if (sqlite3_step(deleteStmt) == SQLITE_DONE)
        {
            //SQLite provides a method to get the last primary key inserted by using sqlite3_last_insert_rowid
            result = true;
        } else {
            //  NSLog(@"Failed to UPDATE data");
            result = false;
        }
        
        sqlite3_finalize(deleteStmt);
        sqlite3_close(database);
        
    }
    @catch (NSException *exception) {
        return false;
    }
    return result;
}

- (void)DeleteUnAssociatedImages
{
    sqlite3 *database;
    Boolean result = false;
    
    
    Connection *globalConnection = [[Connection alloc]init];
    
    NSString *dbPath = [globalConnection getDBPath];
    const char *path = [dbPath UTF8String];
    
    
    @try {
        
        if (sqlite3_open(path, &database) == SQLITE_OK)
        {
            const char *sql = "DELETE FROM PHOTOS Where gift_id NOT IN (SELECT gift_id FROM GIFTS)";
            
            char* errmsg;
            if (sqlite3_exec(database, sql, NULL, NULL, &errmsg) != SQLITE_OK)
            {
                //  NSLog(@"Failed to Delete data");
                result = false;
            }
            else
            {
                result = true;
            }
        }
        
        sqlite3_close(database);
        
    }
    @catch (NSException *exception) {
        //return false;
    }
    //return result;
}


@end
