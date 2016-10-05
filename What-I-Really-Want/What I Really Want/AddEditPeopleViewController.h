//
//  AddEditPeopleViewController.h
//  What I Really Want
//
//  Created by Roland Thomas on 6/7/15.
//  Copyright (c) 2015 Jedisware, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "People.h"

@interface AddEditPeopleViewController : UIViewController
@property (strong, nonatomic) IBOutlet UITextField *txtFirstName;
@property (strong, nonatomic) IBOutlet UITextField *txtLastName;
@property (strong, nonatomic) IBOutlet UIButton *btnSave;
- (IBAction)SaveClick:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *btnCancel;
- (IBAction)CancelClick:(id)sender;

@property (nonatomic, assign) Boolean shouldUpdatePerson;
@property (nonatomic, retain) People *personToUpdate;
@property (strong, nonatomic) IBOutlet UILabel *lblFirstName;
@property (strong, nonatomic) IBOutlet UIImageView *popUpBackground;

@end
