//
//  VideoParser.h
//  Wrapture
//
//  Created by Administrator on 7/26/19.
//  Copyright © 2019 Auricula. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Video.h"

@class Video;

@interface VideoParser : NSObject {
    // an ad hoc string to hold element value
    NSMutableString * currentElementValue;
    
    // xml object
    Video * xmlObject;
    
    // array of user objects
    NSMutableArray * videos;
}

@property (nonatomic, retain) Video * xmlObject;
@property (nonatomic, retain) NSMutableArray * videos;

- (VideoParser *) initVideoParser;

@end
