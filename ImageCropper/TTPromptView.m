//
//  TTPromptView.m
//  ImageCropper
//
//  Created by Xiaoxuan Tang on 14-8-28.
//  Copyright (c) 2014年 tietie tech. All rights reserved.
//

#import "TTPromptView.h"
@import QuartzCore;

@implementation TTPromptView

- (void) drawRect:(NSRect)dirtyRect
{
    [super drawRect:dirtyRect];
    
    [[NSColor grayColor] set];
    [NSBezierPath setDefaultLineWidth: 5];
    [NSBezierPath strokeRect: CGRectInset(dirtyRect, 50, 50)];
}

@end
