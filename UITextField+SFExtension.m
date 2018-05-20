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

- (instancetype)mInitWithCoder:(NSCoder *)aDecoder {
    if ([self mInitWithCoder:aDecoder]) {
        [self addTarget:self
                 action:@selector(replaceNormalSpaceUsingNonbreakingSpace)
       forControlEvents:UIControlEventEditingChanged];
    }
    return self;
}

- (instancetype)mInitWithFrame:(CGRect)frame {
    if ([self mInitWithFrame:frame]) {
        [self addTarget:self
                 action:@selector(replaceNormalSpaceUsingNonbreakingSpace)
       forControlEvents:UIControlEventEditingChanged];
    }
    return self;
}

- (void)replaceNormalSpaceUsingNonbreakingSpace {
    UITextRange *textRange = self.selectedTextRange;
    self.text = [[self mGetText] stringByReplacingOccurrencesOfString:@" "
                                                     withString:@"\u00a0"];
    [self setSelectedTextRange:textRange];
}

- (NSString *)mGetText {
    NSString *text = [self mGetText];
    return [text stringByReplacingOccurrencesOfString:@"\u00a0" withString:@" "];
}

@end
