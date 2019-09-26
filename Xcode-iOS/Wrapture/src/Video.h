//
//  Video.h
//  Wrapture
//
//  Created by Administrator on 7/26/19.
//  Copyright © 2019 Auricula. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Video : NSObject {
    NSString * videoID;
    NSString * videoDate;
    NSString * videoDateProduced;
    NSString * dateAddedString;
    NSString * dateProducedString;
    NSString * videoGenre;
    NSString * videoDescription;
    NSString * videoTitle;
    NSString * videoDuration;
    NSString * videoKeywords;
    NSString * videoCopyright;
    NSString * thumbnailUrl;
    NSString * previewUrl;
    NSString * viewCount;
    NSString * mediaIsVideo;
    NSString * isPrivate;
    NSString * webSiteID;
    NSString * webSiteName;
    NSString * categoryID;
    NSString * categoryName;
    NSString * departmentID;
    NSString * departmentName;
    NSString * departmentWebSite;
    NSString * departmentLogo;
    NSString * videoFullID;
}

@property (nonatomic, retain) NSString * videoID;
@property (nonatomic, retain) NSString * videoDate;
@property (nonatomic, retain) NSString * videoDateProduced;
@property (nonatomic, retain) NSString * dateAddedString;
@property (nonatomic, retain) NSString * dateProducedString;
@property (nonatomic, retain) NSString * videoGenre;
@property (nonatomic, retain) NSString * videoDescription;
@property (nonatomic, retain) NSString * videoTitle;
@property (nonatomic, retain) NSString * videoDuration;
@property (nonatomic, retain) NSString * videoKeywords;
@property (nonatomic, retain) NSString * videoCopyright;
@property (nonatomic, retain) NSString * thumbnailUrl;
@property (nonatomic, retain) NSString * previewUrl;
@property (nonatomic, retain) NSString * viewCount;
@property (nonatomic, retain) NSString * mediaIsVideo;
@property (nonatomic, retain) NSString * isPrivate;
@property (nonatomic, retain) NSString * isVideoContent;
@property (nonatomic, retain) NSString * webSiteID;
@property (nonatomic, retain) NSString * webSiteName;
@property (nonatomic, retain) NSString * categoryID;
@property (nonatomic, retain) NSString * categoryName;
@property (nonatomic, retain) NSString * departmentID;
@property (nonatomic, retain) NSString * departmentName;
@property (nonatomic, retain) NSString * departmentWebSite;
@property (nonatomic, retain) NSString * departmentLogo;
@property (nonatomic, retain) NSString * videoFullID;

@end
