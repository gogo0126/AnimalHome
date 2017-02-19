//
//  BasicCell.h
//  AccupassApp
//
//  Created by jerryliao on 2016/8/3.
//  Copyright © 2016年 jerryliao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BasicCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *varietyLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imagedView;
@property (weak, nonatomic) IBOutlet UILabel *noteLabel;



@end
