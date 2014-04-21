//
//  MyTableViewCell.h
//  XMLDemo
//
//  Created by YuLei on 14-4-21.
//  Copyright (c) 2014年 ___DuanYuLei___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataBase.h"

@interface MyTableViewCell : UITableViewCell

-(void)passModel:(DataBase *)model;
@end
