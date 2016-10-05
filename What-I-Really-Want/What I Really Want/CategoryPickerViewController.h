//
//  CategoryPickerViewController.h
//  What I Really Want
//
//  Created by Roland Thomas on 6/11/15.
//  Copyright (c) 2015 Jedisware, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CategoryPickerViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIPickerView *CategoryPicker;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *btnSelect;
@property (strong, nonatomic) IBOutlet UIButton *btnCancel;
- (IBAction)SelectClick:(id)sender;
- (IBAction)CancelClick:(id)sender;

@property (nonatomic, retain) NSMutableDictionary *recDict;
@property (strong, nonatomic) NSMutableArray *sortedArray;
@property (strong, nonatomic) IBOutlet UIButton *buttonSelect;

@end
