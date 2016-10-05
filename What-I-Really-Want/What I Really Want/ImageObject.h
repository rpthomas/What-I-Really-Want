//
//  ImageObject.h
//  What I Really Want
//
//  Created by Roland Thomas on 6/16/15.
//  Copyright (c) 2015 Jedisware, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ImageObject : NSObject
-(void)UIImageWriteToFile:(UIImage *)image fileName:(NSString *)fileName;
-(UIImage *)UIImageReadFromFile:(NSString *)fileName;
- (void)saveImage: (UIImage*)image fileName:(NSString *)fileName;
- (UIImage*)loadImage:(NSString *)fileName;
- (void)removeImage:(NSString*)fileName;
@end
