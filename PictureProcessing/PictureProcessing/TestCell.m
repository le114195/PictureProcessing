//
//  TestCell.m
//  FunctionTest
//
//  Created by 勒俊 on 16/8/10.
//  Copyright © 2016年 勒俊. All rights reserved.
//

#import "TestCell.h"

@implementation TestCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 0, 200, 44)];
        [self.contentView addSubview:nameLabel];
        self.nameLabel = nameLabel;
    }
    return self;
}



@end
