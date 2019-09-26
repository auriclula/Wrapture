//
//  Playlist.h
//  Wrapture
//
//  Created by Administrator on 7/26/19.
//  Copyright © 2019 Auricula. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Playlist : NSObject {
    NSString * webSiteID;
    NSString * webSiteName;
}

@property (nonatomic, retain) NSString * webSiteID, * webSiteName;

@end
