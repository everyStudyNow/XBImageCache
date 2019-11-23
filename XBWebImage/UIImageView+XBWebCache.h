//
//  UIImageView+XBWebCache.h
//  XBWebImage
//
//  Created by youxiao on 2019/11/22.
//  Copyright © 2019 youxiao. All rights reserved.
//
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImageView (XBWebCache)

- (void)xb_setImageWithUrl:(NSString *)url;
@property(nonatomic,copy)NSString *urlStr;
@end

NS_ASSUME_NONNULL_END
