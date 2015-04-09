//
//  SunsetAudioTapProcessor.m
//  UsetCoreImage
//
//  Created by Alex Chan on 15/4/7.
//  Copyright (c) 2015年 Alex Chan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>



#import "SunsetAudioTapProcessor.h"


// MTAudioProcessingTap callbacks.
static void tap_InitCallback(MTAudioProcessingTapRef tap, void *clientInfo, void **tapStorageOut);
static void tap_FinalizeCallback(MTAudioProcessingTapRef tap);
static void tap_PrepareCallback(MTAudioProcessingTapRef tap, CMItemCount maxFrames, const AudioStreamBasicDescription *processingFormat);
static void tap_UnprepareCallback(MTAudioProcessingTapRef tap);
static void tap_ProcessCallback(MTAudioProcessingTapRef tap, CMItemCount numberFrames, MTAudioProcessingTapFlags flags, AudioBufferList *bufferListInOut, CMItemCount *numberFramesOut, MTAudioProcessingTapFlags *flagsOut);

// Audio Unit callbacks.
static OSStatus AU_RenderCallback(void *inRefCon, AudioUnitRenderActionFlags *ioActionFlags, const AudioTimeStamp *inTimeStamp, UInt32 inBusNumber, UInt32 inNumberFrames, AudioBufferList *ioData);

@interface SunsetAudioTapProcessor ()
{
    AVAudioMix *_audioMix;
}
@end

@implementation SunsetAudioTapProcessor

//@synthesize asbd = _asbd ;
//@synthesize sampleRate;

- (id)initWithAudioAssetTrack:(AVAssetTrack *)audioAssetTrack
{
    NSParameterAssert(audioAssetTrack && [audioAssetTrack.mediaType isEqualToString:AVMediaTypeAudio]);
    
    self = [super init];
    
    if (self)
    {
        _audioAssetTrack = audioAssetTrack;

    }
    
    return self;
}

#pragma mark - Properties



- (AVAudioMix *)audioMix
{
    if (!_audioMix)
    {
        AVMutableAudioMix *audioMix = [AVMutableAudioMix audioMix];
        if (audioMix)
        {
            AVMutableAudioMixInputParameters *audioMixInputParameters = [AVMutableAudioMixInputParameters audioMixInputParametersWithTrack:self.audioAssetTrack];
            if (audioMixInputParameters)
            {
                MTAudioProcessingTapCallbacks callbacks;
                
                callbacks.version = kMTAudioProcessingTapCallbacksVersion_0;
                callbacks.clientInfo = (__bridge void *)self,
                callbacks.init = tap_InitCallback;
                callbacks.finalize = tap_FinalizeCallback;
                callbacks.prepare = tap_PrepareCallback;
                callbacks.unprepare = tap_UnprepareCallback;
                callbacks.process = tap_ProcessCallback;
                
                MTAudioProcessingTapRef audioProcessingTap;
                if (noErr == MTAudioProcessingTapCreate(kCFAllocatorDefault, &callbacks, kMTAudioProcessingTapCreationFlag_PreEffects, &audioProcessingTap))
                {
                    audioMixInputParameters.audioTapProcessor = audioProcessingTap;
                    
                    CFRelease(audioProcessingTap);
                    
                    audioMix.inputParameters = @[audioMixInputParameters];
                    
                    _audioMix = audioMix;
                }
            }
        }
    }
    
    return _audioMix;
}





#pragma mark -
- (void) checkOSStatus: (OSStatus)status{
    if( status != noErr){
        NSLog(@"OSStatus Error:%d", status);
    }
    
    
    
}

//-(OSStatus) recordingCallbackWithRef:(void*)inRefCon
//                               flags:(AudioUnitRenderActionFlags*)flags
//                           timeStamp:(const AudioTimeStamp*)timeStamp
//                           busNumber:(UInt32)busNumber
//                        framesNumber:(UInt32)numberOfFrames
//                                data:(AudioBufferList*)data
//{
//    
//    AudioBufferList bufferList;
//    bufferList.mNumberBuffers = 1;
//    bufferList.mBuffers[0].mData = NULL;
//    
//    OSStatus status;
//    
//    
//    status = AudioUnitRender(kAudioUnitType_Output,
//                             flags,
//                             timeStamp,
//                             busNumber,
//                             numberOfFrames,
//                             &bufferList);
//    [self checkOSStatus:status];
//    
//    AudioStreamBasicDescription audioFormat;
//    // Describe format
//    audioFormat.mSampleRate         = 44100.00;
//    audioFormat.mFormatID           = kAudioFormatLinearPCM;
//    audioFormat.mFormatFlags        = kAudioFormatFlagIsSignedInteger | kAudioFormatFlagIsPacked;
//    audioFormat.mFramesPerPacket    = 1;
//    audioFormat.mChannelsPerFrame   = 1;
//    audioFormat.mBitsPerChannel     = 16;
//    audioFormat.mBytesPerPacket     = 2;
//    audioFormat.mBytesPerFrame      = 2;
//    
//    CMSampleBufferRef buff = NULL;
//    CMFormatDescriptionRef format = NULL;
//    CMSampleTimingInfo timing = { CMTimeMake(1, 44100), kCMTimeZero, kCMTimeInvalid };
//    
//    status = CMAudioFormatDescriptionCreate(kCFAllocatorDefault, &audioFormat, 0, NULL, 0, NULL, NULL, &format);
//    [self checkOSStatus:status];
//    
//    status = CMSampleBufferCreate(kCFAllocatorDefault,NULL,false,NULL,NULL,format,1, 1, &timing, 0, NULL, &buff);
//    [self checkOSStatus:status];
//    
//    status = CMSampleBufferSetDataBufferFromAudioBufferList(buff,
//                                                            kCFAllocatorDefault,
//                                                            kCFAllocatorDefault,
//                                                            0,
//                                                            &bufferList);
//    
//    [self checkOSStatus:status]; //Status here is 12731
//    
//    //Do something with the buffer
//    
//    return noErr;
//}


@end

#pragma mark - MTAudioProcessingTap Callbacks

static void tap_InitCallback(MTAudioProcessingTapRef tap, void *clientInfo, void **tapStorageOut)
{
	*tapStorageOut = clientInfo;
}

static void tap_FinalizeCallback(MTAudioProcessingTapRef tap)
{
    
}

static void tap_PrepareCallback(MTAudioProcessingTapRef tap, CMItemCount maxFrames, const AudioStreamBasicDescription *processingFormat)
{

    NSLog(@"maxFrames:%ld",maxFrames);
    NSLog(@"mSampleRate:%f",processingFormat->mSampleRate);
    NSLog(@"mFormatID:%u",(unsigned int)processingFormat->mFormatID);
    NSLog(@"mFormatFlags:%u", (unsigned int)processingFormat->mFormatFlags);
    NSLog(@"mBytesPerPacket:%u", (unsigned int)processingFormat->mBytesPerPacket);
    NSLog(@"mFramesPerPacket:%u", (unsigned int)processingFormat->mFramesPerPacket);
    NSLog(@"mBytesPerFrame:%u", (unsigned int)processingFormat->mBytesPerFrame);
    NSLog(@"mChannelsPerFrame:%u", (unsigned int)processingFormat->mChannelsPerFrame);
    NSLog(@"mReserved:%u", (unsigned int)processingFormat->mReserved);
    
    
    SunsetAudioTapProcessor *self = (__bridge SunsetAudioTapProcessor *)MTAudioProcessingTapGetStorage(tap);
    
    
//    self->_asbd =  processingFormat;
//    [self setAsbd:processingFormat];
    self.asbd = processingFormat;
    NSLog(@"SampleRate:%f", self.asbd->mSampleRate);
    self.mSampleRate = processingFormat->mSampleRate;
    self.mFormatID = processingFormat->mFormatID;
    self.mFormatFlags = processingFormat->mFormatFlags;
    self.mBytesPerPacket = processingFormat->mBytesPerPacket;
    self.mFramesPerPacket = processingFormat->mFramesPerPacket;
    self.mBytesPerFrame = processingFormat->mBytesPerFrame;
    self.mChannelsPerFrame = processingFormat->mChannelsPerFrame;
    self.mReserved = processingFormat->mReserved;
    self.mBitsPerChannel = processingFormat->mBitsPerChannel;
    
    
    
//    @autoreleasepool
//    {
//        dispatch_async(dispatch_get_main_queue(), ^{
//            // Forward left and right channel volume to delegate.
//            if (self.delegate && [self.delegate respondsToSelector:@selector(audioTapPrepare:maxFrames:asbd:)])
//
//            [self.delegate audioTapPrepare: self maxFrames:maxFrames asbd:processingFormat];
//
//            
//        });
//    }
    
}

static void tap_UnprepareCallback(MTAudioProcessingTapRef tap)
{

}




static void tap_ProcessCallback(MTAudioProcessingTapRef tap, CMItemCount numberFrames, MTAudioProcessingTapFlags flags, AudioBufferList *bufferListInOut, CMItemCount *numberFramesOut, MTAudioProcessingTapFlags *flagsOut)
{

    
//    AVAudioTapProcessorContext *context = (AVAudioTapProcessorContext *)MTAudioProcessingTapGetStorage(tap);
//    SunsetAudioTapProcessor *self = ((__bridge SunsetAudioTapProcessor *)context->self);
    
    SunsetAudioTapProcessor *self = (__bridge SunsetAudioTapProcessor *)MTAudioProcessingTapGetStorage(tap);


    AudioStreamBasicDescription asbd;
    asbd.mSampleRate = self.mSampleRate;
    asbd.mFormatID = self.mFormatID;
    asbd.mFormatFlags = self.mFormatFlags;
    asbd.mBytesPerPacket = self.mBytesPerPacket;
    asbd.mFramesPerPacket = self.mFramesPerPacket;
    asbd.mBytesPerFrame = self.mBytesPerFrame;
    asbd.mChannelsPerFrame = self.mChannelsPerFrame;
    asbd.mReserved = self.mReserved;
    asbd.mBitsPerChannel = self.mBitsPerChannel;
    
    OSStatus status;
    
    // Get actual audio buffers from MTAudioProcessingTap (AudioUnitRender() will fill bufferListInOut otherwise).
    status = MTAudioProcessingTapGetSourceAudio(tap, numberFrames, bufferListInOut, flagsOut, NULL, numberFramesOut);
    if (noErr != status)
    {
        NSLog(@"MTAudioProcessingTapGetSourceAudio: %d", (int)status);
        return;
    }
    
//    NSLog(@"processing numberFrames:%d", numberFrames);
    
    
    CMSampleBufferRef buff = NULL;
    CMFormatDescriptionRef format = NULL;
    CMSampleTimingInfo timing = { CMTimeMake(1, 44100), kCMTimeZero, kCMTimeInvalid };
    
    status = CMAudioFormatDescriptionCreate(kCFAllocatorDefault, &asbd, 0, NULL, 0, NULL, NULL, &format);
    [self checkOSStatus:status];
    
    status = CMSampleBufferCreate(kCFAllocatorDefault,NULL,false,NULL,NULL,format,numberFrames, 1, &timing, 0, NULL, &buff);
    [self checkOSStatus:status];
    
//    NSLog(@"numberFrames:%ld", (CMItemCount)numberFrames);
    status = CMSampleBufferSetDataBufferFromAudioBufferList(buff,
                                                            kCFAllocatorDefault,
                                                            kCFAllocatorDefault,
                                                            0,
                                                            bufferListInOut);
    NSLog(@"step3");
    [self checkOSStatus:status];
    
    @autoreleasepool
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            // Forward left and right channel volume to delegate.
            if (self.delegate && [self.delegate respondsToSelector:@selector(audioTapProcessor:sampleBuffer:)]){
                
                [self.delegate audioTapProcessor:self sampleBuffer:buff];
            }
            
            

        });
    }
}

#pragma mark - Audio Unit Callbacks

//OSStatus AU_RenderCallback(void *inRefCon, AudioUnitRenderActionFlags *ioActionFlags, const AudioTimeStamp *inTimeStamp, UInt32 inBusNumber, UInt32 inNumberFrames, AudioBufferList *ioData)
//{
//    // Just return audio buffers from MTAudioProcessingTap.
//    return MTAudioProcessingTapGetSourceAudio(inRefCon, inNumberFrames, ioData, NULL, NULL, NULL);
//}
