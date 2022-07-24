//
//  Sound.m
//  testFunctionMp3
//
//  Created by admin on 2020/12/22.
//

#import "AWSound.h"
@interface AWSound()<AVAudioPlayerDelegate>

@end

@implementation AWSound


+(instancetype)sharedInstance{
    static AWSound *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
        [instance configMp3];
    });
    return instance;
}

-(void)configMp3
{
    _audioSession = [AVAudioSession sharedInstance];
    [_audioSession setCategory:AVAudioSessionCategoryPlayback withOptions:AVAudioSessionCategoryOptionMixWithOthers error:nil];
    [_audioSession setActive:YES error:nil];
    
}

-(void)playWithName:(NSString *)name{
    NSString *filePath = [NSString stringWithFormat:@"%@/%@",@"AWSDK.bundle",name];
    NSURL* url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:filePath ofType:@"mp3"]];
    if(!staticAudioPlayer){
        staticAudioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
        [staticAudioPlayer prepareToPlay];
        staticAudioPlayer.delegate = self;
    }
    staticAudioPlayer.volume = 10;
    if (!staticAudioPlayer.isPlaying) {
        [staticAudioPlayer play];
    }
}

-(void)stop{
    staticAudioPlayer.currentTime = 0;
    [staticAudioPlayer stop];
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    staticAudioPlayer = nil;
}

@end
