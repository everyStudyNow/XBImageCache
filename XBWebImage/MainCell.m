//
//  MainCell.m
//  XBWebImage
//
//  Created by youxiao on 2019/11/22.
//  Copyright © 2019 youxiao. All rights reserved.
//

#import "MainCell.h"

#define WIDTH [UIScreen mainScreen].bounds.size.width
#define HEIGHT [UIScreen mainScreen].bounds.size.height
@implementation MainCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        self.coverImg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 120)];
        self.coverImg.contentMode = UIViewContentModeScaleAspectFit;
        self.coverImg.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];
        [self addSubview:self.coverImg];
    }
    return self;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
