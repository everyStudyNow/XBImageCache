//
//  UIImageView+XBWebCache.m
//  XBWebImage
//
//  Created by youxiao on 2019/11/22.
//  Copyright © 2019 youxiao. All rights reserved.
//

#import "UIImageView+XBWebCache.h"
#import "XBImageManager.h"
#import <objc/runtime.h>

const char *xb_loadimageUrlKey = "xb_loadimageUrlKey";
@implementation UIImageView (XBWebCache)

- (void)xb_setImageWithUrl:(NSString *)url{
    self.image = nil;
    // 取消下载操作
    [[XBImageManager sharedDown] cancleDownloadWithUrl:self.urlStr];
    // 记录当前的下载操作
    self.urlStr = url;
    [[XBImageManager sharedDown] downloadImageWithUrl:url complete:^(NSData * _Nonnull data, NSString * _Nonnull url,UIImage *image) {
        self.image = image;
    }];
}
- (void)setUrlStr:(NSString *)urlStr{
    objc_setAssociatedObject(self, xb_loadimageUrlKey, urlStr, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
- (NSString *)urlStr{
    return objc_getAssociatedObject(self, xb_loadimageUrlKey);
}
@end
