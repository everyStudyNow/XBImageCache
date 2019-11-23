//
//  XBImageManager.m
//  XBWebImage
//
//  Created by youxiao on 2019/11/22.
//  Copyright © 2019 youxiao. All rights reserved.
//

#import "XBImageManager.h"
#import "XBImageDownloader.h"
#import "XBCacheManager.h"

typedef void(^XBHandleBlock)(NSData *,NSString *,UIImage *);
@interface XBImageManager()

@property(nonatomic,retain)NSMutableDictionary *operationDic; // 正在操作的队列
@property(nonatomic,retain)NSOperationQueue *downloadQueue; // 下载队列
@property(nonatomic,retain)NSMutableDictionary *handleDic; // 每个url对应的回调数组

@end
@implementation XBImageManager

+ (instancetype)sharedDown{
    static XBImageManager *downloader;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        downloader = [[XBImageManager alloc]init];
    });
    return downloader;
}
- (void)downloadImageWithUrl:(NSString *)url complete:(XBHandleBlock)completeHandle{
//    NSData *cacheData = [[XBCacheManager shareManager] getImageDataWithUrl:url];
//    if (cacheData){
//        completeHandle(cacheData,url,[UIImage imageWithData:cacheData]);
//        return;
//    }
    [self safeAddCompleteBlock:url completeBlock:completeHandle];
    // 操作已经存在 无需再执行 并且记录者回调
    if (self.operationDic[url] != nil){
        return;
    }
    __weak typeof(self) weakSelf = self;
    XBImageDownloader *downloadOperation = [[XBImageDownloader alloc]initWithImageUrl:url complete:^(NSString * _Nonnull url, NSData * _Nonnull data) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        UIImage *image = [UIImage imageWithData:data];
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            completeHandle(data,url,image);
            // 下载成功 删除operate
            [strongSelf safeRemoveOperate:url];
            // 下载成功 执行图片回调
            NSMutableArray *handleBlockArr = strongSelf.handleDic[url];
            for (XBHandleBlock block in handleBlockArr){
                block(data,url,image);
            }
            [[XBCacheManager shareManager] saveMemoryWithUrl:url urlData:data];
            [[XBCacheManager shareManager] saveToDiskWithUrl:url urlData:data];
            // 下载成功将保存的数据删除 节省点内存
            [self safeRemoveHandleBlock:url];
        }];
    }];
    [self.downloadQueue addOperation:downloadOperation];
    // 将正在执行的下载操作存储
    [self.operationDic setValue:downloadOperation forKey:url];
}
- (void)safeRemoveOperate:(NSString *)url{
    @synchronized (self) {
        [self.operationDic removeObjectForKey:url];
    }
}
- (void)safeAddCompleteBlock:(NSString *)url completeBlock:(XBHandleBlock)block{
    @synchronized (self) {
        if (self.handleDic[url] != nil){
            [self.handleDic[url] addObject:block];
        }
        else {
            NSMutableArray *blockArr = [[NSMutableArray alloc]initWithCapacity:0];
            [blockArr addObject:block];
            [self.handleDic setValue:blockArr forKey:url];
        }
    }
}
- (void)safeRemoveHandleBlock:(NSString *)url{
    @synchronized (self) {
        [self.handleDic removeObjectForKey:url];
    }
}
- (NSMutableDictionary *)operationDic{
    if (_operationDic == nil){
        _operationDic = [[NSMutableDictionary alloc]initWithCapacity:0];
    }
    return _operationDic;
}
- (NSOperationQueue *)downloadQueue{
    if (!_downloadQueue){
        _downloadQueue = [[NSOperationQueue alloc]init];
    }
    return _downloadQueue;
}
- (NSMutableDictionary *)handleDic{
    if (!_handleDic){
        _handleDic = [[NSMutableDictionary alloc]initWithCapacity:0];
    }
    return _handleDic;
}
- (void)cancleDownloadWithUrl:(NSString *)url{
    @synchronized (self) {
        if (_operationDic[url] != nil){
            NSOperation *operate = _operationDic[url];
            [operate cancel];
            [_operationDic removeObjectForKey:url];
        };
    }
}
@end
