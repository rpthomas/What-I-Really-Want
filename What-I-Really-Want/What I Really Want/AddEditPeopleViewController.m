//
//  AddEditPeopleViewController.m
//  What I Really Want
//
//  Created by Roland Thomas on 6/7/15.
//  Copyright (c) 2015 Jedisware, LLC. All rights reserved.
//

#import "AddEditPeopleViewController.h"
#import "PeopleController.h"
#import "People.h"
#import "Device.h"

@interface AddEditPeopleViewController ()

@end

@implementation AddEditPeopleViewController

BOOL isViewPortrait;
NSLayoutConstraint *constrainty1;
NSLayoutConstraint *constrainty2;

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self loadInitialView];
    
}

-(void)loadInitialView
{
    
    self.btnSave.layer.cornerRadius = 10;
    self.btnSave.layer.borderWidth = 2;
    self.btnSave.layer.borderColor = [UIColor whiteColor].CGColor;
    
    self.btnCancel.layer.cornerRadius = 10;
    self.btnCancel.layer.borderWidth = 2;
    self.btnCancel.layer.borderColor = [UIColor whiteColor].CGColor;
    
    if (_shouldUpdatePerson)
    {
        _txtFirstName.text = _personToUpdate.fName;
        _txtLastName.text = _personToUpdate.lName;
    }
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //This makes the view controller transparent
    self.modalPresentationStyle = UIModalPresentationCurrentContext;
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setOrientation
{
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    
    if ((orientation == UIInterfaceOrientationLandscapeLeft)
        ||  (orientation == UIInterfaceOrientationLandscapeRight) )
    {
        //Landscape
        isViewPortrait = false;
    }
    else
    {
        //Portrait
        isViewPortrait = true;
    }
    
}



#pragma mark - Button Clicks
- (IBAction)SaveClick:(id)sender {
    if ([self isValid])
    {
        People *thisPerson = [[People alloc]init];
        PeopleController *control = [[PeopleController alloc]init];
        
        thisPerson.fName = _txtFirstName.text;
        thisPerson.lName = _txtLastName.text;
        thisPerson.people_id = _personToUpdate.people_id;
        
        if ([control InsertUpdatePerson:thisPerson shouldUpdate:_shouldUpdatePerson])
            [self dismissViewControllerAnimated:YES completion:Nil];
    }
}
- (IBAction)CancelClick:(id)sender {
    [self dismissViewControllerAnimated:YES completion:Nil];
}

#pragma mark - Validation
-(Boolean)isValid
{
    Boolean result = false;
    if (_txtFirstName.text.length > 1)
    {
        result = true;
    }
    if (_txtLastName.text.length == 0)
    {
        _txtLastName.text = @" ";
    }
    
    return result;
}
@end
