//
//  EditProjectTableViewController.m
//  StartUpCalculator
//
//  Created by Tom on 5/30/14.
//  Copyright (c) 2014 Tom Liu. All rights reserved.
//

#import "EditProjectTableViewController.h"
#import "AppDelegate.h"
#import "Periods.h"


@interface EditProjectTableViewController ()
{
    NSArray *periodArr;
    AppDelegate* appDelegate;
}
@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
@property (weak, nonatomic) IBOutlet UITextField *monthsTextField;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;

@end

@implementation EditProjectTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    appDelegate = [UIApplication sharedApplication].delegate;
    self.managedObjectContext = appDelegate.managedObjectContext;
    
    // Do any additional setup after loading the view.
    self.titleTextField.text = self.openedProject.name;
    self.titleTextField.adjustsFontSizeToFitWidth = YES;
    
    // Load periods
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"periodNum" ascending:YES];
    periodArr = [self.openedProject.period sortedArrayUsingDescriptors:@[sort]];
    
    self.monthsTextField.text = [NSString stringWithFormat:@"%lu", (unsigned long)periodArr.count];
  
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)donePressed:(UIBarButtonItem *)sender {
    
    if ([self.titleTextField.text isEqualToString:@""]) {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Warning" message:@"Please enter a title" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil,nil];
        [alert show];
    } else if (self.monthsTextField.text.integerValue == 0) {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Warning" message:@"Months can't be 0" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil,nil];
        [alert show];

    } else {
        [self.openedProject setValue:self.titleTextField.text forKey:@"name"];
        int monthDif = self.monthsTextField.text.intValue - (int)periodArr.count;
        int newNumOfMonth = (int)periodArr.count + monthDif;
        
        NSLog(@"new month num is %d", newNumOfMonth);
        
        if (self.monthsTextField.text.intValue < self.openedProject.period.count) {
            [self deleteMonths: monthDif];
            NSLog(@"month dif is %d", monthDif);
            NSLog(@"smaller");
            
        } else if (self.monthsTextField.text.intValue > self.openedProject.period.count) {
            
            [self addMonths: monthDif];
            NSLog(@"bigger");
        }
        
        NSError *error;
        if (![self.managedObjectContext save:&error]) {
            NSLog(@"Whoops, name couldn't save: %@", [error localizedDescription]);
        } else {
            NSLog(@"name saved");
        }
        
        if (appDelegate.peroidToShow > newNumOfMonth ) {
            appDelegate.peroidToShow = newNumOfMonth - 1;
        }
        
        [self dismissViewControllerAnimated:YES completion:nil];
    }

}

- (void)deleteMonths: (int)month
{
    for (int i = (int)periodArr.count + month; i < periodArr.count; i++) {
        
        Periods * pToDelete = periodArr[i];
        NSLog(@"p num is %@", pToDelete.periodNum);
        [self.openedProject removePeriodObject:pToDelete];
    }
}

- (void)addMonths: (int)month
{
    for (int i = (int)periodArr.count + 1; i <= periodArr.count + month; i++) {
        Periods *newPeriod = [NSEntityDescription insertNewObjectForEntityForName:@"Periods" inManagedObjectContext:self.managedObjectContext];
        newPeriod.periodNum = [NSNumber numberWithInt:i];
        [self.openedProject addPeriodObject:newPeriod];
    }
}

- (IBAction)titleTextField:(UITextField *)sender {
}

- (IBAction)canceled:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];

}

@end
