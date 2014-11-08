//
//  TTImageProgressing.h
//  ImageCropper
//
//  Created by Xiaoxuan Tang on 14/11/8.
//  Copyright (c) 2014年 tietie tech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TTImageProgressing : NSObject

+ (CIImage*) croppedImageWithOffset:(NSInteger) offset
                              width:(CGFloat) width
                             height:(CGFloat) height
                        sourceImage:(CIImage*) image;

+ (CIImage*) resizeImageWithScaleSize:(CGFloat) scale
                               source:(CIImage*) source;

+ (CIImage*) combineTwoImage:(CIImage*) foreground
                  background:(CIImage*) background;

@end
