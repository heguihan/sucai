//
//  DHLocalFile.h
//  douhuayuedu
//
//  Created by douhua on 2020/9/7.
//  Copyright © 2020 HeGuiHan. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AWLocalFile : NSObject
//写入数据到指定目录
+(void)saveToLocalWithPath:(NSString *)path withData:(id)data;
//删除指定目录的数据
+(void)removeDocumentDataAtPath:(NSString *)path;
//加载指定路径的数据
+ (id)loadLocalCache:(NSString *)path;
@end

NS_ASSUME_NONNULL_END
