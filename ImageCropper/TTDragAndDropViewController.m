//
//  TTDragAndDropViewController.m
//  ImageCropper
//
//  Created by Xiaoxuan Tang on 14/11/6.
//  Copyright (c) 2014年 tietie tech. All rights reserved.
//

#import "TTDragAndDropViewController.h"

#import "TTPromptView.h"
#import "TTDragAndDropView.h"

@interface TTDragAndDropViewController () <NSDraggingDestination>

@property (nonatomic, weak) IBOutlet    TTPromptView*           promptView;
@property (nonatomic, weak)             TTDragAndDropView*      imageView;
@property (nonatomic, strong)           NSArray*                dataSource;

@end

@implementation TTDragAndDropViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveDataSource:)
                                                 name:TTCropSourceNotificationKey
                                               object:nil];
}

- (void) receiveDataSource:(NSNotification*) notification
{
    NSArray* array = [notification.userInfo valueForKey:TTCropSourceNotificationUserInfoKey];
    
    NSLog(@"%@", array);
}

@end
