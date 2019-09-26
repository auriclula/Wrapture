//
//  Document.m
//  m3u8-Player
//
//  Created by Administrator on 7/8/19.
//  Copyright © 2019 Auricula. All rights reserved.
//

#import "Document.h"

@interface Document ()

@end

@implementation Document

- (instancetype)init {
    self = [super init];
    if (self) {
        // Add your subclass-specific initialization here.
    }
    return self;
}

+ (BOOL)autosavesInPlace {
    return YES;
}

- (NSString *)windowNibName {
    // Override returning the nib file name of the document
    // If you need to use a subclass of NSWindowController or if your document supports multiple NSWindowControllers, you should remove this method and override -makeWindowControllers instead.
    return @"Document";
}

- (NSData *)dataOfType:(NSString *)typeName error:(NSError **)outError {
    // Insert code here to write your document to data of the specified type. If outError != NULL, ensure that you create and set an appropriate error if you return nil.
    // Alternatively, you could remove this method and override -fileWrapperOfType:error:, -writeToURL:ofType:error:, or -writeToURL:ofType:forSaveOperation:originalContentsURL:error: instead.
    [NSException raise:@"UnimplementedMethod" format:@"%@ is unimplemented", NSStringFromSelector(_cmd)];
    return nil;
}

- (BOOL)readFromData:(NSData *)data ofType:(NSString *)typeName error:(NSError **)outError {
    // Insert code here to read your document from the given data of the specified type. If outError != NULL, ensure that you create and set an appropriate error if you return NO.
    // Alternatively, you could remove this method and override -readFromFileWrapper:ofType:error: or -readFromURL:ofType:error: instead.
    // If you do, you should also override -isEntireFileLoaded to return NO if the contents are lazily loaded.
    BOOL readSuccess = NO;
    NSDictionary * documentAttributes;
    NSAttributedString * fileContents = [[NSAttributedString alloc]
                                        initWithData:data options:@{ NSDocumentTypeDocumentAttribute: NSPlainTextDocumentType } documentAttributes:&documentAttributes
                                        error:outError];
    if (!fileContents && outError) {
        * outError = [NSError errorWithDomain:NSCocoaErrorDomain code:NSFileReadUnknownError userInfo:nil];
    }
    
    if (fileContents) {
        readSuccess = YES;
        
        NSString * web = [NSString stringWithFormat:@"%@", fileContents];
        NSRange start = [web rangeOfString:@"https"];
        NSRange end = [web rangeOfString:@"view"];
        if ( start.length < 1 || end.length < 1 ) {
            NSAlert * alert = [[NSAlert alloc] init];
            [alert setMessageText:@"Invalid web link."];
            [alert setInformativeText:@"This link does not point to a valid Mediaflo file."];
            [alert addButtonWithTitle:@"Ok"];
            [alert runModal];
            
            return NO;
        }
        
        NSRange loc = NSMakeRange (start.location, end.location - start.location + 4);
        NSString * hack = [web substringWithRange:loc];
        
//        NSApplication * app = [NSApplication sharedApplication];
//        id delegate = [app delegate];
//        [delegate play:hack];
        
        NSURL * url = [NSURL URLWithString:hack];
        NSURLRequest * request = [NSURLRequest requestWithURL:url];
        NSURLSession * session = [NSURLSession sharedSession];
        NSURLSessionDataTask * task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError * error)
                                       {
                                           if ( [data length] > 0 && error == nil )
                                           {
                                               NSString * web = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                               NSRange start = [web rangeOfString:@"\"file\":"];
                                               NSRange end = [web rangeOfString:@".m3u8"];
                                               if ( start.length < 1 || end.length < 1 ) {
                                                   NSAlert * alert = [[NSAlert alloc] init];
                                                   [alert setMessageText:@"Invalid web link."];
                                                   [alert setInformativeText:@"This link does not point to a valid m3u8 file."];
                                                   [alert addButtonWithTitle:@"Ok"];
                                                   [alert runModal];
                                                   
                                                   [[NSApplication sharedApplication] terminate:(self)];
                                               }

                                               NSRange loc = NSMakeRange (start.location + 8, end.location - start.location - 3);
                                               NSString * hack = [web substringWithRange:loc];
                                               
                                               AppDelegate * delegateClass = (AppDelegate*)[[NSApplication sharedApplication] delegate];
                                               [delegateClass play:hack autoexit:YES];

                                           } else {
                                               NSAlert * alert = [[NSAlert alloc] init];
                                               [alert setMessageText:@"Invalid or nil content."];
                                               [alert setInformativeText:@"No valid content found in the data retrieved from the internet."];
                                               [alert addButtonWithTitle:@"Ok"];
                                               [alert runModal];
                                               
                                               [[NSApplication sharedApplication] terminate:(self)];//todo not very elegant
                                           }
                                       }];
        [task resume];
    }
    
    return readSuccess;
}

@end
