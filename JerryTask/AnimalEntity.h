//
//  AnimalEntity.h
//  JerryTask
//
//  Created by jerryliao on 2017/2/18.
//  Copyright © 2017年 jerryliao. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface AnimalEntity : JSONModel
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *variety;
@property (nonatomic, copy) NSString *note;
@property (nonatomic, copy) NSString *imageName;
@end
