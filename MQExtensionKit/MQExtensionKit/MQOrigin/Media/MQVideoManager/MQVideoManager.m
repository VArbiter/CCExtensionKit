//
//  MQVideoManager.m
//  MQExtensionKit
//
//  Created by ElwinFrederick on 21/05/2018.
//  Copyright © 2018 冯明庆. All rights reserved.
//

#import "MQVideoManager.h"

@implementation MQVideoManager

- (void)mq_merge_export_videos : (NSString *) s_path
                   data_stream : (NSArray <MQVideoInfoEntity *> *) array_file_urls {
    
    if (!array_file_urls || !array_file_urls.count) return ;
    
    NSError *error = nil;
    CGSize renderSize = CGSizeMake(0, 0);
    NSMutableArray *layerInstructionArray = [[NSMutableArray alloc] init];
    AVMutableComposition *mixComposition = [[AVMutableComposition alloc] init];
    CMTime totalDuration = kCMTimeZero;
    NSMutableArray *assetTrackArray = [[NSMutableArray alloc] init];
    NSMutableArray *assetArray = [[NSMutableArray alloc] init];
    for (MQVideoInfoEntity *videoInfo in array_file_urls) {
        AVAsset *asset = [AVAsset assetWithURL:videoInfo.url_file_path];
        if (!asset) continue;
        
        [assetArray addObject:asset];
        
        AVAssetTrack *assetTrack = [[asset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0];
        [assetTrackArray addObject:assetTrack];
        
        renderSize.width = MAX(renderSize.width, assetTrack.naturalSize.height);
        renderSize.height = MAX(renderSize.height, assetTrack.naturalSize.width);
    }
    
    CGFloat renderW = MIN(renderSize.width, renderSize.height);
    
    for (int i = 0; i < [assetArray count] && i < [assetTrackArray count]; i++) {
        
        AVAsset *asset = [assetArray objectAtIndex:i];
        AVAssetTrack *assetTrack = [assetTrackArray objectAtIndex:i];
        
        CGFloat floatEndTime = CMTimeGetSeconds(asset.duration);
        CGFloat floatStartTime = .0f;
        CMTime timeStart = CMTimeMakeWithSeconds(floatStartTime, asset.duration.timescale);
        CMTime timeDuration = CMTimeMakeWithSeconds(floatEndTime - floatStartTime, asset.duration.timescale);
        CMTimeRange timeRange = CMTimeRangeMake(timeStart, timeDuration);
        
        AVMutableCompositionTrack *audioTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
        [audioTrack insertTimeRange:timeRange
                            ofTrack:[[asset tracksWithMediaType:AVMediaTypeAudio] objectAtIndex:0]
                             atTime:totalDuration
                              error:nil];
        
        AVMutableCompositionTrack *videoTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
        [videoTrack insertTimeRange:timeRange
                            ofTrack:assetTrack
                             atTime:totalDuration
                              error:&error];
        
        //fix orientationissue
        AVMutableVideoCompositionLayerInstruction *layerInstruciton = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:videoTrack];
        
        totalDuration = CMTimeAdd(totalDuration, timeDuration);
        
        CGFloat rate;
        rate = renderW / MIN(assetTrack.naturalSize.width, assetTrack.naturalSize.height);
        
        CGAffineTransform layerTransform = CGAffineTransformMake(assetTrack.preferredTransform.a, assetTrack.preferredTransform.b, assetTrack.preferredTransform.c, assetTrack.preferredTransform.d, assetTrack.preferredTransform.tx * rate, assetTrack.preferredTransform.ty * rate);
        
        layerTransform = CGAffineTransformConcat(layerTransform, CGAffineTransformMake(1, 0, 0, 1, 0, (assetTrack.naturalSize.width - assetTrack.naturalSize.height) / 2.0));
        layerTransform = CGAffineTransformScale(layerTransform, rate, rate);
        
        [layerInstruciton setTransform:layerTransform atTime:kCMTimeZero];
        [layerInstruciton setOpacity:0.0 atTime:totalDuration];
        
        //data
        [layerInstructionArray addObject:layerInstruciton];
    }

    NSURL *s_merged_url = [NSURL fileURLWithPath:s_path];
    
    //export
    AVMutableVideoCompositionInstruction *mainInstruciton = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
    mainInstruciton.timeRange = CMTimeRangeMake(kCMTimeZero, totalDuration);
    mainInstruciton.layerInstructions = layerInstructionArray;
    AVMutableVideoComposition *mainCompositionInst = [AVMutableVideoComposition videoComposition];
    mainCompositionInst.instructions = @[mainInstruciton];
    mainCompositionInst.frameDuration = CMTimeMake(1, 30);
    mainCompositionInst.renderSize = CGSizeMake(renderW, renderW);
    
    AVAssetExportSession *exporter = [[AVAssetExportSession alloc] initWithAsset:mixComposition presetName:AVAssetExportPresetMediumQuality];
    exporter.videoComposition = mainCompositionInst;
    exporter.outputURL = s_merged_url;
    exporter.outputFileType = AVFileTypeMPEG4;
    exporter.shouldOptimizeForNetworkUse = YES;
    __weak typeof(self) weak_self = self;
    [exporter exportAsynchronouslyWithCompletionHandler:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            __strong typeof(weak_self) strong_self = weak_self;
            if ([strong_self.delegate respondsToSelector:@selector(mq_video_manager:did_finish_with_output_url:)]) {
                [strong_self.delegate mq_video_manager:strong_self did_finish_with_output_url:s_merged_url];
            }
        });
    }];
}

- (void) mq_convert_to_MP4 : (NSURL *) url_file_path
                      path : (NSString *) s_convert_file_path
                  complete : (void(^)(AVAssetExportSessionStatus status , BOOL is_complete)) complete_block {
    AVURLAsset *av_asset = [AVURLAsset URLAssetWithURL:url_file_path options:nil];
    NSArray *compatible_presets = [AVAssetExportSession exportPresetsCompatibleWithAsset:av_asset];
    
    if ([compatible_presets containsObject:AVAssetExportPresetLowQuality]) {
        
        AVAssetExportSession *export_session = [[AVAssetExportSession alloc]initWithAsset:av_asset presetName:AVAssetExportPresetPassthrough];
        NSString *exportPath = s_convert_file_path;
        export_session.outputURL = [NSURL fileURLWithPath:exportPath];
        export_session.outputFileType = AVFileTypeMPEG4;
        __weak typeof(self) weak_self = self;
        [export_session exportAsynchronouslyWithCompletionHandler:^{
            __strong typeof(weak_self) strong_self = weak_self;
            if (complete_block) complete_block([export_session status]
                                               , [export_session status] == AVAssetExportSessionStatusCompleted);
                if (strong_self.delegate
                    && [strong_self.delegate
                        respondsToSelector:@selector(mq_video_manager:status:complete:file_path:)]){
                    [strong_self.delegate mq_video_manager:strong_self
                                                    status:[export_session status]
                                                  complete:[export_session status] == AVAssetExportSessionStatusCompleted
                                                 file_path:s_convert_file_path];
                }
        }];
    }
}

@end
    
@implementation MQVideoInfoEntity

@end
