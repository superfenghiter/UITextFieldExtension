//
//  UITextField+SFExtension.m
//  test
//
//  Created by superfeng on 10/02/2018.
//  Copyright © 2018 superfeng. All rights reserved.
//

#import "UITextField+SFExtension.h"
#import "JRSwizzle.h"

@implementation UITextField(SFExtension)

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [[UITextField class] jr_swizzleMethod:@selector(mInitWithCoder:) withMethod:@selector(initWithCoder:) error:nil];
        [[UITextField class] jr_swizzleMethod:@selector(mInitWithFrame:) withMethod:@selector(initWithFrame:) error:nil];
        [[UITextField class] jr_swizzleMethod:@selector(mGetText) withMethod:@selector(text) error:nil];
    });
}

- (instancetype)mInitWithCoder:(NSCoder *)aDecoder
{
    if ([self mInitWithCoder:aDecoder]) {
        [self addTarget:self
                 action:@selector(replaceNormalSpaceUsingNonbreakingSpace)
       forControlEvents:UIControlEventEditingChanged];
        [self addTarget:self
                 action:@selector(textFieldDidChangeEditing:)
       forControlEvents:UIControlEventEditingChanged];
    }
    return self;
}

- (instancetype)mInitWithFrame:(CGRect)frame
{
    if ([self mInitWithFrame:frame]) {
        [self addTarget:self
                 action:@selector(replaceNormalSpaceUsingNonbreakingSpace)
       forControlEvents:UIControlEventEditingChanged];
        [self addTarget:self
                 action:@selector(textFieldDidChangeEditing:)
       forControlEvents:UIControlEventEditingChanged];
    }
    return self;
}

- (void)replaceNormalSpaceUsingNonbreakingSpace
{
    UITextRange *textRange = self.selectedTextRange;
    self.text = [[self mGetText] stringByReplacingOccurrencesOfString:@" "
                                                     withString:@"\u00a0"];
    [self setSelectedTextRange:textRange];
}

- (NSString *)mGetText
{
    NSString *text = [self mGetText];
    return [text stringByReplacingOccurrencesOfString:@"\u00a0" withString:@" "];
}

- (void)textFieldDidChangeEditing:(UITextField *)textField
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(textFieldDidChangeEditing:)]) {
        [self.delegate performSelector:@selector(textFieldDidChangeEditing:) withObject:textField];
    }
}

- (void)limitInputLengthWithMaximumLength:(NSInteger)maximumLength
{
    NSString *toBeString = self.text;
    NSString *lang = [[UIApplication sharedApplication] textInputMode].primaryLanguage; //ios7之前使用[UITextInputMode currentInputMode].primaryLanguage
    
    if ([lang isEqualToString:@"zh-Hans"]) { //中文输入
        UITextRange *selectedRange = [self markedTextRange];
        //获取高亮部分
        UITextPosition *position = [self positionFromPosition:selectedRange.start offset:0];
        if (!position) {// 没有高亮选择的字，则对已输入的文字进行字数统计和限制
            if (toBeString.length > maximumLength) {
                self.text = [toBeString substringToIndex:maximumLength];
            }
        }
        else{//有高亮选择的字符串，则暂不对文字进行统计和限制
        }
    } else {
        if (toBeString.length > maximumLength) {
            self.text = [toBeString substringToIndex:maximumLength];
        }
    }
}

@end
