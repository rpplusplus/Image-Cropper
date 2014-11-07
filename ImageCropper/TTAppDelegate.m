//
//  TTAppDelegate.m
//  ImageCropper
//
//  Created by Xiaoxuan Tang on 14-8-25.
//  Copyright (c) 2014年 tietie tech. All rights reserved.
//

#import "TTAppDelegate.h"
#import "TTDragAndDropViewController.h"

@implementation TTAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    TTDragAndDropViewController* vc = [TTDragAndDropViewController new];
    self.window.contentViewController = vc;
    
}

@end
