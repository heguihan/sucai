//
//  Tools.m
//  testFunction
//
//  Created by admin on 2020/11/30.
//

#import "Tools.h"

@implementation Tools
+(NSData *)dictToData:(id)dict
{
    NSData *datax= [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil];
    if (!datax) {
        return nil;
    }
    return datax;
}
+(NSDictionary *)dataToDict:(NSData *)datax
{
    NSDictionary *dictionary =[NSJSONSerialization JSONObjectWithData:datax options:NSJSONReadingMutableLeaves error:nil];
    return dictionary;
}
@end
