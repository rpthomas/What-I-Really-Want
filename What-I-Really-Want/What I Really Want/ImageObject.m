//
//  ImageObject.m
//  What I Really Want
//
//  Created by Roland Thomas on 6/16/15.
//  Copyright (c) 2015 Jedisware, LLC. All rights reserved.
//

#import "ImageObject.h"

@implementation ImageObject

-(void)UIImageWriteToFile:(UIImage *)image fileName:(NSString *)fileName
{
    NSArray *dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectoryPath = dirPaths[0];
    NSString *filePath = [documentDirectoryPath stringByAppendingPathComponent:fileName];
    
    NSData *imageData = UIImagePNGRepresentation(image);
    [imageData writeToFile:filePath atomically:YES];
}

-(UIImage *)UIImageReadFromFile:(NSString *)fileName
{
    NSArray *dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectoryPath = dirPaths[0];
    NSString *filePath = [documentDirectoryPath stringByAppendingPathComponent:fileName];
    
    return [UIImage imageWithContentsOfFile:filePath];
}


- (void)saveImage: (UIImage*)image fileName:(NSString *)fileName
{
    if (image != nil)
    {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                             NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString* path = [documentsDirectory stringByAppendingPathComponent:
                          [NSString stringWithString: fileName]];
        NSData* data = UIImagePNGRepresentation(image);
        [data writeToFile:path atomically:YES];
    }
}


- (UIImage*)loadImage:(NSString *)fileName
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                         NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString* path = [documentsDirectory stringByAppendingPathComponent:
                      [NSString stringWithString: fileName]];
    
    //NSLog(@"Filename:%@", fileName);
    
    //NSLog(@"Image Path:%@", path);
    
    UIImage* image = [UIImage imageWithContentsOfFile:path];

    return image;
}


- (void)removeImage:(NSString*)fileName {
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,   YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *fullPath = [documentsDirectory stringByAppendingPathComponent:
                          [NSString stringWithFormat:@"%@.png", fileName]];
    
    NSError *error = nil;
    if(![fileManager removeItemAtPath: fullPath error:&error]) {
        //NSLog(@"Delete failed:%@", error);
    } else {
        //NSLog(@"image removed: %@", fullPath);
    }
    
    //NSString *appFolderPath = [[NSBundle mainBundle] resourcePath];
   
}

@end
