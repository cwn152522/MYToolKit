//
//  UITableViewCell+ReuseID.m
//  SomeUIInfo
//
//  Created by 黄锦祥 on 2018/4/18.
//  Copyright © 2018年 晨曦科技. All rights reserved.
//

#import "UITableViewCell+ReuseID.h"
@implementation UITableViewCell (ReuseID)
+ (__kindof UITableViewCell *)getCellFromXibWithTableView:(UITableView *)tableView IndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = [NSStringFromClass([self class]) componentsSeparatedByString:@"."].lastObject;
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(cell){
        return cell;
    }
    UINib *nib = [UINib nibWithNibName:identifier bundle:[NSBundle mainBundle]];
    [tableView registerNib:nib forCellReuseIdentifier:identifier];
    //    return [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([self class])];
    UITableViewCell * cell2 = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    return cell2;//height for row
}
+ (__kindof UITableViewCell *)getCellFromClassWithTableView:(UITableView *)tableView IndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = [NSStringFromClass([self class]) componentsSeparatedByString:@"."].lastObject;
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(cell)
        return cell;
    [tableView registerClass:[self class] forCellReuseIdentifier:identifier];
    return [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
}

+ (__kindof UITableViewCell *)getCellLoadNibNamed:(NSString *)name WithTableView:(UITableView *)tableView identifier:(NSString *)identifier{
    id cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        NSArray *nibs = [[NSBundle mainBundle]loadNibNamed:name owner:self options:nil];
        for (UITableViewCell *nib_cell in nibs) {
            if([nib_cell.reuseIdentifier isEqualToString:identifier]){
                return nib_cell;
            }
        }
        if (cell == nil) {
            cell = [[self alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        return cell;
    }
    return cell;
}



@end
@implementation UITableViewHeaderFooterView (ReuseID)

+ (__kindof UITableViewHeaderFooterView *)getHeaderFooterViewFromXibWithTableView:(UITableView *)tableView{
    NSString *identifier = [NSStringFromClass([self class]) componentsSeparatedByString:@"."].lastObject;
    UITableViewHeaderFooterView * HFView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:identifier];
    if(HFView)
        return HFView;
    UINib *nib = [UINib nibWithNibName:identifier bundle:[NSBundle mainBundle]];
    [tableView registerNib:nib forHeaderFooterViewReuseIdentifier:identifier];
    return [tableView dequeueReusableHeaderFooterViewWithIdentifier:identifier];
}
/** 适用于class创建  */
+ (__kindof UITableViewHeaderFooterView *)getHeaderFooterViewFromClassWithTableView:(UITableView *)tableView {
    NSString *identifier = [NSStringFromClass([self class]) componentsSeparatedByString:@"."].lastObject;
    UITableViewHeaderFooterView * HFView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:identifier];
    if(HFView)
        return HFView;
    [tableView registerClass:[self class] forHeaderFooterViewReuseIdentifier:identifier];
    return [tableView dequeueReusableHeaderFooterViewWithIdentifier:identifier];
}

- (void)setBackgroundColor:(UIColor *)backgroundColor{
    self.contentView.backgroundColor = backgroundColor;
}
@end
