//
//  FirstViewController.h
//  What I Really Want
//
//  Created by Roland Thomas on 6/5/15.
//  Copyright (c) 2015 Jedisware, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import "MobileCoreServices/MobileCoreServices.h"

@interface MainViewController : UIViewController <UIPickerViewDataSource,UIPickerViewDelegate, UITabBarControllerDelegate>
@property (nonatomic, retain) NSMutableDictionary *recDict;
@property (strong, nonatomic) IBOutlet UIPickerView *PeoplePickerView;
@property (strong, nonatomic) NSMutableArray *sortedArray;
@property (strong, nonatomic) IBOutlet UIButton *btnAddPerson;
@property (strong, nonatomic) IBOutlet UIButton *btnEditPerson;
- (IBAction)AddPersonClick:(id)sender;
- (IBAction)EditPersonClick:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *btnRemovePerson;
- (IBAction)RemovePersonClick:(id)sender;

@end

