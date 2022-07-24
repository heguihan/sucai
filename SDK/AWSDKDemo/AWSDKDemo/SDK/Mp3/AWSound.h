//
//  Sound.h
//  testFunctionMp3
//
//  Created by admin on 2020/12/22.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
NS_ASSUME_NONNULL_BEGIN
static AVAudioPlayer* staticAudioPlayer;
@interface AWSound : NSObject
{
    AVAudioSession* _audioSession;
}

+(instancetype)sharedInstance;

-(void)playWithName:(NSString *)name;

-(void)stop;

@end

NS_ASSUME_NONNULL_END
