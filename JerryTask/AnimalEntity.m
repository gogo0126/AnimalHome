//
//  AnimalEntity.m
//  JerryTask
//
//  Created by jerryliao on 2017/2/18.
//  Copyright © 2017年 jerryliao. All rights reserved.
//

#import "AnimalEntity.h"

@implementation AnimalEntity

+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{
        @"name": @"Name",
        @"variety" : @"Variety",
        @"note" : @"Note",
        @"imageName" : @"ImageName"
    }];
}
@end
