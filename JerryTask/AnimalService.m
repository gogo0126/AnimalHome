//
//  AnimalService.m
//  JerryTask
//
//  Created by jerryliao on 2017/2/19.
//  Copyright © 2017年 jerryliao. All rights reserved.
//

#import "AnimalService.h"
#import "AFNetworking.h"

@implementation AnimalService

- (void)callApiOffset:(NSInteger)offset limit:(NSInteger)limit
        completionHandler:(void (^)(BOOL isSuccess, RLMResults<Animal *> *animals))completionHandler {
    NSString *URLString = @"http://data.taipei/opendata/datalist/apiAccess";
    NSDictionary *parameters = @{@"scope":@"resourceAquire", @"rid":@"f4a75ba9-7721-4363-884d-c3820b0b917c", @"offset":[NSString stringWithFormat:@"%zd", offset], @"limit":[NSString stringWithFormat:@"%zd", limit]};
    
    NSURLRequest *request = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"GET" URLString:URLString parameters:parameters error:nil];
    
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    manager.securityPolicy.allowInvalidCertificates = YES;
    manager.securityPolicy.validatesDomainName = NO;
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error) {
            NSLog(@"Error: %@", error);
            
            if ([Animal allObjects].count > 0) {
                completionHandler(YES, [Animal allObjects]);
                return;
            } else {
                completionHandler(NO, nil);
            }
        } else {
            NSLog(@"%@ %@", response, responseObject);
            // 獲取默認的 Realm 實例
            RLMRealm *realm = [RLMRealm defaultRealm];
            
            [realm beginWriteTransaction];
            
            NSDictionary *result = responseObject[@"result"];
            
            if(!result) {
                return completionHandler(NO, nil);
            }
            
            NSArray *items = result[@"results"];
            
            [items enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                NSError *error = nil;
                AnimalEntity *animalEntity = [[AnimalEntity alloc] initWithDictionary:obj error:&error];
                NSLog(@"%@", animalEntity.name);
                
                Animal *animal = [[Animal alloc] initWithValue:@{@"name":animalEntity.name, @"variety":animalEntity.variety,
                                                                 @"note":animalEntity.note, @"imageName":animalEntity.imageName}];
                
                [realm addObject:animal];
                
            }];
            
            [realm commitWriteTransaction];
            
            completionHandler(YES, [Animal allObjects]);
        }
    }];
    [dataTask resume];
}

@end
