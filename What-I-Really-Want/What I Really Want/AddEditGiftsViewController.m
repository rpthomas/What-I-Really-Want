//
//  AddEditGiftsViewController.m
//  What I Really Want
//
//  Created by Roland Thomas on 6/10/15.
//  Copyright (c) 2015 Jedisware, LLC. All rights reserved.
//

#import "AddEditGiftsViewController.h"
#import "Device.h"
#import "Global.h"
#import "Categories.h"
#import "Gifts.h"
#import "GiftController.h"
#import "People.h"

@interface AddEditGiftsViewController ()

@end

@implementation AddEditGiftsViewController

static bool smallDeviceFlag = false;
static NSMutableString *_categoryID;
static bool attachImageFlag = false;
NSMutableArray *imageFileNames;


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self loadInitialView];
    Global *sharedManager = [Global sharedManager];
    
    if ([sharedManager hasCategoryBeenSet])
    {
        [self setCategory:[sharedManager selectedCategory]];
        [sharedManager hasCategoryBeenSet:false];
    }
    
    if (attachImageFlag)
    {
        attachImageFlag = false;
        imageFileNames = [sharedManager imageFileNames];
        
        if ([imageFileNames count] == 1)
        {
            _lblImageCount.text = @"1 Image Attached";
        }
        else if ([imageFileNames count] > 1)
        {
            NSMutableString *strCount = [[NSMutableString alloc]init];
            
            [strCount setString:[NSString stringWithFormat:@"%lu", (unsigned long)[imageFileNames count]]];
            
            [strCount appendString:@" Images Attached"];
            _lblImageCount.text = [NSString stringWithString:strCount];
            
        }
    }

    

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _categoryID = [[NSMutableString alloc]init];
    
    if (_shouldUpdateGift) {
        [self prepareFieldsForEditing];
    }
    else
    {
        [self setImageLabel];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setImageLabel
{
    _lblImageCount.text = @"No Images Attached";
}




-(void)loadInitialView
{
    
    self.btnSave.layer.cornerRadius = 10;
    self.btnSave.layer.borderWidth = 2;
    self.btnSave.layer.borderColor = [UIColor whiteColor].CGColor;
    
    self.btnCancel.layer.cornerRadius = 10;
    self.btnCancel.layer.borderWidth = 2;
    self.btnCancel.layer.borderColor = [UIColor whiteColor].CGColor;
    
    self.btnSetCategory.layer.cornerRadius = 10;
    self.btnSetCategory.layer.borderWidth = 2;
    self.btnSetCategory.layer.borderColor = [UIColor whiteColor].CGColor;
    
    self.btnAttachPhoto.layer.cornerRadius = 10;
    self.btnAttachPhoto.layer.borderWidth = 2;
    self.btnAttachPhoto.layer.borderColor = [UIColor whiteColor].CGColor;
    
    self.txtCategory.layer.cornerRadius = 10;
    self.txtCategory.layer.borderWidth = 2;
    self.txtCategory.layer.borderColor = [UIColor yellowColor].CGColor;
    
    self.txtBrand.layer.cornerRadius = 10;
    self.txtBrand.layer.borderWidth = 2;
    self.txtBrand.layer.borderColor = [UIColor yellowColor].CGColor;
    
    self.txtSize.layer.cornerRadius = 10;
    self.txtSize.layer.borderWidth = 2;
    self.txtSize.layer.borderColor = [UIColor yellowColor].CGColor;
    
    self.txtWaist.layer.cornerRadius = 10;
    self.txtWaist.layer.borderWidth = 2;
    self.txtWaist.layer.borderColor = [UIColor yellowColor].CGColor;
    
    self.txtDetails.layer.cornerRadius = 10;
    self.txtDetails.layer.borderWidth = 2;
    self.txtDetails.layer.borderColor = [UIColor yellowColor].CGColor;
    
    self.txtItemType.layer.cornerRadius = 10;
    self.txtItemType.layer.borderWidth = 2;
    self.txtItemType.layer.borderColor = [UIColor yellowColor].CGColor;

       
}

-(void)prepareFieldsForEditing
{
    _txtCategory.text = _selectedGift.categoryName;
    [_categoryID setString:_selectedGift.category_id];
    _txtItemType.text = _selectedGift.itemType;
    _txtBrand.text = _selectedGift.itemBrand;
    _txtSize.text = _selectedGift.size;
    _txtWaist.text = _selectedGift.waist;
    _txtDetails.text = _selectedGift.details;
    
    if ([_selectedGift.imageDict count] == 1)
    {
        _lblImageCount.text = @"1 Image Attached";
    }
    else if ([_selectedGift.imageDict count] > 1)
    {
        NSMutableString *strCount = [[NSMutableString alloc]init];
        
        [strCount setString:[NSString stringWithFormat:@"%lu", (unsigned long)[_selectedGift.imageDict count]]];
        
        [strCount appendString:@" Images Attached"];
        _lblImageCount.text = [NSString stringWithString:strCount];
    }
    else
    {
        _lblImageCount.text = @"No Images Attached";
    }
    
    Global *sharedManager = [Global sharedManager];
    
    for (NSString* key in _selectedGift.imageDict) {
        NSString *value = [_selectedGift.imageDict objectForKey:key];
        [sharedManager imageFileNames:value];
    }
    
}




-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.txtItemType resignFirstResponder];
    [self.txtBrand resignFirstResponder];
    [self.txtSize resignFirstResponder];
    [self.txtWaist resignFirstResponder];
    return NO;
}


- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if (smallDeviceFlag)
    {
            NSRange resultRange = [text rangeOfCharacterFromSet:[NSCharacterSet newlineCharacterSet] options:NSBackwardsSearch];
        if ([text length] == 1 && resultRange.location != NSNotFound) {
            [_txtDetails resignFirstResponder];
            return NO;
        }
    }
    return YES;
    
}


-(void)setCategory:(Categories *)selectedCategory
{
    _txtCategory.text = selectedCategory.categoryName;
    [_categoryID setString:selectedCategory.category_id];
    
    [self enableAllFields];
    
    if ([selectedCategory.categoryName isEqualToString:@"Automotive"])
    {
        _txtWaist.enabled = false;
        _txtWaist.backgroundColor = [UIColor grayColor];
    }
    else if ([selectedCategory.categoryName isEqualToString:@"Clothing"])
    {
        
    }
    else if ([selectedCategory.categoryName isEqualToString:@"Electronics"])
    {
        _txtWaist.enabled = false;
        _txtWaist.backgroundColor = [UIColor grayColor];
    }
    else if ([selectedCategory.categoryName isEqualToString:@"Footwear"])
    {
        
    }
    else if ([selectedCategory.categoryName isEqualToString:@"Fragrances"])
    {
        _txtWaist.enabled = false;
        _txtWaist.backgroundColor = [UIColor grayColor];
    }
    else if ([selectedCategory.categoryName isEqualToString:@"Gift Cards"])
    {
        _txtWaist.enabled = false;
        _txtWaist.backgroundColor = [UIColor grayColor];
    }
    else if ([selectedCategory.categoryName isEqualToString:@"Handbags / Accessories"])
    {
        _txtWaist.enabled = false;
        _txtWaist.backgroundColor = [UIColor grayColor];
    }
    else if ([selectedCategory.categoryName isEqualToString:@"Hardware"])
    {
        _txtWaist.enabled = false;
        _txtWaist.backgroundColor = [UIColor grayColor];
    }
    else if ([selectedCategory.categoryName isEqualToString:@"Jewelry"])
    {
        _txtWaist.enabled = false;
        _txtWaist.backgroundColor = [UIColor grayColor];
    }
    else if ([selectedCategory.categoryName isEqualToString:@"Just For Fun"])
    {
        
    }
    else if ([selectedCategory.categoryName isEqualToString:@"Software"])
    {
        _txtWaist.enabled = false;
        _txtSize.enabled = false;
        _txtWaist.backgroundColor = [UIColor grayColor];
        _txtSize.backgroundColor = [UIColor grayColor];
    }
    else if ([selectedCategory.categoryName isEqualToString:@"Toys and Games"])
    {
        _txtWaist.enabled = false;
        _txtSize.enabled = false;
        _txtWaist.backgroundColor = [UIColor grayColor];
        _txtSize.backgroundColor = [UIColor grayColor];
    }
    else
    {
        
    }
}




- (IBAction)SetCategoryClock:(id)sender
{
    
}
- (IBAction)SaveClick:(id)sender
{
    if ([self isValid])
    {
        Gifts *thisGift = [self initializeGift];
        GiftController *control = [[GiftController alloc]init];
        
        Global *sharedManager = [Global sharedManager];
        People *_activePerson = [sharedManager activePerson];
        
        //NSLog(@"People ID: %@", _activePerson.people_id);
        //NSLog(@"Category ID: %@", _categoryID);
        
        thisGift.category_id = _categoryID;
        thisGift.people_id = _activePerson.people_id;
        thisGift.itemType = _txtItemType.text;
        thisGift.itemBrand = _txtBrand.text;
        thisGift.size = _txtSize.text;
        thisGift.waist = _txtWaist.text;
        thisGift.details = _txtDetails.text;
        
        if ([imageFileNames count] > 0) {
            thisGift.imageNames = imageFileNames;
        }
        
        if (_shouldUpdateGift) {
            thisGift.gift_id = _selectedGift.gift_id;
        }
        
        //NSLog(@"Gift ID: %@", thisGift.gift_id);
        
        if ([control InsertUpdateGift:thisGift shouldUpdate:_shouldUpdateGift])
        {
            [sharedManager reloadFlag:true];
            //NSLog(@"Reload Flag: %hhu", [sharedManager reloadFlag]);
            
            [sharedManager clearImageArray];
            [self dismissViewControllerAnimated:YES completion:Nil];
            
        }
    }
    else
    {
        
        UIAlertController * alert=   [UIAlertController
                                      alertControllerWithTitle:@"Missing Info!"
                                      message:@"The Type of Item and Category are required."
                                      preferredStyle:UIAlertControllerStyleAlert];
        
        
        UIAlertAction* ok = [UIAlertAction
                             actionWithTitle:@"OK"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 [alert dismissViewControllerAnimated:YES completion:nil];
                                 
                             }];
        
        [alert addAction:ok];

        [self presentViewController:alert animated:YES completion:nil];

    }
}

- (IBAction)CancelClick:(id)sender {
    
    Global *sharedManager = [Global sharedManager];
    [sharedManager clearImageArray];
    [self dismissViewControllerAnimated:YES completion:Nil];
}

#pragma mark - Validation
-(Boolean)isValid
{
    Boolean result = false;
    if (_txtItemType.text.length > 1 && _categoryID.length)
    {
        result = true;
    }
    return result;
}


-(Gifts *)initializeGift
{
    Gifts *newGift = [[Gifts alloc]init];
    
    newGift.gift_id = [[NSString alloc] init];
    newGift.category_id = [[NSString alloc] init];
    newGift.people_id = [[NSString alloc] init];
    newGift.itemType = [[NSString alloc] init];
    newGift.itemBrand = [[NSString alloc] init];
    newGift.size = [[NSString alloc] init];
    newGift.waist = [[NSString alloc] init];
    newGift.details = [[NSString alloc] init];
    newGift.categoryName = [[NSString alloc] init];
    
    return newGift;
}
- (IBAction)AttachPhotoClick:(id)sender {
    attachImageFlag = true;
}


#pragma mark -- Enabled Fields

-(void)enableAllFields
{
    _txtItemType.enabled = true;
    _txtBrand.enabled = true;
    _txtSize.enabled = true;
    _txtWaist.enabled = true;
    
    _txtItemType.backgroundColor = [UIColor whiteColor];
    _txtBrand.backgroundColor = [UIColor whiteColor];
    _txtSize.backgroundColor = [UIColor whiteColor];
    _txtWaist.backgroundColor = [UIColor whiteColor];
}
@end
