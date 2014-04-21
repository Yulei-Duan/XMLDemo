//
//  MyTableViewCell.m
//  XMLDemo
//
//  Created by YuLei on 14-4-21.
//  Copyright (c) 2014年 ___DuanYuLei___. All rights reserved.
//

#import "MyTableViewCell.h"

@implementation MyTableViewCell{
    
    __weak IBOutlet UILabel *mytitle;
    __weak IBOutlet UILabel *mydata;
    __weak IBOutlet UILabel *myDescription;
}

- (void)awakeFromNib
{
    // Initialization code
}

-(void)passModel:(DataBase *)model{
    mytitle.text = model.name;
    mydata.text = model.data;
    myDescription.text = model.description;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
