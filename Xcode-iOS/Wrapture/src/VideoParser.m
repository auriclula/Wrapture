//
//  VideoParser.m
//  Wrapture
//
//  Created by Administrator on 7/26/19.
//  Copyright © 2019 Auricula. All rights reserved.
//

#import "VideoParser.h"
#import "Video.h"

@implementation VideoParser
@synthesize xmlObject, videos;

- (VideoParser *) initVideoParser
{
    self = [super init];
    
    // init array of user objects
    videos = [[NSMutableArray alloc] init];
    
    return self;
}

- (void)parser:(VideoParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName attributes:(NSDictionary *)attributeDict
{
    if ([elementName isEqualToString:@"video"])
    {
//      NSLog(@"user element found – create a new instance of Video class...");
        xmlObject = [[Video alloc] init];
    }
}

- (void)parser:(VideoParser *)parser foundCharacters:(NSString *)string
{
    NSString * tmp = [string stringByReplacingOccurrencesOfString:@"\n" withString:@""]; // strip line feeds
    if ([tmp length] < 1) return;
    
    NSMutableString * xml = [NSMutableString stringWithString:tmp];//(NSMutableString*)tmp;
    if (xml==nil || [xml length] < 1)
        return;
    
    while ([xml length] > 0 && [xml characterAtIndex:0] == ' ') {
        [xml replaceOccurrencesOfString:@" " withString:@"" options:0 range:NSMakeRange(0, 1)];
    }
    
    if ([xml length] < 1)  return;
    
    if (!currentElementValue) {
        // init the ad hoc string with the value
        currentElementValue = [[NSMutableString alloc] initWithString:xml];
    } else {
        // append value to the ad hoc string
        [currentElementValue appendString:xml];
    }
}

- (void)parser:(VideoParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    if ([elementName isEqualToString:@"videos"])
    {
        // We reached the end of the XML document
        return;
    }
    
    if ([elementName isEqualToString:@"video"])
    {
        [videos addObject:xmlObject];
        xmlObject = nil;
        
    } else {
        
        @try {
            [xmlObject setValue:currentElementValue forKey:elementName];
        }
        @catch(NSException *ex)
        {
            NSError * error = [NSError errorWithDomain:@"VideoParser.m" code:-997 userInfo:nil];
            NSLog(@"%@", [NSString stringWithFormat:@"%@%@%@", [ex name], [ex reason], error]);
        }
    }
    
    currentElementValue = nil;
}

@end
