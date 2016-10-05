//
//  AddEditGiftsViewController.h
//  What I Really Want
//
//  Created by Roland Thomas on 6/10/15.
//  Copyright (c) 2015 Jedisware, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Gifts.h"

@interface AddEditGiftsViewController : UIViewController <UITextFieldDelegate, UITextViewDelegate>
@property (strong, nonatomic) IBOutlet UITextField *txtCategory;
@property (strong, nonatomic) IBOutlet UITextField *txtItemType;
@property (strong, nonatomic) IBOutlet UITextField *txtBrand;
@property (strong, nonatomic) IBOutlet UITextField *txtSize;
@property (strong, nonatomic) IBOutlet UITextField *txtWaist;
@property (strong, nonatomic) IBOutlet UITextView *txtDetails;
@property (strong, nonatomic) IBOutlet UIButton *btnSetCategory;
- (IBAction)SetCategoryClock:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *btnSave;
@property (strong, nonatomic) IBOutlet UIButton *btnCancel;
- (IBAction)SaveClick:(id)sender;
- (IBAction)CancelClick:(id)sender;

@property (nonatomic, assign) Boolean shouldUpdateGift;
@property (nonatomic, retain) Gifts *selectedGift;
@property (strong, nonatomic) IBOutlet UIButton *btnAttachPhoto;
- (IBAction)AttachPhotoClick:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *lblImageCount;

@end
