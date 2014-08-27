//
//  TTImagesFinder.m
//  ImageCropper
//
//  Created by Xiaoxuan Tang on 14-8-27.
//  Copyright (c) 2014年 tietie tech. All rights reserved.
//

#import "TTImagesFinder.h"

@implementation TTImagesFinder

+ (NSArray*) findImageWithFolderURL:(NSURL *)url
{
    NSError* error;
    NSArray* array = [[NSFileManager defaultManager] contentsOfDirectoryAtURL:url
                                                   includingPropertiesForKeys:nil
                                                                      options:NSDirectoryEnumerationSkipsHiddenFiles
                                                                        error:&error];
    
    if (!error)
    {
        NSMutableArray* result = [NSMutableArray array];
        
        for (NSURL* url in array) {
            BOOL d;
            NSString* path = [url relativePath];
            [[NSFileManager defaultManager] fileExistsAtPath: path
                                                 isDirectory:&d];
            
            if (d){
                NSArray* tmp = [TTImagesFinder findImageWithFolderURL:url];
                [result addObjectsFromArray:tmp];
            }
            else
            {
                if ([path hasSuffix:@"png"] || [path hasSuffix:@"jpg"] || [path hasSuffix:@"gif"] || [path hasSuffix:@"jepg"])
                {
                    [result addObject:[NSURL fileURLWithPath:path]];
                }
            }
        }
        
        return result;
    }
    else
    {
        return @[];
    }
}

@end
