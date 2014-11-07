//
//  TTCropTaskViewController.m
//  ImageCropper
//
//  Created by Xiaoxuan Tang on 14/11/7.
//  Copyright (c) 2014年 tietie tech. All rights reserved.
//

#import "TTCropTaskViewController.h"

@interface TTCropTaskViewController () <NSTableViewDataSource, NSTableViewDelegate>

@property (weak) IBOutlet NSTableView *tableview;
@property (weak) IBOutlet NSMatrix *sizeGroup;
@property (weak) IBOutlet NSTextField *otherSize;

@property (weak) IBOutlet NSImageView *watermarkImage;

@end

@implementation TTCropTaskViewController
- (IBAction)watermarkImageClick:(id)sender {
    NSOpenPanel* panel = [NSOpenPanel openPanel];
    panel.allowedFileTypes = @[@"png"];
    NSInteger n = [panel runModal];
    
    if (n == NSFileHandlingPanelOKButton)
    {
        NSURL* path = panel.URL;
        self.watermarkImage.image = [[NSImage alloc] initWithContentsOfURL:path];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
    return self.dataSource.count;
}

- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row { 
    NSString *identifier = [tableColumn identifier];
    
    if ([identifier isEqualToString:@"MainCell"]) {
        // We pass us as the owner so we can setup target/actions into this main controller object
        NSTableCellView *cellView = [tableView makeViewWithIdentifier:identifier owner:self];
        
        // Then setup properties on the cellView based on the column
        cellView.textField.stringValue = [[[(NSURL*)self.dataSource[row] absoluteString] lastPathComponent] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

        return cellView;
        
    } else if ([identifier isEqualToString:@"SizeCell"]) {
        NSTableCellView *textField = [tableView makeViewWithIdentifier:identifier owner:self];
        textField.textField.stringValue = [[self.dataSource[row] absoluteString]stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        return textField;
    } else if ([identifier isEqualToString:@"statusCell"]) {
        
        NSTableCellView *textField = [tableView makeViewWithIdentifier:identifier owner:self];
        textField.textField.stringValue = @"😑";
        return textField;
        
    } else {
        NSAssert1(NO, @"Unhandled table column identifier %@", identifier);
    }
    return nil;
}

@end
