//
//  XBCacheManager.h
//  XBWebImage
//
//  Created by youxiao on 2019/11/23.
//  Copyright © 2019 youxiao. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XBCacheManager : NSObject

@property(nonatomic,retain)NSMutableDictionary *memoryCache;

+ (instancetype)shareManager;
- (void)saveMemoryWithUrl:(NSString *)url urlData:(NSData *)data;
- (void)saveToDiskWithUrl:(NSString *)url urlData:(NSData *)data;
- (NSData *)getImageDataWithUrl:(NSString *)url;
@end

NS_ASSUME_NONNULL_END
