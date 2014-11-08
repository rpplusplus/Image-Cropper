//
//  TTCropOperation.m
//  ImageCropper
//
//  Created by Xiaoxuan Tang on 14-8-27.
//  Copyright (c) 2014年 tietie tech. All rights reserved.
//

#import "TTCropOperation.h"
#import "NSImage+Corp.h"
#import "NSImage+CIImage.h"
#import "CIImage+NSImage.h"
#import "TTImageProgressing.h"
#import "TTCropTaskViewController.h"

@import QuartzCore;

@interface TTCropOperation ()
{
    BOOL fin;
}

@end

@implementation TTCropOperation

- (BOOL) isAsynchronous
{
    return NO;
}

- (BOOL) isFinished
{
    return fin;
}

- (void) start
{
    @autoreleasepool {
        [super start];
        
        fin = NO;
        
        if (!_vc || !_url || !_watermarkImage) return;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.vc updateStatus:1
                        withIndex:_index];
        });
        
        NSImage* sourceImage = [[NSImage alloc] initWithContentsOfURL:self.url];
        
        NSImageRep* rep = (NSImageRep*)([sourceImage representations][0]);
        NSSize sourceImagePixelSize = NSMakeSize([rep pixelsWide], [rep pixelsHigh]);
                                        
        CGFloat sourceImageWidth = sourceImagePixelSize.width;
        [sourceImage setSize:sourceImagePixelSize];
        CGFloat watermarkWidth = sourceImageWidth / 4;
        
        CIImage* watermarkCIImage = [_watermarkImage CIImage];
        
        if (watermarkWidth < watermarkCIImage.extent.size.width)
        {
            CIImage* ci = [TTImageProgressing resizeImageWithScaleSize:watermarkWidth / watermarkCIImage.extent.size.width
                                                                source:watermarkCIImage];
            _watermarkImage = [ci NSImage];
        }
        
        [sourceImage lockFocus];
        
        [_watermarkImage drawAtPoint:CGPointMake(sourceImageWidth - watermarkWidth - 30, 30)
                            fromRect:CGRectZero
                           operation:NSCompositeSourceOver
                            fraction:1.0];
        
        [sourceImage unlockFocus];
        
        CIImage* img = [sourceImage CIImage];
        
        if (img.extent.size.width > sourceImageWidth)
        {
            img = [TTImageProgressing resizeImageWithScaleSize:sourceImageWidth / img.extent.size.width
                                                        source:img];
        }
        
        if (sourceImageWidth > _imageWidth)
        {
            
            img = [TTImageProgressing resizeImageWithScaleSize:_imageWidth / sourceImageWidth
                                                        source:img];
        }
        
        CGFloat height = img.extent.size.height;
        CGFloat width = img.extent.size.width;
        NSInteger offset = 0;
        
        NSMutableArray* array = [NSMutableArray array];
        while (height-offset > 500) {
            
            [array addObject: [TTImageProgressing croppedImageWithOffset:height-offset-500
                                                                   width:width
                                                                  height:500
                                                             sourceImage:img]];
            offset += 500;
        }
        
        if (offset != height)
        {
            [array addObject: [TTImageProgressing croppedImageWithOffset:0
                                                                   width:width
                                                                  height:height-offset
                                                             sourceImage:img]];
        }
        
        NSString* str = [_url relativePath];
        
        [[NSFileManager defaultManager] createDirectoryAtPath:str.stringByDeletingPathExtension
                                  withIntermediateDirectories:YES
                                                   attributes:nil
                                                        error:nil];
        
        NSInteger cnt = 0;
        
        for (CIImage* image in array) {
            NSBitmapImageRep* rep = [[NSBitmapImageRep alloc] initWithCIImage:image];
            NSData* PNGData = [rep representationUsingType:NSJPEGFileType properties:@{NSImageCompressionFactor:@(.5)}];
            [PNGData writeToFile:[NSString stringWithFormat:@"%@/%.2ld_%@", [str stringByDeletingPathExtension], (long)++cnt, str.lastPathComponent] atomically:NO];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.vc updateStatus:2
                        withIndex:_index];
        });
        
        [self willChangeValueForKey:@"isFinished"];
        fin = YES;
        [self didChangeValueForKey:@"isFinished"];
    }
}

@end