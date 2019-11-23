//
//  XBImageDownloader.m
//  XBWebImage
//
//  Created by youxiao on 2019/11/22.
//  Copyright © 2019 youxiao. All rights reserved.
//

#import "XBImageDownloader.h"
#import "XBCacheManager.h"

typedef void(^downloadComplete)(NSString *,NSData *);
@interface XBImageDownloader()<NSURLSessionDelegate>

@property(nonatomic,readwrite,getter=isCancelled)BOOL cancelled;
@property(nonatomic,readwrite,getter=isFinished)BOOL finished;
@property(nonatomic,readwrite,getter=isExecuting)BOOL executing;
@property(nonatomic,assign)BOOL started;
@property (nonatomic, strong) NSRecursiveLock *lock;
@property(nonatomic,copy)NSString *reqUrl;
@property(nonatomic,copy)downloadComplete completeHandler;
@property(nonatomic,strong)NSMutableData *mutData;
@end

@implementation XBImageDownloader
@synthesize cancelled = _cancelled;
@synthesize finished = _finished;
@synthesize executing = _executing;

- (id)initWithImageUrl:(NSString *)url complete:(void(^)(NSString *,NSData *))completeHandle{
    self = [super init];
    if (self){
        _cancelled = NO;
        _finished = NO;
        _executing = NO;
        _started = NO;
        _lock = [[NSRecursiveLock alloc]init];
        _reqUrl = url;
        _completeHandler = completeHandle;
        _mutData = [[NSMutableData alloc]initWithLength:0];
    }
    return self;
}
- (void)start{
    if (_cancelled){
        return;
    }
    NSURL *url = [NSURL URLWithString:_reqUrl];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:nil];
    
    NSURLSessionDataTask *sessionTask = [session dataTaskWithRequest:request];
    [sessionTask resume];
}
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data{
    [_mutData appendData:data];
}
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task
didCompleteWithError:(nullable NSError *)error{
    if (!self.cancelled){
        _completeHandler(_reqUrl,[_mutData copy]);
    }
    [self reset];
}
- (void)reset{
    [_lock lock];
    self.executing = NO;
    self.finished = YES;
    self.started = NO;
    [_lock unlock];
}
- (void)cancel{
    [_lock lock];
    if (![self isCancelled]){
        [super cancel];
        
        self.cancelled = YES;
        self.executing = NO;
        self.finished = YES;
        self.started = NO;
    }
    [_lock unlock];
}
- (BOOL)isCancelled{
    [_lock lock];
    BOOL cancle = _cancelled;
    [_lock unlock];
    return cancle;
}
- (BOOL)isFinished{
    [_lock lock];
    BOOL finish = _finished;
    [_lock unlock];
    return finish;
}
- (BOOL)isExecuting{
    [_lock lock];
    BOOL executing = _executing;
    [_lock unlock];
    return executing;
}
@end
