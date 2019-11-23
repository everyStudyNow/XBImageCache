//
//  XBCacheManager.m
//  XBWebImage
//
//  Created by youxiao on 2019/11/23.
//  Copyright © 2019 youxiao. All rights reserved.
//

#import "XBCacheManager.h"
#import "NSString+XBCachePath.h"

@implementation XBCacheManager

+ (instancetype)shareManager{
    static XBCacheManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[XBCacheManager alloc]init];
    });
    return manager;
}
- (void)saveMemoryWithUrl:(NSString *)url urlData:(NSData *)data{
    [self.memoryCache setValue:data forKey:url];
}
- (void)saveToDiskWithUrl:(NSString *)url urlData:(NSData *)data{
    [url saveImageWithData:data];
}
- (NSData *)getImageDataWithUrl:(NSString *)url{
    if (self.memoryCache[url]){
        return self.memoryCache[url];
    }
    else {
        return [url getImageDataWithUrl];
    }
}
- (NSMutableDictionary *)memoryCache{
    if (!_memoryCache){
        _memoryCache = [[NSMutableDictionary alloc]initWithCapacity:0];
    }
    return _memoryCache;
}
@end
