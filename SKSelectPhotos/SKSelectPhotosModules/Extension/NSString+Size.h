//
//  NSString+Size.h
//  CQ_App
//
//  Created by Nemo on 2019/4/10.
//  Copyright © 2019年 mac. All rights reserved.
//
// sk:根据文字字号和内容的最大宽或者高,计算高或者宽
#import <Foundation/Foundation.h>

@interface NSString (Size)

-(CGFloat)widthForMaxHeight:(CGFloat)maxHeight fontSize:(CGFloat)fontSize;
-(CGFloat)heightForMaxWidth:(CGFloat)maxWidth fontSize:(CGFloat)fontSize;

-(CGFloat)heightForMaxWidth:(CGFloat)maxWidth font:(UIFont *)font;
-(CGFloat)widthForMaxHeight:(CGFloat)maxHeight font:(UIFont *)font;


-(CGFloat)heightHTMLForMaxWidth:(CGFloat)maxWidth font:(UIFont *)font;
-(CGFloat)heightHTMLForMaxWidth:(CGFloat)maxWidth attr:(NSAttributedString *)attr;

@end
