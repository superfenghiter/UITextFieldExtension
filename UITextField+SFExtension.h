//
//  UITextField+SFExtension.h
//  test
//
//  Created by superfeng on 10/02/2018.
//  Copyright © 2018 superfeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol UITextFieldDelegateSFExtension<UITextFieldDelegate>

@optional
- (void)textFieldDidChangeEditing:(UITextField *)textField;

@end

@interface UITextField(SFExtension)

- (void)limitInputLengthWithMaximumLength:(NSInteger)maximumLength;

@end
