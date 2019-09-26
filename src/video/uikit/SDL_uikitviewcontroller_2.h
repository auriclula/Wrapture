//
//  SDL_uikitviewcontroller_2.h
//  Wrapture
//
//  Created by Administrator on 7/26/19.
//  Copyright © 2019 Auricula. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SDL_uikitviewcontroller.h" // super class
#import "../../../Xcode-iOS/Wrapture/src/PlaylistParser.h"
#import "../../../Xcode-iOS/Wrapture/src/CategoryParser.h"
#import "../../../Xcode-iOS/Wrapture/src/VideoParser.h"

@interface SDL_uikitviewcontroller_2 : SDL_uikitviewcontroller <UITableViewDataSource, UITableViewDelegate>
{
    UITableView * myTable;
#if !TARGET_OS_TV
    UIToolbar * toolbar;
#endif
    NSMutableArray * myArray, * myArray2;
    
    PlaylistParser * playlistParser;
    CategoryParser * categoryParser;
    VideoParser    * videoParser;
    
    NSInteger itemsInTable;  // check to see if this changes in NSTimer loop
    NSInteger page; // changes when an item in the table is selected
    BOOL paused;
    
    NSString * selectedPlaylist;
    UIImage  * selectedPlaylistImage;
    NSString * selectedCategory;
    NSString * selectedVideo;
    NSString * selectedVideoName;
    NSInteger  selectedVideoNum;
    UIImage  * selectedVideoImage;
    NSString * hack;
}

@end
