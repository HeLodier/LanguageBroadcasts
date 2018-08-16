//
//  NotificationService.m
//  SoundTestExtension
//
//  Created by YZJMACMini on 2018/1/15.
//  Copyright © 2018年 Lxh.yzj. All rights reserved.
//

#import "NotificationService.h"
#import <AVFoundation/AVFAudio.h>


@interface NotificationService ()<AVSpeechSynthesizerDelegate>

@property (nonatomic, strong) void (^contentHandler)(UNNotificationContent *contentToDeliver);

@property (nonatomic, strong) UNMutableNotificationContent *attemptContent;

//负责播放
@property (nonatomic, strong) AVSpeechSynthesizer *speech;

@end

@implementation NotificationService

- (void)didReceiveNotificationRequest:(UNNotificationRequest *)request withContentHandler:(void (^)(UNNotificationContent * _Nonnull))contentHandler {
    self.contentHandler = contentHandler;
    self.attemptContent = [request.content mutableCopy];
    
     [self readContent:self.attemptContent.body];
}

- (void)serviceExtensionTimeWillExpire {
    [self stopRead];
    
    self.contentHandler(self.attemptContent);
}



- (void)readContent:(NSString*)str{
    //AVSpeechUtterance: 可以假想成要说的一段话
    AVSpeechUtterance * aVSpeechUtterance = [[AVSpeechUtterance alloc] initWithString:str];
    
    aVSpeechUtterance.rate = AVSpeechUtteranceDefaultSpeechRate;
    
    //AVSpeechSynthesisVoice: 可以假想成人的声音
    aVSpeechUtterance.voice =[AVSpeechSynthesisVoice voiceWithLanguage:@"zh-CN"];
    
    //发音
    [self.aVSpeechSynthesizer speakUtterance:aVSpeechUtterance];
    
}
- (void)stopRead{
    
    [self.aVSpeechSynthesizer stopSpeakingAtBoundary:AVSpeechBoundaryImmediate];
    
}

- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer didFinishSpeechUtterance:(AVSpeechUtterance *)utterance;{
    
    NSLog(@"阅读完毕");
    self.contentHandler(self.attemptContent);
}


- (AVSpeechSynthesizer *)aVSpeechSynthesizer{
    if (!_speech) {
        _speech = [[AVSpeechSynthesizer alloc] init];
        _speech.delegate = self;
    }
    return _speech;
}

@end
