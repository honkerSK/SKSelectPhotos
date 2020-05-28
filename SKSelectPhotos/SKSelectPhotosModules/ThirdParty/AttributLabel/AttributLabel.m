//
//  AttributLabel.m
//  CQ_App
//
//  Created by mac on 2019/6/25.
//  Copyright © 2019 mac. All rights reserved.
//

#import "AttributLabel.h"

@implementation AttributLabel

-(void)setSolidString:(NSString *)solidString {
    _solidString = solidString;
    NSAttributedString *attrStr = [[NSAttributedString alloc]initWithString:solidString  attributes: @{NSFontAttributeName:FONTSIZE(12.0f),NSForegroundColorAttributeName:MAINCOLOR(),NSStrikethroughStyleAttributeName:@(NSUnderlineStyleSingle|NSUnderlinePatternSolid),NSStrikethroughColorAttributeName:MAINCOLOR()}];
    
    self.attributedText = attrStr;
}
-(void)setHtmlString:(NSString *)htmlString {
    _htmlString = htmlString;
    self.numberOfLines = 0;
    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithData:[htmlString dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,NSFontAttributeName:FONTSIZE(14)} documentAttributes:nil error:nil];
    self.attributedText = attributedString;
}

-(void)setShadowString:(NSString *)shadowString {
    _shadowString = shadowString;
    if (shadowString == nil) {
        return;
    }
    NSShadow *shadow = [[NSShadow alloc] init];
    shadow.shadowBlurRadius = 2;
    shadow.shadowColor = [UIColor blackColor];
    shadow.shadowOffset = CGSizeMake(0,0);
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:shadowString attributes: @{NSFontAttributeName: self.font,NSForegroundColorAttributeName: COLORFFFFFF(), NSShadowAttributeName: shadow}];
    self.attributedText = attributedString;
}
-(void)setShadowString:(NSString *)string offset:(CGSize)size {
    NSShadow *shadow = [[NSShadow alloc] init];
    shadow.shadowBlurRadius = 0;
    shadow.shadowColor = RGBACOLOR(0, 0, 0, 0.5);
    shadow.shadowOffset = size;
    
    NSMutableAttributedString *atString = [[NSMutableAttributedString alloc] initWithString:string attributes: @{NSFontAttributeName: self.font,NSForegroundColorAttributeName: COLORFFFFFF(), NSShadowAttributeName: shadow}];
    self.attributedText = atString;
}
-(void)setUnderlineForString:(NSString *)string underline:(NSString *)underline underlineColor:(UIColor *)color{
    
    NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString:string];
    
    NSRange range = [[attribtStr string] rangeOfString:underline];
    // 下划线
    [attribtStr addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:range];
    [attribtStr addAttribute:NSForegroundColorAttributeName value:color range:range];
    //赋值
    self.attributedText = attribtStr;
}

-(void)setColorForString:(NSString *)string colorString:(NSString *)colorString colorStringColor:(UIColor *)color{
    
    NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString:string];
    
    NSRange range = [[attribtStr string] rangeOfString:colorString];
    [attribtStr addAttribute:NSForegroundColorAttributeName value:color range:range];
    //赋值
    self.attributedText = attribtStr;
}
@end
