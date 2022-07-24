//
//  AWSocket.m
//  AWSDKDemo
//
//  Created by admin on 2021/1/16.
//

#import "AWSocket.h"
#import "GCDAsyncSocket.h"
#import "ByteBuffer.h"
#import <zlib.h>
#import "AWLocalFile.h"
#import "AWSocketLocalDataManager.h"
#import "AWSDKApi.h"
@interface AWSocket()
@property(nonatomic, strong)GCDAsyncSocket *socket;
@end

@implementation AWSocket
+(instancetype)shareInstance
{
    static AWSocket *socketInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        socketInstance = [AWSocket new];
    });
    return socketInstance;
}

-(void)connectWithHost:(NSString *)host andport:(int)port
{
    NSString *testhost = @"192.168.10.225";
//    int port = 8041;
    //sdk version 1.1
    //创建一个socket对象
    
//    NSString *testHost = @"47.96.121.15";
//    int testport = 8041;
    if (host.length<2) {
        return;
    }
    if (port<1) {
        return;
    }
    
    _socket = [[GCDAsyncSocket alloc] initWithDelegate:self
                                         delegateQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];

    NSError *error = nil;

    [_socket connectToHost:host onPort:port withTimeout:5 error:&error];


    if (error) {
        NSLog(@"%@",error);
    }
}

-(void)sendDataWithMsg:(NSString *)msg type:(short)type msgID:(uint)msgid iszip:(BOOL)isZip isfirst:(BOOL)isfirst
{
    if (!_socket.isConnected) {
        return;
    }
    
    NSLog(@"socketmsg==%@,msgID=%d",msg,msgid);
    NSData *data =[msg dataUsingEncoding:NSUTF8StringEncoding];
    if (isZip) {
        data = [self gzipDeflate:msg];
    }
    int dataLen = (int)[data length];
    ByteBuffer *buffer = [ByteBuffer initWithOrder:ByteOrderBigEndian];
    int header = 18;
    if (!isZip) {
        header = 2;
    }
    [buffer putShort:type];
    [buffer putInt:header];
    [buffer putInt:msgid];
    [buffer putInt:dataLen];
    [buffer putData:data];
    NSData *resultData = [buffer convertNSData];
    
    if (type==202 || type==203 || type == 208) {
        if (isfirst) {
            NSDictionary *socketData = [AWLocalFile loadLocalCache:SOCKETDATA];
            NSMutableDictionary *mutabDatadict = [[NSMutableDictionary alloc]initWithDictionary:socketData];
            NSDictionary *saveDict = @{@"timestr":[AWTools getCurrentTimeString],@"type":@(type),@"iszip":@(isZip),@"data":msg};
            [mutabDatadict setValue:saveDict forKey:[NSString stringWithFormat:@"%d",msgid]];
            [AWLocalFile saveToLocalWithPath:SOCKETDATA withData:[mutabDatadict copy]];
        }
    }

    Byte *bytenew = (Byte *)[resultData bytes];
    NSInteger length = [resultData length] /sizeof(uint8_t);
    NSMutableArray *intArr = [NSMutableArray array];
    for (int i=0; i<length; i++) {
//        NSLog(@"bytenew==%d",bytenew[i]);
        [intArr addObject:[NSString stringWithFormat:@"%d",bytenew[i]]];
    }
//    NSLog(@"%@",intArr);
//    @synchronized (self) {
//        [_socket writeData:resultData withTimeout:10 tag:100];
//    }
    [_socket writeData:resultData withTimeout:10 tag:100];

}

-(void)resendData
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        AWLog(@"after---%@",[NSThread currentThread]);
        NSDictionary *socketData = [AWLocalFile loadLocalCache:SOCKETDATA];
        if ([socketData count]<1) {
            return;
        }
        if ([socketData count]>50) {
            [self dealDataWithsocketDict:socketData];
            return;
        }
        
        NSMutableArray *msgIDArr = [NSMutableArray array];
        for (NSString *key in socketData) {
            NSDictionary *datadict = socketData[key];
            NSString *timeStr = datadict[@"timestr"];
            if ([AWTools getTimerIntertwoDays:timeStr]) {
                [msgIDArr addObject:key];
            }
            short type = [datadict[@"type"] shortValue];
            BOOL isgzip = [datadict[@"iszip"] boolValue];
            NSString *msg = datadict[@"data"];
            [self sendDataWithMsg:msg type:type msgID:[key intValue] iszip:isgzip isfirst:NO];
        }
        if (msgIDArr.count>0) {
            for (NSString *msgID in msgIDArr) {
                [AWSocketLocalDataManager removeMsg:[msgID intValue] datadict:socketData];
            }
        }

    });
}

//超过50条数据，删掉最早的，留45条
-(void)dealDataWithsocketDict:(NSDictionary *)dataDict
{
    NSMutableArray *msgTimeArr = [NSMutableArray array];
    for (NSString *key in dataDict) {
        NSDictionary *datadict = dataDict[key];
        NSString *timeStr = datadict[@"timestr"];
        [msgTimeArr addObject:timeStr];
    }
    NSArray *resultArr = [self quickSortWithArr:[msgTimeArr copy]];
    if (resultArr.count>50) {
        int target = [AWTools getTimerCont:resultArr[45]];
        NSMutableArray *msgIDArr = [NSMutableArray array];
        for (NSString *key in dataDict) {
            NSDictionary *datadict = dataDict[key];
            NSString *timeStr = datadict[@"timestr"];
            if ([AWTools getTimerCont:timeStr]>target) {
                [msgIDArr addObject:key];
            }
        }
        
        if (msgIDArr.count>0) {
            [AWSocketLocalDataManager removeMsgArr:msgIDArr datadict:dataDict];
        }
        
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self resendData];
    });
    
    
}

//快排
-(NSArray *)quickSortWithArr:(NSArray *)inputArr
{
    if (inputArr.count<=1) {
        return inputArr;
    }
    NSMutableArray *bigarr = [NSMutableArray array];
    NSMutableArray *middleArr = [NSMutableArray array];
    NSMutableArray *smallArr = [NSMutableArray array];
    int target = [inputArr[0] intValue];
    for (NSString *timestr in inputArr) {
        if ([timestr intValue]>target) {
            [bigarr addObject:timestr];
        }else if ([timestr intValue]==target){
            [middleArr addObject:timestr];
        }else{
            [smallArr addObject:timestr];
        }
    }
    NSMutableArray *resultArr = [NSMutableArray array];
    resultArr = [self appendArrWithresultArr:resultArr appendArr:[self quickSortWithArr:smallArr]];
    resultArr = [self appendArrWithresultArr:resultArr appendArr:[self quickSortWithArr:middleArr]];
    resultArr = [self appendArrWithresultArr:resultArr appendArr:[self quickSortWithArr:bigarr]];
    return [resultArr copy];
}

-(NSMutableArray *)appendArrWithresultArr:(NSMutableArray *)resultArr appendArr:(NSArray *)appendArr
{
    if (appendArr.count<1) {
        return resultArr;
    }
    for (NSString *item in appendArr) {
        [resultArr addObject:item];
    }
    return resultArr;
}


-(void)disConnect
{
    [_socket disconnect];
}

-(void)heartBeat
{
    ByteBuffer *buffer = [ByteBuffer initWithOrder:ByteOrderBigEndian];
    int header = 0;

    [buffer putShort:100];
    [buffer putInt:header];
    [buffer putInt:0];
    [buffer putInt:0];
    
    NSData *resultData = [buffer convertNSData];
    Byte *bytenew = (Byte *)[resultData bytes];
    NSInteger length = [resultData length] /sizeof(uint8_t);
    NSMutableArray *intArr = [NSMutableArray array];
    for (int i=0; i<length; i++) {
        [intArr addObject:[NSString stringWithFormat:@"%d",bytenew[i]]];
    }
//    NSLog(@"%@",intArr);
    
    [_socket writeData:resultData withTimeout:10 tag:100];
}

#pragma mark - Socket代理方法
// 连接成功
- (void)socket:(GCDAsyncSocket *)sock
didConnectToHost:(NSString *)host
          port:(uint16_t)port {
    NSLog(@"%s",__func__);
    NSLog(@"连接成功");
    [self sendToken];
    [self resendData];
}


// 断开连接
- (void)socketDidDisconnect:(GCDAsyncSocket *)sock
                  withError:(NSError *)err {
    if (err) {
//        NSLog(@"连接失败");
        
    } else {
        NSLog(@"正常断开");
    }
    [self reConnect];
}

-(void)reConnect
{
    NSString *host = [AWSDKConfigManager shareinstance].tcp_host;
    NSString *port = [AWSDKConfigManager shareinstance].tcp_port;
    int intport = [port intValue];
    [self connectWithHost:host andport:intport];
    
}


//重连 发token
-(void)sendToken
{
    NSString *token = [AWUserInfoManager shareinstance].token;
    NSString *userid = [AWUserInfoManager shareinstance].account;
    if (token&&userid&&[AWUserInfoManager shareinstance].LoginStatus) {
        NSDictionary *dict = @{@"token":token,@"userid":userid};
        NSString *jsonStr = [AWTools dicttojsonWithdict:dict];
        [[AWSocket shareInstance] sendDataWithMsg:jsonStr type:201 msgID:999 iszip:YES isfirst:YES];
    }
    
}


// 发送数据
- (void)socket:(GCDAsyncSocket *)sock
didWriteDataWithTag:(long)tag {
    
    NSLog(@"%s",__func__);
    
    //发送完数据手动读取，-1不设置超时
    [sock readDataWithTimeout:-1
                          tag:tag];
}

// 读取数据
-(void)socket:(GCDAsyncSocket *)sock
  didReadData:(NSData *)data
      withTag:(long)tag {
    
    Byte *bytenew = (Byte *)[data bytes];
    NSInteger length = [data length] /sizeof(uint8_t);
    NSMutableArray *intArr = [NSMutableArray array];
    for (int i=0; i<length; i++) {
        [intArr addObject:[NSString stringWithFormat:@"%d",bytenew[i]]];
    }
//    NSLog(@"read %@",intArr);
    [self analyticDataWithData:data];
    [sock readDataWithTimeout:-1 tag:tag];
}
//解析数据
-(void)analyticDataWithData:(NSData *)resultdata
{
    Byte *bytenew = (Byte *)[resultdata bytes];
    NSInteger length = [resultdata length] /sizeof(uint8_t);
    NSMutableArray *intArr = [NSMutableArray array];
    for (int i=0; i<length; i++) {
//        NSLog(@"%d",bytenew[i]);
        [intArr addObject:[NSString stringWithFormat:@"%d",bytenew[i]]];
    }

    
    NSArray *cmdarr = [intArr subarrayWithRange:NSMakeRange(0, 2)];
    int type = [self getnumWithArr:cmdarr];
    if (type == 100) {
        return;
    }
    NSLog(@"read%@",intArr);
    NSArray *datatypeArr = [intArr subarrayWithRange:NSMakeRange(2, 4)];
    int gzip = [datatypeArr[3] intValue];
    
    NSArray *msgidArr = [intArr subarrayWithRange:NSMakeRange(6, 4)];
    int msgID = [self getnumWithArr:msgidArr];
    
    if (type==202 || type==203 || type==208)
    {
        [AWSocketLocalDataManager removeDataWithID:msgID];
    }
    
    
    NSArray *lengthArr = [intArr subarrayWithRange:NSMakeRange(10, 4)];  //body长度
    NSLog(@"lengthArr = %@",lengthArr);
    int bodyLength = [self getnumWithArr:lengthArr];

    if (type != 205 && type != 207) {
        return;
    }
    
    NSLog(@"bodyLength===%d",bodyLength);
    NSData *data = [resultdata subdataWithRange:NSMakeRange(14, bodyLength)];
    if (gzip == 18) {
        data = [self gzipInflate:data];
    }
    
    NSString * str  =[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    if (type == 207) {
        [AWGlobalDataManage shareinstance].gameResultDataBlock(str);
    }else if (type == 205){
        [AWGlobalDataManage shareinstance].userResultDataBlock(str);
    }
    NSDictionary *dict = [AWTools jsonStrtodictWithStr:str];
//    NSLog(@"dict = %@",dict);
//    NSLog(@"resultStr = %@",str);
}

//传入字节arr  返回int值
-(int)getnumWithArr:(NSArray *)arr
{
    int numx = 0;
    for (int i =0; i<arr.count; i++) {
        int num = [arr[i] intValue];
        int result = pow(256, (int)arr.count-1-i) * num;
        NSLog(@"result===%d, ==i===%d,num==%d",result,i,num);
        numx += result;
    }
    return numx;
}

//压缩
- (NSData *)gzipDeflate:(NSString*)str
{
    NSData * data = [str dataUsingEncoding:NSUTF8StringEncoding];
    if ([data length] == 0) return data;
    
    z_stream strm;
    
    strm.zalloc = Z_NULL;
    strm.zfree = Z_NULL;
    strm.opaque = Z_NULL;
    strm.total_out = 0;
    strm.next_in=(Bytef *)[data bytes];
    strm.avail_in = [data length];
    
    // Compresssion Levels:
    //   Z_NO_COMPRESSION
    //   Z_BEST_SPEED
    //   Z_BEST_COMPRESSION
    //   Z_DEFAULT_COMPRESSION
    
    if (deflateInit2(&strm, Z_DEFAULT_COMPRESSION, Z_DEFLATED, (15+16), 8, Z_DEFAULT_STRATEGY) != Z_OK) return nil;
    
    NSMutableData *compressed = [NSMutableData dataWithLength:16384];  // 16K chunks for expansion
    
    do {
        
        if (strm.total_out >= [compressed length])
            [compressed increaseLengthBy: 16384];
        
        strm.next_out = [compressed mutableBytes] + strm.total_out;
        strm.avail_out = [compressed length] - strm.total_out;
        
        deflate(&strm, Z_FINISH);
        
    } while (strm.avail_out == 0);
    
    deflateEnd(&strm);
    
    [compressed setLength: strm.total_out];
    return [NSData dataWithData:compressed];
}

//解压缩
- (NSData *)gzipInflate:(NSData*)data
{
    if ([data length] == 0) return data;
    
    unsigned full_length = [data length];
    unsigned half_length = [data length] / 2;
    
    NSMutableData *decompressed = [NSMutableData dataWithLength: full_length + half_length];
    BOOL done = NO;
    int status;
    
    z_stream strm;
    strm.next_in = (Bytef *)[data bytes];
    strm.avail_in = [data length];
    strm.total_out = 0;
    strm.zalloc = Z_NULL;
    strm.zfree = Z_NULL;
    
    if (inflateInit2(&strm, (15+32)) != Z_OK)
        return nil;
    
    while (!done)
    {
        // Make sure we have enough room and reset the lengths.
        if (strm.total_out >= [decompressed length])
            [decompressed increaseLengthBy: half_length];
        strm.next_out = [decompressed mutableBytes] + strm.total_out;
        strm.avail_out = [decompressed length] - strm.total_out;
        
        // Inflate another chunk.
        status = inflate (&strm, Z_SYNC_FLUSH);
        if (status == Z_STREAM_END)
            done = YES;
        else if (status != Z_OK)
            break;
    }
    if (inflateEnd (&strm) != Z_OK)
        return nil;
    
    // Set real length.
    if (done)
    {
        [decompressed setLength: strm.total_out];
        return [NSData dataWithData: decompressed];
    }
    else return nil;
}

@end
