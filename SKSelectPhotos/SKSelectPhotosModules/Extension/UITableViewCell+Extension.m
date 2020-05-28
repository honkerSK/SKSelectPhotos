//
//  UITableViewCell+Extension.m
//  xiangwan
//
//  Created by mac on 2019/8/17.
//  Copyright © 2019 mac. All rights reserved.
//

#import "UITableViewCell+Extension.h"

@implementation UITableViewCell (Extension)

+ (void)registerClassForTableView:(UITableView *)tableView {
    [tableView registerClass:self forCellReuseIdentifier:[self identifier]];
}

+ (void)registerNibForTableView:(UITableView *)tableView {
    [tableView registerNib:[UINib nibWithNibName:[self className]
                                               bundle:[NSBundle mainBundle]] forCellReuseIdentifier:[self identifier]];
}

+ (NSString *)identifier {
    return [NSString stringWithFormat:@"%@Id",[self className]];
}

@end
