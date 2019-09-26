//
//  CategoryParser.m
//  Wrapture
//
//  Created by Administrator on 7/26/19.
//  Copyright © 2019 Auricula. All rights reserved.
//

#import "CategoryParser.h"
#import "Category.h"

@implementation CategoryParser
@synthesize xmlObject, categories;

- (CategoryParser *) initCategoryParser
{
    self = [super init];
    
    // init array of user objects
    categories = [[NSMutableArray alloc] init];
    
    return self;
}

- (void)parser:(CategoryParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName attributes:(NSDictionary *)attributeDict
{
    if ([elementName isEqualToString:@"category"])
    {
//      NSLog(@"user element found – create a new instance of Video class...");
        xmlObject = [[Category alloc] init];
    }
}

- (void)parser:(CategoryParser *)parser foundCharacters:(NSString *)string
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

- (void)parser:(CategoryParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    if ([elementName isEqualToString:@"categories"])
    {
        // We reached the end of the XML document
        return;
    }
    
    if ([elementName isEqualToString:@"category"])
    {
        [categories addObject:xmlObject];
        xmlObject = nil;
        
    } else {
        
        @try {
            [xmlObject setValue:currentElementValue forKey:elementName];
        }
        @catch(NSException *ex)
        {
            NSError * error = [NSError errorWithDomain:@"CategoryParser.m" code:-998 userInfo:nil];
            NSLog(@"%@", [NSString stringWithFormat:@"%@%@%@", [ex name], [ex reason], error]);
        }
    }
    
    currentElementValue = nil;
}

@end
