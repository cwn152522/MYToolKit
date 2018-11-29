//
//  UIImage+ImgSize.h
//  Demo
//
//  Created by cwn on 2018/11/29.
//  Copyright © 2018年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ImageIO/ImageIO.h>

@interface UIImage (ImgSize)
/**
 *  根据图片url获取网络图片尺寸
 */
+ (CGSize)getImageSizeWithURL:(id)URL;

@end
