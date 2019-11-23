//
//  XBImageManager.h
//  XBWebImage
//
//  Created by youxiao on 2019/11/22.
//  Copyright © 2019 youxiao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface XBImageManager : NSObject

+ (instancetype)sharedDown;
- (void)downloadImageWithUrl:(NSString *)url complete:(void(^)(NSData *,NSString *,UIImage *))completeHandle;
- (void)cancleDownloadWithUrl:(NSString *)url;
@end

NS_ASSUME_NONNULL_END
