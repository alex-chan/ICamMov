//
//  SunsetAudioTapProcessor.h
//  UsetCoreImage
//
//  Created by Alex Chan on 15/4/7.
//  Copyright (c) 2015年 Alex Chan. All rights reserved.
//

#ifndef UsetCoreImage_SunsetAudioTapProcessor_h
#define UsetCoreImage_SunsetAudioTapProcessor_h

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

// http://stackoverflow.com/questions/25514176/using-swift-cfunctionpointer-to-pass-a-callback-to-coremidi-api

@class AVAudioMix;
@class AVAssetTrack;

@protocol SunsetAudioTapProcessorDelegate;

@interface SunsetAudioTapProcessor : NSObject

// Designated initializer.
- (id)initWithAudioAssetTrack:(AVAssetTrack *)audioAssetTrack;

// Properties
@property (readonly, nonatomic) AVAssetTrack *audioAssetTrack;
@property (readonly, nonatomic) AVAudioMix *audioMix;
@property (atomic) const AudioStreamBasicDescription *asbd;
@property (nonatomic) Float64 mSampleRate;
@property (nonatomic) AudioFormatID       mFormatID;
@property (nonatomic) AudioFormatFlags    mFormatFlags;
@property (nonatomic) UInt32              mBytesPerPacket;
@property (nonatomic) UInt32              mFramesPerPacket;
@property (nonatomic) UInt32              mBytesPerFrame;
@property (nonatomic) UInt32              mChannelsPerFrame;
@property (nonatomic) UInt32              mBitsPerChannel;
@property (nonatomic) UInt32              mReserved;
@property (weak, nonatomic) id <SunsetAudioTapProcessorDelegate> delegate;


@end

#pragma mark - Protocols

@protocol SunsetAudioTapProcessorDelegate <NSObject>

//- (void) audioTapPrepare: (SunsetAudioTapProcessor*) audioTapProcessor maxFrames:(CMItemCount)maxFrames asbd:(const AudioStreamBasicDescription*)asbd;
//
//- (void) audioTapProcessor:(SunsetAudioTapProcessor *) audioTapProcessor audioData:(AudioBufferList *)bufferList framesNumber:(UInt32)framesNumber;
- (void) audioTapProcessor:(SunsetAudioTapProcessor *)audioTapProcessor sampleBuffer: (CMSampleBufferRef)sampleBuffer;
// Add comment…
//- (void)audioTabProcessor:(SunsetAudioTapProcessor *)audioTabProcessor hasNewLeftChannelValue:(float)leftChannelValue rightChannelValue:(float)rightChannelValue;

@end


#endif
