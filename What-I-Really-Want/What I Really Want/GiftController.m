//
//  GiftController.m
//  What I Really Want
//
//  Created by Roland Thomas on 6/9/15.
//  Copyright (c) 2015 Jedisware, LLC. All rights reserved.
//

#import "GiftController.h"
#import "Connection.h"
#import "Gifts.h"
#import "Utilities.h"

@implementation GiftController

Gifts *newGift;

- (NSMutableDictionary *)loadGiftsByPeopleID:(NSString *)people_id
{
    Connection *globalConnection = [[Connection alloc]init];
    
    NSString *dbPath = [globalConnection getDBPath];
    const char *path = [dbPath UTF8String];
    
    [self loadGiftsByPeopleID:path people_id:people_id];
    return _recDict;
}



- (void) loadGiftsByPeopleID:(const char *)path people_id:(NSString *)people_id
{
    
    sqlite3 *database;
    sqlite3_stmt *statement;
    
    if (sqlite3_open(path, &database) == SQLITE_OK)
    {
        
        NSString *querySQL = [NSString stringWithFormat: @"SELECT g.gift_id, g.category_id, "
                              "g.people_id, g.itemType, g.itemBrand, g.size, g.waist, g.details, c.categoryName FROM GIFTS g LEFT JOIN CATEGORIES c ON g.category_id = c.category_id "
                              "WHERE people_id =\"%@\"", people_id];
        
        /*
        NSString *querySQL = [NSString stringWithFormat: @"SELECT gift_id, category_id, "
                              "people_id, itemType, itemBrand, size, waist, details FROM GIFTS"];
        */
        const char *query_stmt = [querySQL UTF8String];
        
        if (sqlite3_prepare_v2(database, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                if(!_recDict)
                    _recDict = [[NSMutableDictionary dictionary] init];
                
                newGift = [[Gifts alloc] init];
                
                char *temp = (char *)sqlite3_column_text(statement, 0);
                
                
                if (temp!=nil)
                {
                    if (!newGift.gift_id)
                    {
                        newGift.gift_id = [[NSString alloc] init];
                        newGift.gift_id = [NSString stringWithUTF8String:temp];
                    }
                }
                
                temp = (char *)sqlite3_column_text(statement, 1);
                
                if (temp!=nil)
                {
                    if (!newGift.category_id)
                    {
                        newGift.category_id = [[NSString alloc] init];
                        newGift.category_id = [NSString stringWithUTF8String:temp];
                        //NSLog(@"Category ID: %@", newGift.category_id);
                    }
                }
                else
                {
                    newGift.category_id = [[NSString alloc] init];
                    newGift.category_id = 0;
                }
                
                char *strTemp = (char *)sqlite3_column_text(statement, 2);
                
                if (strTemp!=nil)
                {
                    if (!newGift.people_id)
                    {
                        newGift.people_id = [[NSString alloc] init];
                        newGift.people_id = [NSString stringWithUTF8String:strTemp];
                        //NSLog(@"Diners Name: %@", newGift.dinerName);
                    }
                }
                else
                {
                    newGift.people_id = [[NSString alloc] init];
                    newGift.people_id = @"";
                }
                
                strTemp = (char *)sqlite3_column_text(statement, 3);
                
                
                if (strTemp!=nil)
                {
                    if (!newGift.itemType)
                    {
                        newGift.itemType = [[NSString alloc] init];
                        newGift.itemType = [NSString stringWithUTF8String:strTemp];
                        //NSLog(@"Party Number Description: %@", newGift.dinerName);
                    }
                }
                else
                {
                    newGift.itemType = [[NSString alloc] init];
                    newGift.itemType = @"";
                }
                
                strTemp = (char *)sqlite3_column_text(statement, 4);
                
                
                if (strTemp!=nil)
                {
                    if (!newGift.itemBrand)
                    {
                        newGift.itemBrand = [[NSString alloc] init];
                        newGift.itemBrand = [NSString stringWithUTF8String:strTemp];
                        //NSLog(@"Time Seated: %@", newGift.timeSeated);
                    }
                }
                else
                {
                    newGift.itemBrand = [[NSString alloc] init];
                    newGift.itemBrand = @"";
                }
                
                strTemp = (char *)sqlite3_column_text(statement, 5);
                
                
                if (strTemp!=nil)
                {
                    if (!newGift.size)
                    {
                        newGift.size = [[NSString alloc] init];
                        newGift.size = [NSString stringWithUTF8String:strTemp];
                        //NSLog(@"Time Seated: %@", newGift.timeSeated);
                    }
                }
                else
                {
                    newGift.size = [[NSString alloc] init];
                    newGift.size = @"";
                }
                
                strTemp = (char *)sqlite3_column_text(statement, 6);
                
                
                if (strTemp!=nil)
                {
                    if (!newGift.waist)
                    {
                        newGift.waist = [[NSString alloc] init];
                        newGift.waist = [NSString stringWithUTF8String:strTemp];
                        //NSLog(@"Time Left: %@", newGift.timeLeft);
                    }
                }
                else
                {
                    newGift.waist = [[NSString alloc] init];
                    newGift.waist = @"";
                }
                
                strTemp = (char *)sqlite3_column_text(statement, 7);
                
                
                if (strTemp!=nil)
                {
                    if (!newGift.details)
                    {
                        newGift.details = [[NSString alloc] init];
                        newGift.details = [NSString stringWithUTF8String:strTemp];
                        //NSLog(@"Time Left: %@", newGift.tableNo);
                    }
                }
                else
                {
                    newGift.details = [[NSString alloc] init];
                    newGift.details = @"";
                }
                
                strTemp = (char *)sqlite3_column_text(statement, 8);
                
                
                if (strTemp!=nil)
                {
                    if (!newGift.categoryName)
                    {
                        newGift.categoryName = [[NSString alloc] init];
                        newGift.categoryName = [NSString stringWithUTF8String:strTemp];
                        //NSLog(@"Time Left: %@", newGift.tableNo);
                    }
                }
                else
                {
                    newGift.categoryName = [[NSString alloc] init];
                    newGift.categoryName = @"";
                }

                
                //NSLog(@"key: %@", newGift.gift_id);
                
                
                //Check if the Key already exists in the dictionary
                if ([_recDict objectForKey:newGift.categoryName])
                {
                    //The Key exists
                    //First, retrieve the existing item
                    NSMutableArray *modifyArray = [_recDict objectForKey:newGift.categoryName];
                    
                    //Add the new item to the array
                    [modifyArray addObject:newGift];
                    
                    //Remove the existing item from the diction
                    [_recDict removeObjectForKey:newGift.categoryName];
                    
                    newGift = [self loadImagesByGiftID:path gift:newGift];
                    
                    //Re-add the array to the dictionary
                    [_recDict setObject:modifyArray forKey:newGift.categoryName];
                }
                else
                {
                    //Key does not exist
                    //Add the new item to the array
                    
                    NSMutableArray *modifyArray = [[NSMutableArray alloc]init];
                    [modifyArray addObject:newGift];
                    
                    newGift = [self loadImagesByGiftID:path gift:newGift];
                    
                    //Add the array to the dictionary
                    [_recDict setObject:modifyArray forKey: newGift.categoryName];

                }

            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(database);
    }
}



- (Gifts *) loadImagesByGiftID:(const char *)path gift:(Gifts *)gift
{
    
    sqlite3 *database;
    sqlite3_stmt *statement;
    
    if (sqlite3_open(path, &database) == SQLITE_OK)
    {
        
        NSString *querySQL = [NSString stringWithFormat: @"SELECT photo_id, photoName FROM PHOTOS WHERE gift_id =\"%@\"", gift.gift_id];

        const char *query_stmt = [querySQL UTF8String];
        
        if (sqlite3_prepare_v2(database, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                if(!gift.imageDict)
                    gift.imageDict = [[NSMutableDictionary dictionary] init];
                
                NSString *photo_id;
                NSString *photoName;
                
                char *temp = (char *)sqlite3_column_text(statement, 0);
                
                
                if (temp!=nil)
                {
                    photo_id = [NSString stringWithUTF8String:temp];
                    //NSLog(@"Photo ID: %@", photo_id);
                }
                else
                {
                    photo_id = @"";
                }
                
                temp = (char *)sqlite3_column_text(statement, 1);
                
                if (temp!=nil)
                {
                    photoName = [NSString stringWithUTF8String:temp];
                    //NSLog(@"Photo Name: %@", photoName);
                }
                else
                {
                    photoName = @"";
                }

                //Add the image to the dictionary
                [gift.imageDict setObject:photoName forKey: photo_id];
                    
                
                
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(database);
    }
    
    return gift;
}



- (Boolean)InsertUpdateGift:(Gifts *)giftData shouldUpdate:(Boolean)shouldUpdate
{
    return [self InsertUpdateGifts:giftData shouldUpdate:shouldUpdate];
}


- (Boolean)InsertUpdateGifts:(Gifts *)giftData shouldUpdate:(Boolean)shouldUpdate
{
    sqlite3 *database;
    sqlite3_stmt *statement;
    Boolean result = false;

    
    Connection *globalConnection = [[Connection alloc]init];
    
    NSString *dbPath = [globalConnection getDBPath];
    const char *path = [dbPath UTF8String];

    
    @try {
        if (shouldUpdate)
        {
            if (sqlite3_open(path, &database) == SQLITE_OK)
            {
                const char *sql = "UPDATE GIFTS SET category_id = ?, itemType = ?, itemBrand = ?, size = ?, waist = ?, details = ? Where gift_id = ?";
                
                if(sqlite3_prepare_v2(database, sql, -1, &statement, NULL)==SQLITE_OK)
                {
                    sqlite3_bind_text(statement, 7, [giftData.gift_id UTF8String], -1, SQLITE_TRANSIENT);
                    sqlite3_bind_text(statement, 1, [giftData.category_id UTF8String], -1, SQLITE_TRANSIENT);
                    sqlite3_bind_text(statement, 2, [giftData.itemType UTF8String], -1, SQLITE_TRANSIENT);
                    sqlite3_bind_text(statement, 3, [giftData.itemBrand UTF8String], -1, SQLITE_TRANSIENT);
                    sqlite3_bind_text(statement, 4, [giftData.size UTF8String], -1, SQLITE_TRANSIENT);
                    sqlite3_bind_text(statement, 5, [giftData.waist UTF8String], -1, SQLITE_TRANSIENT);
                    sqlite3_bind_text(statement, 6, [giftData.details UTF8String], -1, SQLITE_TRANSIENT);

                }
            }
            char* errmsg;
            sqlite3_exec(database, "COMMIT", NULL, NULL, &errmsg);
            
            if (sqlite3_step(statement) == SQLITE_DONE)
            {
                //SQLite provides a method to get the last primary key inserted by using sqlite3_last_insert_rowid
                if ([self insertGiftImage:giftData shouldUpdate:shouldUpdate]) {
                    result = true;
                }
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
                
                
                //NSLog(@"GiftID: %@", uid);
                //NSLog(@"CategoryID: %@", giftData.category_id );
                //NSLog(@"PeopleID: %@", giftData.people_id);
                
                //NSLog(@"Item Type: %@", giftData.itemType);
                //NSLog(@"Item Brand: %@", giftData.itemBrand );
                //NSLog(@"Size: %@", giftData.size);
                
                //NSLog(@"Waist: %@", giftData.waist);
                //NSLog(@"Details: %@", giftData.details );

                
                NSString *insertSQL = [NSString stringWithFormat:
                                       @"INSERT INTO GIFTS (gift_id, category_id, people_id, itemType, itemBrand, size, waist, details) VALUES (\"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\")",
                                       uid, giftData.category_id, giftData.people_id, giftData.itemType, giftData.itemBrand, giftData.size, giftData.waist, giftData.details];
                
                
                const char *insert_stmt = [insertSQL UTF8String];
                
                sqlite3_prepare_v2(database, insert_stmt,
                                   -1, &statement, NULL);
                if (sqlite3_step(statement) == SQLITE_DONE)
                {
                    //SQLite provides a method to get the last primary key inserted by using sqlite3_last_insert_rowid
                    //id = sqlite3_last_insert_rowid(database);
                    
                    
                    //INSERT THE IMAGES NOW
                    giftData.gift_id = uid;
                    
                    if ([self insertGiftImage:giftData shouldUpdate:shouldUpdate]) {
                        result = true;
                    }
                    else
                        result = false;
                    
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


- (bool) insertGiftImage:(Gifts *)giftData shouldUpdate:(Boolean)shouldUpdate
{
    sqlite3 *database;
    sqlite3_stmt *statement;
    Boolean result = false;
    
    
    Connection *globalConnection = [[Connection alloc]init];
    
    NSString *dbPath = [globalConnection getDBPath];
    const char *path = [dbPath UTF8String];
    
    Utilities *util = [[Utilities alloc]init];

    if (sqlite3_open(path, &database) == SQLITE_OK)
    {

        NSInteger imageMax = [giftData.imageNames count];
        NSInteger itemCount;
        
        
        if (sqlite3_open(path, &database) == SQLITE_OK)
        {
            
            for (itemCount = 0; itemCount < imageMax; itemCount++)
            {
                //Create a new Guid
                NSString *uid = [util newGuid];
                
                NSString *insertSQLOne = [NSString stringWithFormat:
                                          @"INSERT INTO PHOTOS (photo_id, gift_id, photoName) VALUES (\"%@\", \"%@\", \"%@\")", uid, giftData.gift_id,[giftData.imageNames objectAtIndex:itemCount]];
                
                const char *insert_stmt_one = [insertSQLOne UTF8String];
                sqlite3_prepare_v2(database, insert_stmt_one,
                                   -1, &statement, NULL);
                if (sqlite3_step(statement) == SQLITE_DONE)
                {
                    //SQLite provides a method to get the last primary key inserted by using
                    //primaryKey = (long)sqlite3_last_insert_rowid(database);
                    
                    //NSLog(@"Photo ID ID: %@", uid);
                    //NSLog(@"Gift ID: %@", giftData.gift_id);
                    //NSLog(@"Image File Name: %@", [giftData.imageNames objectAtIndex:itemCount]);
                    
                    result = true;
                    
                } else {
                    //NSLog(@"Failed to insert data");
                    result = false;
                }
                sqlite3_finalize(statement);
                
            }
            
            if (imageMax == 0) {
                result = true;
            }
        }
        
        
        
        sqlite3_close(database);
        
    }
    return result;
}








- (Boolean)DeleteGift:(Gifts *)giftData
{
    return [self DeleteGifts:giftData];
}


- (Boolean)DeleteGifts:(Gifts *)giftData
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
            const char *sql = "DELETE FROM GIFTS Where gift_id = ?";
            
            if(sqlite3_prepare_v2(database, sql, -1, &deleteStmt, NULL)==SQLITE_OK)
            {
                
                sqlite3_bind_text(deleteStmt, 1, [giftData.gift_id UTF8String], -1, SQLITE_TRANSIENT);
                
            }
        }
        char* errmsg;
        sqlite3_exec(database, "COMMIT", NULL, NULL, &errmsg);
        
        if (sqlite3_step(deleteStmt) == SQLITE_DONE)
        {
            //SQLite provides a method to get the last primary key inserted by using sqlite3_last_insert_rowid
            [self DeleteImageByGiftId:giftData];
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



- (Boolean)deleteImage:(NSString *)fileName
{
    return [self DeleteImage:fileName];
}


- (Boolean)DeleteImage:(NSString *)fileName
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
            const char *sql = "DELETE FROM PHOTOS Where photoName = ?";
            
            if(sqlite3_prepare_v2(database, sql, -1, &deleteStmt, NULL)==SQLITE_OK)
            {
                sqlite3_bind_text(deleteStmt, 1, [fileName UTF8String], -1, SQLITE_TRANSIENT);
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


- (void)DeleteImageByGiftId:(Gifts *)giftData
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
            const char *sql = "DELETE FROM PHOTOS Where gift_id = ?";
            
            if(sqlite3_prepare_v2(database, sql, -1, &deleteStmt, NULL)==SQLITE_OK)
            {
                sqlite3_bind_text(deleteStmt, 1, [giftData.gift_id UTF8String], -1, SQLITE_TRANSIENT);
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
        //return false;
    }
    //return result;
}



@end
