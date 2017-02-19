//
//  MainViewController.m
//  JerryTask
//
//  Created by jerryliao on 2017/2/18.
//  Copyright © 2017年 jerryliao. All rights reserved.
//

#import "MainViewController.h"
#import "AFNetworking.h"
#import "AnimalEntity.h"
#import "Animal.h"
#import "MJRefresh.h"
#import "MJRefreshHeader.h"
#import "UIScrollView+MJExtension.h"
#import "UIScrollView+MJRefresh.h"
#import "UIView+MJExtension.h"
#import "MJRefreshComponent.h"
#import "BasicCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "AnimalService.h"

@interface MainViewController ()
@property (strong, nonatomic) RLMResults<Animal *> *animals;
@property (strong, nonatomic) AnimalService *animalService;
@end


@implementation MainViewController

static const NSInteger JERRYperDownloads = 30;

- (AnimalService *)animalService {
    if (!_animalService) {
        _animalService = [[AnimalService alloc] init];
    }
    return _animalService;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"認養動物之家";
    self.navigationController.navigationBar.barTintColor = [UIColor brownColor];
    [self.navigationController.navigationBar
     setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    
    self.tableView.estimatedRowHeight = 64.0;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    [self setupRefresh];
    [self.tableView.mj_header beginRefreshing];
}

- (void)setupRefresh {
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRereshing)];
    
    __weak __typeof(self) weakSelf = self;
    MJRefreshAutoNormalFooter *refreshFooter = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [weakSelf callApiForFooter];
    }];
    
    refreshFooter.triggerAutomaticallyRefreshPercent = 0.2;
    self.tableView.mj_footer = refreshFooter;
}

- (void)headerRereshing {
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        [self callApiForHeader];
    });
}

- (void)callApiForHeader {
    [self.animalService callApiOffset:0 limit:JERRYperDownloads completionHandler:^(BOOL isSuccess, RLMResults<Animal *> *animals) {
        if(isSuccess) {
            self.animals = animals;
            [self.tableView reloadData];
            [self.tableView.mj_header endRefreshing];
        } else {
            [self showInfoMessage];
        }
    }];
}

- (void)callApiForFooter {
    [self.animalService callApiOffset:self.animals.count limit:JERRYperDownloads completionHandler:^(BOOL isSuccess, RLMResults<Animal *> *animals) {
        if(isSuccess) {
            self.animals = animals;
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
                [self.tableView.mj_footer endRefreshing];
            });
        } else {
            [self showInfoMessage];
        }
    }];
}

- (void)showInfoMessage {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"請先確認網路狀態" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *yesAction = [UIAlertAction actionWithTitle:@"確定" style:UIAlertActionStyleDefault handler:nil];
    
    [alertController addAction:yesAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.animals.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BasicCell *cell = (BasicCell *)[tableView dequeueReusableCellWithIdentifier:@"BasicCell"];

    Animal *animal = (Animal *)self.animals[indexPath.row];
    cell.nameLabel.text = [animal.name isEqualToString:@""] ? @"無名" : animal.name;
    cell.varietyLabel.text = animal.variety;
    cell.noteLabel.text = animal.note;

    NSURL *url = [NSURL URLWithString:animal.imageName];
    [cell.imagedView sd_setImageWithURL:url
                 placeholderImage:[UIImage imageNamed:@"defaultImg"]
                          options:SDWebImageRefreshCached];
    
    return cell;
}

@end
