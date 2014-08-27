//
//  TTCropOperation.m
//  ImageCropper
//
//  Created by Xiaoxuan Tang on 14-8-27.
//  Copyright (c) 2014年 tietie tech. All rights reserved.
//

#import "TTCropOperation.h"

#import "NSImage+Corp.h"
@import QuartzCore;

@implementation TTCropOperation

- (void) start
{
    [super start];
    
    CIImage* img = [[CIImage alloc] initWithContentsOfURL:self.url];
    
    if (img.extent.size.width > 440)
    {
        CIFilter *resizeFilter = [CIFilter filterWithName:@"CILanczosScaleTransform"];
        [resizeFilter setValue:img forKey:kCIInputImageKey];
        [resizeFilter setValue:[NSNumber numberWithFloat:1.0f] forKey:@"inputAspectRatio"];
        [resizeFilter setValue:[NSNumber numberWithFloat:440 / img.extent.size.width] forKey:@"inputScale"];
        img = [resizeFilter valueForKey:@"outputImage"];
    }

    CGFloat height = img.extent.size.height;
    CGFloat width = img.extent.size.width;
    NSInteger offset = 0;
    
    NSMutableArray* array = [NSMutableArray array];
    while (height-offset > 500) {
        
        [array addObject: [self croppedImageWithOffset:height-offset-500 width:width sourceImage:img]];
        offset += 500;
    }
    
    if (offset != height)
    {
        [array addObject: [self croppedImageWithOffset:height-offset width:width sourceImage:img]];
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
}

- (CIImage*) croppedImageWithOffset:(NSInteger) offset
                              width:(CGFloat) width
                        sourceImage:(CIImage*) image
{
    CIFilter *cropFilter = [CIFilter filterWithName:@"CICrop"];
    CIVector *cropRect = [CIVector vectorWithX:0 Y:offset Z:width W:500];
    [cropFilter setValue:image forKey:@"inputImage"];
    [cropFilter setValue:cropRect forKey:@"inputRectangle"];
    return [cropFilter valueForKey:@"outputImage"];
}

@end