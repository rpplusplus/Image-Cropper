//
//  TTCropOperation.h
//  ImageCropper
//
//  Created by Xiaoxuan Tang on 14-8-27.
//  Copyright (c) 2014年 tietie tech. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TTCropTaskViewController;

@interface TTCropOperation : NSOperation

@property (nonatomic, strong) NSURL*                    url;
@property (nonatomic, assign) NSInteger                 imageWidth;
@property (nonatomic, strong) NSImage*                  watermarkImage;
@property (nonatomic, weak)   TTCropTaskViewController* vc;
@property (nonatomic, assign) NSInteger                 index;

@end
