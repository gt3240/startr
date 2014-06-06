//
//  IncomeTypeCollectionViewController.m
//  StartUpCalculator
//
//  Created by Tom on 4/28/14.
//  Copyright (c) 2014 Tom Liu. All rights reserved.
//

#import "IncomeTypeCollectionViewController.h"
#import "IncomeTypeCollectionCell.h"

@interface IncomeTypeCollectionViewController ()
{
    NSMutableArray * incomeTypeArr;
}
@end

@implementation IncomeTypeCollectionViewController

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
    
    incomeTypeArr = [NSMutableArray array];
    
    NSString *incomeTypePlist = [[NSBundle mainBundle] pathForResource:@"IncomeType" ofType:@"plist"];
    NSArray *typeInList = [NSArray arrayWithContentsOfFile:incomeTypePlist];
    
    for (NSDictionary *typeItem in typeInList) {
        
        IncomeAndExpenseType *newType = [[IncomeAndExpenseType alloc]init];
        
        newType.typeTitle = typeItem[@"incomeType"];
        newType.imageName = [UIImage imageNamed:typeItem[@"image"]];
        
        [incomeTypeArr addObject:newType];
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
    return incomeTypeArr.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    IncomeTypeCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"IncomeTypeCell" forIndexPath:indexPath];
    
    IncomeAndExpenseType * ImType = incomeTypeArr[indexPath.row];
    
    cell.TypeImage.image = ImType.imageName;
    cell.TypeTitleLabel.text = ImType.typeTitle;
    
    return cell;
}


-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    IncomeAndExpenseType * ImType = incomeTypeArr[indexPath.row];
    
    self.selectIncomeTypeObj.typeTitle = ImType.typeTitle;
    
    NSLog(@"Selected type is %@", ImType.typeTitle);
    
    [self.navigationController popViewControllerAnimated:YES];

}


@end
