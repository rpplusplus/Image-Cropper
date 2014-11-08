//
//  CIImage+NSImage.m
//  ImageCropper
//
//  Created by Xiaoxuan Tang on 14/11/8.
//  Copyright (c) 2014年 tietie tech. All rights reserved.
//

#import "CIImage+NSImage.h"

@implementation CIImage (NSImage)

- (NSImage*) NSImage
{
    NSCIImageRep *rep = [NSCIImageRep imageRepWithCIImage:self];
    NSImage *nsImage = [[NSImage alloc] initWithSize:rep.size];
    [nsImage addRepresentation:rep];
    return nsImage;
}

@end
