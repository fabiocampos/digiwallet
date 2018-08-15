//
//  MoneyTextFieldDelegate.m
//  Digiwallet
//
//  Created by Fabio Campos on 12/08/2018.
//  Copyright © 2018 green. All rights reserved.
//

#import "MoneyTextField.h"

#import "MoneyFormat.h"

@implementation MoneyTextField
- (IBAction)textFieldEndEditing:(id)sender {
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSString *inputToParse = [textField.text stringByAppendingString:string];
    NSNumber *myNumber = [self getNumberFrom:inputToParse];
    NSString *trimmedString = [string stringByTrimmingCharactersInSet:
                               [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if(range.length == 1 ||([trimmedString length] > 0 && myNumber != nil)){
         return YES;
    }
    
    return NO;
}

-(NSNumber*) getInputValue{
    return [self getNumberFrom:self.text];
}

-(NSNumber*) getNumberFrom:(NSString*)text{
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    return [numberFormatter numberFromString:text];
}

@end
