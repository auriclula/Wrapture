//
//  PlaylistParser.m
//  Wrapture
//
//  Created by Administrator on 7/26/19.
//  Copyright © 2019 Auricula. All rights reserved.
//

#import "PlaylistParser.h"
#import "Playlist.h"

@implementation PlaylistParser
@synthesize xmlObject, playlists;

- (PlaylistParser *) initPlaylistParser
{
    self = [super init];
    
    // init array of user objects
    playlists = [[NSMutableArray alloc] init];
    
    return self;
}

- (void)parser:(PlaylistParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName attributes:(NSDictionary *)attributeDict
{
    if ([elementName isEqualToString:@"playlist"])
    {
        // NSLog(@"user element found – create a new instance of Video class...");
        xmlObject = [[Playlist alloc] init];
        // We do not have any attributes in the user elements, but if
        // you do, you can extract them here:
        // user.att = [[attributeDict objectForKey:@"<att name>"] ...];
    }
}

- (void)parser:(PlaylistParser *)parser foundCharacters:(NSString *)string
{
    if (string==nil || [string length] < 1 || [string characterAtIndex:0] == '\n')
        return;
    
    NSString * tmp;
    @try {
        tmp = [string stringByReplacingOccurrencesOfString:@"\n" withString:@""]; // strip line feeds
    } @catch (NSException * e) {
        NSLog(@"An exception occurred: %@", e.name);
        NSLog(@"Here are some details: %@", e.reason);
    }
    
    if (tmp==nil || [tmp length] < 1)
        return;

    NSMutableString * xml = [NSMutableString stringWithString:tmp];//(NSMutableString*)tmp;
    if (xml==nil || [xml length] < 1)
        return;
    
    while ([xml length] > 0 && [xml characterAtIndex:0] == ' ')
    {
        @try {
//            NSLog(@"'%@' %d", xml, [xml length]);
            if([xml length]==1) {
                xml = nil;
                xml = [[NSMutableString alloc] initWithString:@""];
            }
            else
                [xml replaceOccurrencesOfString:@" " withString:@"" options:0 range:NSMakeRange(0, 1)];
        } @catch (NSException * e) {
            NSLog(@"An exception occurred: %@", e.name);
            NSLog(@"Here are some details: %@", e.reason);
        }
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

- (void)parser:(PlaylistParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    if ([elementName isEqualToString:@"playlists"])
    {
        // We reached the end of the XML document
        return;
    }
    
    if ([elementName isEqualToString:@"playlist"])
    {
        [playlists addObject:xmlObject];
        xmlObject = nil;
    } else {
        // The parser hit one of the element values.
        // This syntax is possible because User object
        // property names match the XML user element names
        [xmlObject setValue:currentElementValue forKey:elementName];
    }
    
    currentElementValue = nil;
}

@end
