//
//  TTCropTaskViewController.m
//  ImageCropper
//
//  Created by Xiaoxuan Tang on 14/11/7.
//  Copyright (c) 2014年 tietie tech. All rights reserved.
//

#import "TTCropTaskViewController.h"
#import "TTCropOperation.h"

@interface TTCropTaskViewController () <NSTableViewDataSource, NSTableViewDelegate, NSTextFieldDelegate>
{
    NSInteger             status[10000];
}

@property (weak) IBOutlet NSTableView*      tableview;
@property (weak) IBOutlet NSMatrix*         sizeGroup;
@property (weak) IBOutlet NSTextField*      otherSize;

@property (weak) IBOutlet NSImageView*      watermarkImage;
@property (weak) IBOutlet NSImageView*      faceImageView;
@property (assign)        BOOL              workingFlag;
@property (strong)        NSOperationQueue* queue;

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

- (void) awakeFromNib
{
    [super awakeFromNib];
    
    NSClickGestureRecognizer* click = [[NSClickGestureRecognizer alloc] initWithTarget:self
                                                                                action:@selector(doitButtonClick)];
    [self.faceImageView addGestureRecognizer:click];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(otherSizeTextValueChanged:)
                                                 name:NSControlTextDidChangeNotification
                                               object:self.otherSize];
    self.queue = [[NSOperationQueue alloc] init];
    self.queue.maxConcurrentOperationCount = 3;
}

- (void) doitButtonClick
{
    if (self.workingFlag) return;
    
    self.workingFlag = YES;
    self.faceImageView.image = [NSImage imageNamed:@"zhenbai_2"];
    
    for (int i=0; i<self.dataSource.count; i++) {
        status[i] = 0;
    }
    
    for (int i=0; i<self.dataSource.count; i++) {
        TTCropOperation* op = [[TTCropOperation alloc] init];
        op.url = self.dataSource[i];
        op.watermarkImage = self.watermarkImage.image;
        op.index = i;
        op.vc = self;
        
        if (_otherSize.stringValue.integerValue != 0)
        {
            op.imageWidth = _otherSize.stringValue.integerValue;
        }
        else
        {
            op.imageWidth = self.sizeGroup.selectedColumn ? 440 : 640;
        }
        
        [self.queue  addOperation:op];
    }
    
}

- (void) updateStatus:(NSInteger) s withIndex:(NSInteger) index
{
    @synchronized(self){
        status[index] = s;
        [self.tableview reloadDataForRowIndexes:[NSIndexSet indexSetWithIndex:index]
                                  columnIndexes:[NSIndexSet indexSetWithIndex:0]];
        
        for (int i=0; i<self.dataSource.count; i++)
        {
            if (status[i] != 2) return;
        }
        
        self.workingFlag = NO;
        self.faceImageView.image = [NSImage imageNamed:@"zhenbai_3"];
        NSAlert* alert = [[NSAlert alloc] init];
        [alert setMessageText:@"轉換完成"];
        [alert addButtonWithTitle:@"確定"];
        [alert runModal];

    }
}

#pragma mark - NSTextField notification

- (void) otherSizeTextValueChanged:(NSNotification*) notification
{
    if ([_otherSize.stringValue integerValue] == 0)
    {
        self.sizeGroup.enabled = YES;
    }
    else
    {
        self.sizeGroup.enabled = NO;
    }
}

#pragma mark - NSTableView Delegate And DataSource

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
        
        if (status[row] == 0)
            textField.textField.stringValue = @"😑";
        if (status[row] == 1)
            textField.textField.stringValue = @"😡";
        if (status[row] == 2)
            textField.textField.stringValue = @"✅";
        
        return textField;
    } else {
        NSAssert1(NO, @"Unhandled table column identifier %@", identifier);
    }
    return nil;
}

@end
