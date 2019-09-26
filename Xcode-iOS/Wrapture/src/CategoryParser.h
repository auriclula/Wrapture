//
//  CategoryParser.h
//  Wrapture
//
//  Created by Administrator on 7/26/19.
//  Copyright © 2019 Auricula. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Category.h"

@class Category;

@interface CategoryParser : NSObject {
    // an ad hoc string to hold element value
    NSMutableString * currentElementValue;
    
    // xml object
    Category * xmlObject;
    
    // array of user objects
    NSMutableArray * categories;
}

@property (nonatomic, retain) Category * xmlObject;
@property (nonatomic, retain) NSMutableArray * categories;

- (CategoryParser *) initCategoryParser;

@end
