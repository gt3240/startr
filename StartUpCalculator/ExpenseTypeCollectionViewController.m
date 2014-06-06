//
//  ExpenseTypeCollectionViewController.m
//  StartUpCalculator
//
//  Created by Tom on 5/8/14.
//  Copyright (c) 2014 Tom Liu. All rights reserved.
//

#import "ExpenseTypeCollectionViewController.h"
#import "ExpenseTypeCollectionCell.h"

@interface ExpenseTypeCollectionViewController ()
{
    NSMutableArray * expenseTypeArr;
}
@end

@implementation ExpenseTypeCollectionViewController


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
    
    expenseTypeArr = [NSMutableArray array];
    
    NSString *incomeTypePlist = [[NSBundle mainBundle] pathForResource:@"ExpenseType" ofType:@"plist"];
    NSArray *typeInList = [NSArray arrayWithContentsOfFile:incomeTypePlist];
    
    for (NSDictionary *typeItem in typeInList) {
        
        IncomeAndExpenseType *newType = [[IncomeAndExpenseType alloc]init];
        
        newType.typeTitle = typeItem[@"type"];
        newType.imageName = [UIImage imageNamed:typeItem[@"image"]];
        
        [expenseTypeArr addObject:newType];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return expenseTypeArr.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ExpenseTypeCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ExpenseTypeCell" forIndexPath:indexPath];
    
    IncomeAndExpenseType * ImType = expenseTypeArr[indexPath.row];
    
    cell.TypeImage.image = ImType.imageName;
    cell.TypeTitleLabel.text = ImType.typeTitle;
    
    return cell;
}


-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    IncomeAndExpenseType * ImType = expenseTypeArr[indexPath.row];
    
    self.selectExpenseTypeObj.typeTitle = ImType.typeTitle;
    
    NSLog(@"Selected type is %@", ImType.typeTitle);
    
    [self.navigationController popViewControllerAnimated:YES];
    
}


@end
