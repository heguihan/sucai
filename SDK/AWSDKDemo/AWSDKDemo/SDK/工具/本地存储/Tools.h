//
//  Tools.h
//  testFunction
//
//  Created by admin on 2020/11/30.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Tools : NSObject
+(NSData *)dictToData:(id)dict;
+(NSDictionary *)dataToDict:(NSData *)datax;
@end

NS_ASSUME_NONNULL_END
