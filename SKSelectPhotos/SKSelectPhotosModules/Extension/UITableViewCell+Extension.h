//
//  UITableViewCell+Extension.h
//  xiangwan
//
//  Created by mac on 2019/8/17.
//  Copyright © 2019 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UITableViewCell (Extension)

/// cell Class注册方法
+ (void)registerClassForTableView:(UITableView *)tableView;
/// cell Nib注册方法
+ (void)registerNibForTableView:(UITableView *)tableView;
+ (NSString *)identifier;

@end

NS_ASSUME_NONNULL_END
