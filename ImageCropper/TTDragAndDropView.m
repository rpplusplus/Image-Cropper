//
//  TTDragAndDropView.m
//  ImageCropper
//
//  Created by Xiaoxuan Tang on 14-8-25.
//  Copyright (c) 2014年 tietie tech. All rights reserved.
//

#import "TTDragAndDropView.h"
#import "TTImagesFinder.h"

NSString *kPrivateDragUTI = @"com.liwushuo.imagecropper";

@interface TTDragAndDropView() <NSDraggingDestination>
{
    BOOL highlight;
}

@end

@implementation TTDragAndDropView
- (NSDragOperation)draggingEntered:(id <NSDraggingInfo>)sender
{
    highlight=YES;
    [self setNeedsDisplay: YES];
    [sender enumerateDraggingItemsWithOptions:NSDraggingItemEnumerationConcurrent
                                      forView:self
                                      classes:[NSArray arrayWithObject:[NSPasteboardItem class]]
                                searchOptions:nil
                                   usingBlock:^(NSDraggingItem *draggingItem, NSInteger idx, BOOL *stop) {
                                       if ( ![[[draggingItem item] types] containsObject:kPrivateDragUTI] ) {
                                           *stop = YES;
                                       } else {
                                           [draggingItem setDraggingFrame:self.bounds contents:[[[draggingItem imageComponents] objectAtIndex:0] contents]];
                                       }
                                   }];
    
    return NSDragOperationCopy;
}

- (void)draggingExited:(id <NSDraggingInfo>)sender
{
    highlight=NO;
    [self setNeedsDisplay: YES];
}

-(void)drawRect:(NSRect)rect
{
    [super drawRect:rect];
    if ( highlight ) {
        [[NSColor grayColor] set];
        [NSBezierPath setDefaultLineWidth: 5];
        [NSBezierPath strokeRect: rect];
    }
}

- (BOOL)prepareForDragOperation:(id <NSDraggingInfo>)sender
{
    highlight=NO;
    [self setNeedsDisplay: YES];
    
    NSURL* url = [NSURL URLFromPasteboard: [sender draggingPasteboard]];
    
    BOOL d;
    [[NSFileManager defaultManager] fileExistsAtPath:[url relativePath]
                                         isDirectory:&d];
    
    return [NSImage canInitWithPasteboard: [sender draggingPasteboard]] || d;
}

- (BOOL)performDragOperation:(id <NSDraggingInfo>)sender
{
    if ( [sender draggingSource] != self ) {
        NSURL* fileURL;
        
        
        if([NSImage canInitWithPasteboard: [sender draggingPasteboard]]) {
            
        }
        
        
        //if the drag comes from a file, set the window title to the filename
        fileURL=[NSURL URLFromPasteboard: [sender draggingPasteboard]];
        NSLog(@"%@", [TTImagesFinder findImageWithFolderURL:fileURL]);
        [[self window] setTitle: fileURL!=NULL ? [fileURL absoluteString] : @"(no name)"];
    }
    
    return YES;
}

- (NSRect)windowWillUseStandardFrame:(NSWindow *)window defaultFrame:(NSRect)newFrame;
{
    NSRect ContentRect=self.window.frame;
    return [NSWindow frameRectForContentRect:ContentRect styleMask: [window styleMask]];
};
@end
