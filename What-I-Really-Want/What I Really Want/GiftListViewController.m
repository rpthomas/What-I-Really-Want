//
//  SecondViewController.m
//  What I Really Want
//
//  Created by Roland Thomas on 6/5/15.
//  Copyright (c) 2015 Jedisware, LLC. All rights reserved.
//

#import "GiftListViewController.h"
#import "People.h"
#import "Global.h"
#import "GiftController.h"
#import "Utilities.h"
#import "Gifts.h"
#import "Device.h"
#import "AddEditGiftsViewController.h"
#import "DetailsViewController.h"

@interface GiftListViewController ()

@end

@implementation GiftListViewController

static bool _initialLoadDone = false;

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    Global *sharedManager = [Global sharedManager];
    [sharedManager lastTabIndex:1];
    _currentPerson = [sharedManager activePerson];
    _lblTitla.text = [self checkLastCharacter:_currentPerson];
    
    if ([sharedManager reloadFlag])
    {
        [sharedManager reloadFlag:false];
        [self loadData:_currentPerson];
        [_tblGiftList reloadData];
    }
    else
    {
        if (_initialLoadDone)
        {
            //NSLog(@"Person: %@", _currentPerson.people_id);
            [self loadData:_currentPerson];
            [_tblGiftList reloadData];
        }
        else
        {
            _initialLoadDone = true;
        }

    }
    
  
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self loadInitialView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(void)loadInitialView
{
    Global *sharedManager = [Global sharedManager];
    _currentPerson = [sharedManager activePerson];
    //NSLog(@"Person: %@", _currentPerson.fName);
    
    UIFont* boldFont = [UIFont boldSystemFontOfSize:22];
    [_lblTitla setFont:boldFont];
    
    _tblGiftList.layer.borderWidth = 5;
    _tblGiftList.layer.borderColor = [UIColor whiteColor].CGColor;
    
    self.btnAddGift.layer.cornerRadius = 10;
    self.btnAddGift.layer.borderWidth = 2;
    self.btnAddGift.layer.borderColor = [UIColor whiteColor].CGColor;
    
    self.btnEditGift.layer.cornerRadius = 10;
    self.btnEditGift.layer.borderWidth = 2;
    self.btnEditGift.layer.borderColor = [UIColor whiteColor].CGColor;

    [self loadData:_currentPerson];
   }



-(NSString *)checkLastCharacter:(People *)thisPerson
{
    NSMutableString *title = [[NSMutableString alloc]init];
    
    
    
    if ([thisPerson.fName isEqualToString:@"MySelf"])
    {
        [title setString:@"My Wish List"];
    }
    else
    {
        if (thisPerson.lName.length > 1) {
            [title setString:thisPerson.fName];
            [title appendString:@" "];
            
            if([thisPerson.lName hasSuffix:@"s"] || [thisPerson.lName hasSuffix:@"S"])
            {
                [title appendString:thisPerson.lName];
                [title appendString:@"' "];
                [title appendString:@"Wish List"];
            }
            else
            {
                [title appendString:thisPerson.lName];
                [title appendString:@"'s "];
                [title appendString:@"Wish List"];
            }
        }
        else
        {
            [title setString:thisPerson.fName];
            
            if([thisPerson.fName hasSuffix:@"s"] || [thisPerson.fName hasSuffix:@"S"])
            {
                [title appendString:@"' "];
                [title appendString:@"Wish List"];
            }
            else
            {
                [title appendString:@"'s "];
                [title appendString:@"Wish List"];
            }
        }
    }
    
    return [NSString stringWithString:title];

}


-(void)loadData:(People *)currentPerson
{
    //NSLog(@"People ID: %@", _currentPerson.people_id);
    GiftController *gifts = [[GiftController alloc]init];
    _recDict = [gifts loadGiftsByPeopleID:_currentPerson.people_id];

    /*
    _sortedArray = nil;
    
    Utilities *util = [[Utilities alloc]init];
    _sortedArray = [NSMutableArray arrayWithArray:[util convertDict_To_ArrayGiftOverload:_recDict sortArray:true  descriptor:@"categoryName"]];
    */
    self.keys = [[_recDict allKeys]sortedArrayUsingSelector:@selector(compare:)];
    
    
    self.tblGiftList.delegate = self;
    self.tblGiftList.dataSource = self;
}



#pragma mark - Table view data source
/*======================================================*/



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return [_keys count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSString *key = [_keys objectAtIndex:section];
    NSArray *itemType = [_recDict objectForKey:key];
    
    return  [itemType count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = nil;
    identifier = @"mainCell";
    
    NSString *key = [_keys objectAtIndex:indexPath.section];
    NSArray *giftArray = [_recDict objectForKey:key];
    
    @try
    {
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle: UITableViewCellStyleDefault reuseIdentifier:identifier];
            
            cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
        }
        
        
        Gifts *thisGift = [giftArray objectAtIndex:indexPath.row];
        
        cell.layer.cornerRadius = 30;
        cell.layer.borderWidth = 1;
        cell.layer.borderColor = [UIColor blueColor].CGColor;
        cell.backgroundColor = [UIColor whiteColor];
        cell.textLabel.text = thisGift.itemType;

        
        return cell;
    }
    @catch (NSException * e) {
        
        UIAlertController * alert=   [UIAlertController
                                      alertControllerWithTitle:@"Error occurred"
                                      message:e.description
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

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *key = [_keys objectAtIndex:section];
    
    return key;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {

    
    NSString *key = [_keys objectAtIndex:section];
    
    UILabel *myLabel = [[UILabel alloc] init];
    myLabel.frame = CGRectMake(12, 20, 320, 20);
    myLabel.font = [UIFont boldSystemFontOfSize:18];
    myLabel.textColor = [UIColor blackColor];
    myLabel.text = key;
    
    UIView *headerView = [[UIView alloc] init];
    [headerView addSubview:myLabel];
    
    return headerView;
}


- (void)tableView:(UITableView *)tableView
accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    
    [_tblGiftList selectRowAtIndexPath:indexPath
                               animated:NO
                         scrollPosition:UITableViewScrollPositionNone];
    
    [self performSegueWithIdentifier:@"detailsView" sender:self];
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        // Get reference to the destination view controlle
        NSIndexPath *selectedIndexPath = [_tblGiftList indexPathForSelectedRow];
        NSString *key = [_keys objectAtIndex:selectedIndexPath.section];
        NSArray *giftArray = [_recDict objectForKey:key];
        
        //NSLog(@"Key %@", key);
        
        Gifts *selectedGift = [giftArray objectAtIndex:selectedIndexPath.row];

        GiftController *gifts = [[GiftController alloc]init];
        if ([gifts DeleteGift:selectedGift])
        {
            Global *sharedManager = [Global sharedManager];
            _currentPerson = [sharedManager activePerson];
            [self loadData:_currentPerson];
            [_tblGiftList reloadData];
        }
        
    } else {
        //NSLog(@"Unhandled editing style! %d", editingStyle);
    }
    
}



- (IBAction)AddEditClick:(id)sender {
    //[self showActionSheet];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //NSLog(@"%ld", (long)indexPath.row); // you can see selected row number in your console;
}


#pragma mark- Segue Methods-

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    @try {
        
        // Make sure your segue name in storyboard is the same as this line
        if ([[segue identifier] isEqualToString:@"AddToList"])
        {
            // Get reference to the destination view controller
            AddEditGiftsViewController *add = [segue destinationViewController];
            add.shouldUpdateGift = FALSE;
        }
        else if ([[segue identifier] isEqualToString:@"EditList"])
        {
        
            NSIndexPath *selectedIndexPath = [_tblGiftList indexPathForSelectedRow];
            NSString *key = [_keys objectAtIndex:selectedIndexPath.section];
            NSArray *giftArray = [_recDict objectForKey:key];
            
            Gifts *selectedGift = [giftArray objectAtIndex:selectedIndexPath.row];
            
            NSLog(@"Row %ld", (long)selectedIndexPath.row);
            
            // Get reference to the destination view controller
            AddEditGiftsViewController *edit = [segue destinationViewController];
            edit.shouldUpdateGift = TRUE;
            edit.selectedGift = selectedGift;
            
        }
        else if ([[segue identifier] isEqualToString:@"detailsView"])
        {
            // Get reference to the destination view controlle
            NSIndexPath *selectedIndexPath = [_tblGiftList indexPathForSelectedRow];
            NSString *key = [_keys objectAtIndex:selectedIndexPath.section];
            NSArray *giftArray = [_recDict objectForKey:key];
            
            //NSLog(@"Key %@", key);
            
            Gifts *selectedGift = [giftArray objectAtIndex:selectedIndexPath.row];

            DetailsViewController *details = [segue destinationViewController];
            details.selectedGift = selectedGift;
            
            //NSLog(@"Selected Item %@", selectedGift.itemType);
        }
        else
        {
            
        }
    }
    @catch (NSException * e) {
        
        UIAlertController * alert=   [UIAlertController
                                      alertControllerWithTitle:@"Error occurred"
                                      message:e.description
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
    @finally {
        //NSLog(@"finally");
    }
    
}


-(BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    
    if ([identifier isEqualToString:@"AddToList"] || [identifier isEqualToString:@"detailsView"])
    {
        return true;
    }
    else if ([identifier isEqualToString:@"EditList"])
    {

        if ([_recDict count] == 0)
        {
            return false;
        }
        else
        {
            return true;
        }
    }
    else
    {
        return true;
    }
}

@end
