//
//  PlaylistParser.h
//  Wrapture
//
//  Created by Administrator on 7/26/19.
//  Copyright © 2019 Auricula. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Playlist.h"

@class Playlist;

@interface PlaylistParser : NSObject {
    // an ad hoc string to hold element value
    NSMutableString * currentElementValue;
    
    // xml object
    Playlist * xmlObject;
    
    // array of user objects
    NSMutableArray * playlists;
}

@property (nonatomic, retain) Playlist * xmlObject;
@property (nonatomic, retain) NSMutableArray * playlists;

- (PlaylistParser *) initPlaylistParser;

@end
