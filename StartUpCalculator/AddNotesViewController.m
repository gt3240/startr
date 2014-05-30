//
//  AddNotesViewController.m
//  StartUpCalculator
//
//  Created by Tom on 5/28/14.
//  Copyright (c) 2014 Tom Liu. All rights reserved.
//

#import "AddNotesViewController.h"
#import "AppDelegate.h"
#import "Notes.h"

@interface AddNotesViewController ()

@property (weak, nonatomic) IBOutlet UITextView *notesTextView;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;

@end

@implementation AddNotesViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    AppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
    self.managedObjectContext = appDelegate.managedObjectContext;
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    if (self.currentNotes) {
        self.notesTextView.text = self.currentNotes.notes;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)canclePressed:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)savedPressed:(UIBarButtonItem *)sender {
    if (self.currentNotes) {
        [self.currentNotes setValue:self.notesTextView.text forKey:@"notes"];
        [self.currentNotes setValue:[NSDate date] forKey:@"date"];

        NSLog(@"notes editted");
    } else {
        Notes * notes = [NSEntityDescription insertNewObjectForEntityForName:@"Notes" inManagedObjectContext:self.managedObjectContext];
        notes.date = [NSDate date];
        notes.notes = self.notesTextView.text;
        [self.currentProject addNotesObject:notes];
        NSLog(@"notes added");
    }
   
    
    NSError *error;
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
    } else {
        NSLog(@"notes saved");
    }
    [self dismissViewControllerAnimated:YES completion:nil];

}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
