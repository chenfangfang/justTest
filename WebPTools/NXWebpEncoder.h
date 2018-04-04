//
//  NXWebpEncoder.h
//  WebPTools
//
//  Created by 陈方方 on 2017/10/24.
//  Copyright © 2017年 chen. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef NS_ENUM(NSUInteger, YYImagePreset) {
    YYImagePresetDefault = 0,  ///< default preset.
    YYImagePresetPicture,      ///< digital picture, like portrait, inner shot
    YYImagePresetPhoto,        ///< outdoor photograph, with natural lighting
    YYImagePresetDrawing,      ///< hand or line drawing, with high-contrast details
    YYImagePresetIcon,         ///< small-sized colorful images
    YYImagePresetText          ///< text-like
};


@interface NXWebpEncoder : NSObject


@property (nonatomic) float quality;

@property (nonatomic) int loopCount;

@property (nonatomic,strong) NSMutableArray * imageArray;

//每一帧的时间
@property (nonatomic) NSMutableArray * durationArray;

- (NSData *)encodeWebP;

@end
