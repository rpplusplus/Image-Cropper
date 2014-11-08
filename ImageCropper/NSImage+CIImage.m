//
//  NSImage+CIImage.m
//  ImageCropper
//
//  Created by Xiaoxuan Tang on 14/11/8.
//  Copyright (c) 2014年 tietie tech. All rights reserved.
//

#import "NSImage+CIImage.h"

@implementation NSImage (CIImage)

- (CIImage*) CIImage
{
    return [[CIImage alloc] initWithBitmapImageRep:[NSBitmapImageRep imageRepWithData:[self TIFFRepresentation]]];
}

@end
