//
//  TTCropTaskViewController.h
//  ImageCropper
//
//  Created by Xiaoxuan Tang on 14/11/7.
//  Copyright (c) 2014年 tietie tech. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface TTCropTaskViewController : NSViewController

@property (nonatomic, strong)   NSArray*    dataSource;

- (void) updateStatus:(NSInteger) status withIndex:(NSInteger) index;

@end
