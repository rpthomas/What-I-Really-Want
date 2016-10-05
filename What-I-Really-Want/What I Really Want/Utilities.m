//
//  Utilities.m
//  What I Really Want
//
//  Created by Roland Thomas on 6/5/15.
//  Copyright (c) 2015 Jedisware, LLC. All rights reserved.
//

#import "Utilities.h"
#import "People.h"
#import "Gifts.h"

@implementation Utilities

-(NSString *)newGuid
{
    CFUUIDRef newUniqueId = CFUUIDCreate(kCFAllocatorDefault);
    NSString * uuidString = (__bridge_transfer NSString*)CFUUIDCreateString(kCFAllocatorDefault, newUniqueId);
    CFRelease(newUniqueId);
    
    return uuidString;
}


- (NSArray *)convertDict_To_Array:(NSMutableDictionary *)recDict sortArray:(Boolean)sort descriptor:(NSString *)descriptor
{
    _utilArray = [[NSMutableArray alloc] init];
    
    for (NSString* key in recDict)
    {
        id value = [recDict objectForKey:key];
        People *thisRec = value;
        
        [_utilArray addObject:thisRec];
        
    }
    if (sort == true) {
        return [self sortArray:descriptor];
    }
    else
    {
        //NSArray *newArray = [NSArray arrayWithArray:_vendorArray];
        //return newArray;
        return _utilArray;
    }
}

- (NSArray *)convertDict_To_ArrayGiftOverload:(NSMutableDictionary *)recDict sortArray:(Boolean)sort descriptor:(NSString *)descriptor
{
    _utilArray = [[NSMutableArray alloc] init];
    
    for (NSString* key in recDict)
    {
        id value = [recDict objectForKey:key];
        Gifts *thisRec = value;
        
        [_utilArray addObject:thisRec];
        
    }
    if (sort == true) {
        return [self sortArray:descriptor];
    }
    else
    {
        //NSArray *newArray = [NSArray arrayWithArray:_vendorArray];
        //return newArray;
        return _utilArray;
    }
}

- (NSArray *)convertDict_To_Array:(NSMutableDictionary *)recDict
{
    _utilArray = [[NSMutableArray alloc] init];
    
    for (NSString* key in recDict)
    {
        id value = [recDict objectForKey:key];
        People *thisRec = value;
        
        [_utilArray addObject:thisRec];
        
    }
    
    //NSArray *newArray = [NSArray arrayWithArray:_vendorArray];
    //return newArray;
    return _utilArray;
    
}



-(NSArray *) sortArray:(NSString *)descriptor
{
    // declare array with SimpleObject instances
    
    
    NSSortDescriptor *sortDescriptor =
    [[NSSortDescriptor alloc] initWithKey:descriptor ascending:YES];
    NSArray *sortDescriptors =
    [NSArray arrayWithObject:sortDescriptor];
    
    // array contained all instances sorted by "descriptor variable" field
    NSArray *_sortedArray = [_utilArray sortedArrayUsingDescriptors:sortDescriptors];
    
    // [_categoryNames sortUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    return _sortedArray;
}

-(NSString *)createFileName
{
    NSDateFormatter *DateFormatter=[[NSDateFormatter alloc] init];
    [DateFormatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    NSString *temp1 = [DateFormatter stringFromDate:[NSDate date]];
    
    NSString *temp2 = [temp1 stringByReplacingOccurrencesOfString:@"-"
                                         withString:@""];
    NSString *temp3 = [temp2 stringByReplacingOccurrencesOfString:@":"
                                                       withString:@""];
    NSString *temp4 = [temp3 stringByReplacingOccurrencesOfString:@" "
                                                       withString:@""];
    
    NSMutableString *fileNameFromDate = [[NSMutableString alloc]init];
    
    [fileNameFromDate setString:temp4];
    [fileNameFromDate appendString:@".png"];
    
    //NSLog(@"Filename %@",fileNameFromDate);
    
    return [NSString stringWithString:fileNameFromDate];
}


@end
