//
//  AppDelegate.h
//  m3u8-Player
//
//  Created by Administrator on 7/8/19.
//  Copyright © 2019 Auricula. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "../src/PlaylistParser.h"
#import "CategoryParser.h"
#import "VideoParser.h"

@class Playlist;
@class Category;
@class Video;

@interface AppDelegate : NSObject <NSApplicationDelegate>
{
    IBOutlet NSMenu * dMenu;
    IBOutlet NSMenuItem * dMenuItem;
    
    NSString * pathToFFplay;
    NSString * pathToFFprobe;
    int channels;
    BOOL needsChannelMap;
    
//    NSMutableData * _responseData;
//    PlaylistParser * playlistParser;
//    CategoryParser * categoryParser;
//    VideoParser * videoParser;
}

- (void)checkForFFMPEG;
- (BOOL)probe:(NSString*)path;
- (void)play:(NSString*)path autoexit:(BOOL)autoexit;
- (void)parsePlaylist:(NSString*)path menu:(NSMenu *)menu menuitem:(NSMenuItem*)menuitem;
- (void)parseCategory:(NSString*)path menu:(NSMenu *)menu;

//- (IBAction)handleTestFilesMenu:(id)sender;
- (void)menuHandler:(id)sender;

@end
