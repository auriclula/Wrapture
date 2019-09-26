//
//  Category.h
//  Wrapture
//
//  Created by Administrator on 7/26/19.
//  Copyright © 2019 Auricula. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Category : NSObject {
    NSString * categoryID;
    NSString * categoryName;
    NSString * webSiteID;
    NSString * websiteName;
    NSString * departmentID;
    NSString * departmentName;
}

@property (nonatomic, retain) NSString * categoryID;
@property (nonatomic, retain) NSString * categoryName;
@property (nonatomic, retain) NSString * webSiteID;
@property (nonatomic, retain) NSString * websiteName;
@property (nonatomic, retain) NSString * departmentID;
@property (nonatomic, retain) NSString * departmentName;

@end
