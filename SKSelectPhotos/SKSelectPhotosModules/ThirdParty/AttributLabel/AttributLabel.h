//
//  AttributLabel.h
//  CQ_App
//
//  Created by mac on 2019/6/25.
//  Copyright © 2019 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AttributLabel : UILabel

@property (nonatomic, strong) NSString *htmlString;
@property (nonatomic, strong) NSString *solidString;
@property (nonatomic, strong) NSString *shadowString;

-(void)setUnderlineForString:(NSString *)string underline:(NSString *)underline underlineColor:(UIColor *)color;
-(void)setColorForString:(NSString *)string colorString:(NSString *)colorString colorStringColor:(UIColor *)color;

-(void)setShadowString:(NSString *)string offset:(CGSize)size;

@end

NS_ASSUME_NONNULL_END
