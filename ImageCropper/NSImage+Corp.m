//
//  NSImage+Corp.m
//  ImageCropper
//
//  Created by Xiaoxuan Tang on 14-8-25.
//  Copyright (c) 2014年 tietie tech. All rights reserved.
//

#import "NSImage+Corp.h"

@implementation NSImage (Corp)

- (void)tt_drawInRect:(NSRect)dstRect
            operation:(NSCompositingOperation)op
             fraction:(float)delta
               method:(MGImageResizingMethod)resizeMethod
{
	float sourceWidth = [self size].width;
    float sourceHeight = [self size].height;
    float targetWidth = dstRect.size.width;
    float targetHeight = dstRect.size.height;
    BOOL cropping = !(resizeMethod == MGImageResizeScale);
    
    // Calculate aspect ratios
    float sourceRatio = sourceWidth / sourceHeight;
    float targetRatio = targetWidth / targetHeight;
    
    // Determine what side of the source image to use for proportional scaling
    BOOL scaleWidth = (sourceRatio <= targetRatio);
    // Deal with the case of just scaling proportionally to fit, without cropping
    scaleWidth = (cropping) ? scaleWidth : !scaleWidth;
    
    // Proportionally scale source image
    float scalingFactor, scaledWidth, scaledHeight;
    if (scaleWidth) {
        scalingFactor = 1.0 / sourceRatio;
        scaledWidth = targetWidth;
        scaledHeight = round(targetWidth * scalingFactor);
    } else {
        scalingFactor = sourceRatio;
        scaledWidth = round(targetHeight * scalingFactor);
        scaledHeight = targetHeight;
    }
    float scaleFactor = scaledHeight / sourceHeight;
    
    // Calculate compositing rectangles
    NSRect sourceRect;
    if (cropping) {
        float destX, destY;
        if (resizeMethod == MGImageResizeCrop) {
            // Crop center
            destX = round((scaledWidth - targetWidth) / 2.0);
            destY = round((scaledHeight - targetHeight) / 2.0);
        } else if (resizeMethod == MGImageResizeCropStart) {
            // Crop top or left (prefer top)
            if (scaleWidth) {
				// Crop top
				destX = round((scaledWidth - targetWidth) / 2.0);
				destY = round(scaledHeight - targetHeight);
            } else {
				// Crop left
                destX = 0.0;
				destY = round((scaledHeight - targetHeight) / 2.0);
            }
        } else if (resizeMethod == MGImageResizeCropEnd) {
            // Crop bottom or right
            if (scaleWidth) {
				// Crop bottom
				destX = 0.0;
				destY = 0.0;
            } else {
				// Crop right
				destX = round(scaledWidth - targetWidth);
				destY = round((scaledHeight - targetHeight) / 2.0);
            }
        }
        sourceRect = NSMakeRect(destX / scaleFactor, destY / scaleFactor,
                                targetWidth / scaleFactor, targetHeight / scaleFactor);
    } else {
        sourceRect = NSMakeRect(0, 0, sourceWidth, sourceHeight);
		dstRect.origin.x += (targetWidth - scaledWidth) / 2.0;
		dstRect.origin.y += (targetHeight - scaledHeight) / 2.0;
		dstRect.size.width = scaledWidth;
		dstRect.size.height = scaledHeight;
    }
    
    [self drawInRect:dstRect fromRect:sourceRect operation:op fraction:delta];
}

- (NSImage *) tt_imageToFitSize:(NSSize)size
                         method:(MGImageResizingMethod)resizeMethod
{
    NSImage *result = [[NSImage alloc] initWithSize:size];
    
    // Composite image appropriately
    [result lockFocus];
    [[NSGraphicsContext currentContext] setImageInterpolation:NSImageInterpolationHigh];
	[self tt_drawInRect:NSMakeRect(0,0,size.width,size.height)
              operation:NSCompositeSourceOver
               fraction:1.0
                 method:resizeMethod];
    [result unlockFocus];
    
    return result;
}

- (NSImage *) tt_imageCroppedToFitSize:(NSSize)size
{
    return [self tt_imageToFitSize:size method:MGImageResizeCrop];
}

- (NSImage *) tt_imageScaledToFitSize:(NSSize)size
{
    return [self tt_imageToFitSize:size method:MGImageResizeScale];
}

- (NSImage *) tt_imageCroppedInRect:(NSRect)srcRect {
    NSImage *result = [[NSImage alloc] initWithSize:srcRect.size];
    NSRect dstRect = NSMakeRect(0.0, 0.0, srcRect.size.width, srcRect.size.height);
	
    [result lockFocus];
	//[result lockFocusFlipped:YES];
	
    [[NSGraphicsContext currentContext] setImageInterpolation:NSImageInterpolationHigh];
	
    [self drawInRect:dstRect fromRect:srcRect operation:NSCompositeSourceOver fraction:1.0];
	//[self drawInRect:dstRect fromRect:srcRect operation:NSCompositeSourceOver fraction:1.0 respectFlipped:YES hints:nil];
    [result unlockFocus];
    
    return result;
}

@end
