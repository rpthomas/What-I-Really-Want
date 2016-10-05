//
//  CategoryPickerViewController.m
//  What I Really Want
//
//  Created by Roland Thomas on 6/11/15.
//  Copyright (c) 2015 Jedisware, LLC. All rights reserved.
//

#import "CategoryPickerViewController.h"
#import "Device.h"
#import "Categories.h"
#import "CategoryController.h"
#import "Utilities.h"
#import "Global.h"

@interface CategoryPickerViewController ()

@end

@implementation CategoryPickerViewController

BOOL isPortrait;
NSLayoutConstraint *constraint1;

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self loadInitialView];
    [self LoadPicker];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)loadInitialView
{

    
    self.CategoryPicker.layer.cornerRadius = 10;
    self.CategoryPicker.layer.borderWidth = 2;
    self.CategoryPicker.layer.borderColor = [UIColor blackColor].CGColor;
    
    self.buttonSelect.layer.cornerRadius = 10;
    self.buttonSelect.layer.borderWidth = 2;
    self.buttonSelect.layer.borderColor = [UIColor whiteColor].CGColor;
    
    self.btnCancel.layer.cornerRadius = 10;
    self.btnCancel.layer.borderWidth = 2;
    self.btnCancel.layer.borderColor = [UIColor whiteColor].CGColor;
    
    }


-(void)LoadPicker
{
    CategoryController *categoryControl = [[CategoryController alloc]init];
    _recDict = [categoryControl getCategories];
    _sortedArray = nil;
    
    Utilities *util = [[Utilities alloc]init];
    _sortedArray = [(NSArray*)[util convertDict_To_Array:_recDict sortArray:true descriptor:@"categoryName"] mutableCopy];
}





#pragma mark - PickerView Delegate Methods

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)picker
{
    return 1; // For one column
}

-(NSInteger)pickerView:(UIPickerView *)picker numberOfRowsInComponent:(NSInteger)component
{
    return [_sortedArray count]; // Numbers of rows
}

-(NSString *)pickerView:(UIPickerView *)picker titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    
    Categories *thisCategory = [_sortedArray objectAtIndex:row];
    
    return thisCategory.categoryName;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    
    UILabel *label = [[UILabel alloc] init];
    label.backgroundColor = [UIColor whiteColor];
    label.textColor = [UIColor blackColor];
    label.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:18];
    label.textAlignment = NSTextAlignmentCenter;
    
    //WithFrame:CGRectMake(0, 0, pickerView.frame.size.width, 60)];
    
    if(component == 0)
    {
        Categories *thisCategory = [_sortedArray objectAtIndex:row];
        label.text = thisCategory.categoryName;
    }
    
    return label;
}


- (IBAction)SelectClick:(id)sender {
    
    //Get the ID of the person being updated
    NSInteger row;
    row = [_CategoryPicker selectedRowInComponent:0];
    Categories *thisCategory = [_sortedArray objectAtIndex:row];
    
    Global *sharedManager = [Global sharedManager];
    [sharedManager selectedCategory:thisCategory];
    [sharedManager hasCategoryBeenSet:true];
    
    [self dismissViewControllerAnimated:YES completion:Nil];
}

- (IBAction)CancelClick:(id)sender {
    [self dismissViewControllerAnimated:YES completion:Nil];
}



@end
