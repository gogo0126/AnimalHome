//
//  AnimalService.h
//  JerryTask
//
//  Created by jerryliao on 2017/2/19.
//  Copyright © 2017年 jerryliao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AnimalEntity.h"
#import "Animal.h"

@interface AnimalService : NSObject

- (void)callApiOffset:(NSInteger)offset limit:(NSInteger)limit
    completionHandler:(void (^)(BOOL isSuccess, RLMResults<Animal *> *animals))completionHandler;

@end
