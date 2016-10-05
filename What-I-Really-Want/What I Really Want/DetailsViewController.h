//
//  DetailsViewController.h
//  What I Really Want
//
//  Created by Roland Thomas on 6/13/15.
//  Copyright (c) 2015 Jedisware, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Gifts.h"

@interface DetailsViewController : UIViewController
@property (strong, nonatomic) IBOutlet UITextView *txtDetailsView;
@property (nonatomic, retain) Gifts *selectedGift;
@property (strong, nonatomic) IBOutlet UIButton *btnClose;
- (IBAction)CloseClick:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *btnViewImages;

@end
