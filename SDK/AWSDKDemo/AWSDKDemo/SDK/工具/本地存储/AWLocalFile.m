//
//  DHLocalFile.m
//  douhuayuedu
//
//  Created by douhua on 2020/9/7.
//  Copyright © 2020 HeGuiHan. All rights reserved.
//


#define pDHPath                 [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject]
#define pCachePath              [pDHPath stringByAppendingPathComponent:@"SSCache"]

#import "AWLocalFile.h"
#import "Tools.h"

@implementation AWLocalFile


//这里是写到 pCachePath目录下的  path模式   pCachePath/xxxxxx, 所以这里不用拼接了

+(void)saveToLocalWithPath:(NSString *)path withData:(id)data
{
    NSFileManager *manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:pCachePath]) {
        //创建目录
        [manager createDirectoryAtPath:pCachePath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    NSString *finalPath = [pCachePath stringByAppendingPathComponent:path];

    
    NSData *jsonData = [Tools dictToData:data];
    if (![jsonData writeToFile:finalPath atomically:YES]) {
        AWLog(@"%@--写入失败",path);
    }
}


+(void)removeDocumentDataAtPath:(NSString *)path
{
    NSString *finalPath = [pCachePath stringByAppendingPathComponent:path];
    if([[NSFileManager defaultManager] fileExistsAtPath:finalPath]) {
        [[NSFileManager defaultManager] removeItemAtPath:finalPath error:nil];
    }
}

//加载指定路径的数据
+ (id)loadLocalCache:(NSString *)path
{
    NSString *finalPath = [pCachePath stringByAppendingPathComponent:path];
    NSError *error = nil;
    NSData *jsonData = [NSData dataWithContentsOfFile:finalPath];
    if(jsonData == nil)
        return nil;
    NSJSONSerialization *json = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:&error];
    return json;
}



@end
