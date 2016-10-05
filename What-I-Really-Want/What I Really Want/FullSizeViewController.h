//
//  FullSizeViewController.h
//  What I Really Want
//
//  Created by Roland Thomas on 6/18/15.
//  Copyright (c) 2015 Jedisware, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FullSizeViewController : UIViewController <UIGestureRecognizerDelegate>
@property (strong, nonatomic) IBOutlet UIImageView *fullSizeImageView;
@property (strong, nonatomic) IBOutlet UIImage *chosenImage;
@end
