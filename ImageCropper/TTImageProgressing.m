//
//  TTImageProgressing.m
//  ImageCropper
//
//  Created by Xiaoxuan Tang on 14/11/8.
//  Copyright (c) 2014年 tietie tech. All rights reserved.
//

#import "TTImageProgressing.h"
@import QuartzCore;

@implementation TTImageProgressing

+ (CIImage*) croppedImageWithOffset:(NSInteger) offset
                              width:(CGFloat) width
                             height:(CGFloat) height
                        sourceImage:(CIImage*) image
{
    CIFilter *cropFilter = [CIFilter filterWithName:@"CICrop"];
    CIVector *cropRect = [CIVector vectorWithX:0 Y:offset Z:width W:height];
    [cropFilter setValue:image forKey:@"inputImage"];
    [cropFilter setValue:cropRect forKey:@"inputRectangle"];
    return [cropFilter valueForKey:@"outputImage"];
}

+ (CIImage*) resizeImageWithScaleSize:(CGFloat) scale
                               source:(CIImage*) source
{
    CIFilter *resizeFilter = [CIFilter filterWithName:@"CILanczosScaleTransform"];
    [resizeFilter setValue:source forKey:kCIInputImageKey];
    [resizeFilter setValue:[NSNumber numberWithFloat:1.0f] forKey:@"inputAspectRatio"];
    [resizeFilter setValue:[NSNumber numberWithFloat:scale] forKey:@"inputScale"];
    return [resizeFilter valueForKey:@"outputImage"];
}

+ (CIImage*) combineTwoImage:(CIImage*) foreground
                  background:(CIImage*) background
{
    CIFilter* filter = [CIFilter filterWithName:@"CISourceOverCompositing"];
    [filter setValue:foreground forKey:@"inputImage"];
    [filter setValue:background forKey:@"inputBackgroundImage"];
    return [filter valueForKey:@"outputImage"];
}

@end
