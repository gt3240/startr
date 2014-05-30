//
//  displayTypeImage.m
//  StartUpCalculator
//
//  Created by Tom on 5/29/14.
//  Copyright (c) 2014 Tom Liu. All rights reserved.
//

#import "displayTypeImage.h"

@implementation displayTypeImage


- (UIImage *)showImage: (NSString *)type
{
    UIImage *imageToShow;
    
    if ([type isEqualToString:@"Investment"])
    {
        imageToShow = [UIImage imageNamed:@"investment"];
    } else if ([type isEqualToString:@"Loan"]){
        imageToShow = [UIImage imageNamed:@"loan"];
    } else if ([type isEqualToString:@"Sales"])
    {
        imageToShow = [UIImage imageNamed:@"sales"];
    } else if ([type isEqualToString:@"Others"])
    {
        imageToShow = [UIImage imageNamed:@"others"];
    } else if ([type isEqualToString:@"Undeclared Income"]) {
        imageToShow = [UIImage imageNamed:@"PlaceHolderBlue"];
    } else if ([type isEqualToString:@"Rent"])
    {
        imageToShow = [UIImage imageNamed:@"Rent"];
    } else if ([type isEqualToString:@"Electricity"]){
        imageToShow = [UIImage imageNamed:@"Electricity"];
    } else if ([type isEqualToString:@"Employee"])
    {
        imageToShow = [UIImage imageNamed:@"Employee"];
    } else if ([type isEqualToString:@"Others"])
    {
        imageToShow = [UIImage imageNamed:@"Others"];
    } else if ([type isEqualToString:@"Finance"])
    {
        imageToShow = [UIImage imageNamed:@"Finance"];
    } else if ([type isEqualToString:@"Marketing"])
    {
        imageToShow = [UIImage imageNamed:@"marketing"];
    } else if ([type isEqualToString:@"Telephone"])
    {
        imageToShow = [UIImage imageNamed:@"Telephone"];
    } else if ([type isEqualToString:@"COGS"])
    {
        imageToShow = [UIImage imageNamed:@"COGS"];
    } else if ([type isEqualToString:@"Water"])
    {
        imageToShow = [UIImage imageNamed:@"Water"];
    } else if ([type isEqualToString:@"Automobile"])
    {
        imageToShow = [UIImage imageNamed:@"Automobile"];
    } else if ([type isEqualToString:@"Hardware"])
    {
        imageToShow = [UIImage imageNamed:@"Hardware"];
    } else if ([type isEqualToString:@"Expenses"])
    {
        imageToShow = [UIImage imageNamed:@"Expenses"];
    }
    else if ([type isEqualToString:@"Undeclared Expense"]) {
        imageToShow = [UIImage imageNamed:@"PlaceHolderRed"];
    }

    return imageToShow;
}
@end
