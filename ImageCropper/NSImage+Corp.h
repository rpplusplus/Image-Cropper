//
//  NSImage+Corp.h
//  ImageCropper
//
//  Created by Xiaoxuan Tang on 14-8-25.
//  Copyright (c) 2014年 tietie tech. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface NSImage (Corp)

typedef enum {
	MGImageResizeNone,
    MGImageResizeCrop,
    MGImageResizeCropStart,
    MGImageResizeCropEnd,
    MGImageResizeScale
} MGImageResizingMethod;

- (void) tt_drawInRect:(NSRect)dstRect
             operation:(NSCompositingOperation)op
              fraction:(float)delta method:(MGImageResizingMethod)resizeMethod;

- (NSImage *) tt_imageToFitSize:(NSSize)size
                         method:(MGImageResizingMethod)resizeMethod;

- (NSImage *) tt_imageCroppedToFitSize:(NSSize)size;

- (NSImage *) tt_imageScaledToFitSize:(NSSize)size;

- (NSImage *) tt_imageCroppedInRect:(NSRect)srcRect;

@end
