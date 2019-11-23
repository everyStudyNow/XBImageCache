//
//  NSString+XBCachePath.h
//  XBWebImage
//
//  Created by youxiao on 2019/11/22.
//  Copyright © 2019 youxiao. All rights reserved.
//


#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (XBCachePath)

- (void)saveImageWithData:(NSData *)data;
- (NSData *)getImageDataWithUrl;
@end

NS_ASSUME_NONNULL_END
