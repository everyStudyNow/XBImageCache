//
//  NSString+XBCachePath.m
//  XBWebImage
//
//  Created by youxiao on 2019/11/22.
//  Copyright © 2019 youxiao. All rights reserved.
//

#import "NSString+XBCachePath.h"
#import <CommonCrypto/CommonDigest.h>


@implementation NSString (XBCachePath)
- (void)saveImageWithData:(NSData *)data{
    [data writeToFile:[self getCachePath] atomically:YES];
}
- (NSData *)getImageDataWithUrl{
    return [NSData dataWithContentsOfFile:[self getCachePath]];
}
- (NSString *)getCachePath{
    NSString *filePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *saveDirectory = [filePath stringByAppendingPathComponent:@"XBImageCache"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:saveDirectory]){
        [fileManager createDirectoryAtPath:saveDirectory withIntermediateDirectories:YES attributes:nil error:nil];
    }
    NSString *savePath = [saveDirectory stringByAppendingPathComponent:[self xbmMd5String]];
    return savePath;
}
- (NSString *)xbmMd5String{
    const char *str = self.UTF8String;
    if (str == NULL) {
        str = "";
    }
    unsigned char r[CC_MD5_DIGEST_LENGTH];
    CC_MD5(str, (CC_LONG)strlen(str), r);
    NSURL *keyURL = [NSURL URLWithString:self];
    NSString *ext = keyURL ? keyURL.pathExtension : self.pathExtension;
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%@",
            r[0], r[1], r[2], r[3], r[4], r[5], r[6], r[7],
            r[8], r[9], r[10],r[11], r[12], r[13], r[14], r[15],
            ext.length == 0 ? @"" : [NSString stringWithFormat:@".%@", ext]];

}
@end
