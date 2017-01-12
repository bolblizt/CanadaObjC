//
//  TableViewCell.h
//  CanadaObjC
//
//  Created by user on 13/1/17.
//  Copyright © 2017 user. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppImage.h"
@interface TableViewCell : UITableViewCell


@property(nonatomic, strong)UILabel *appTitle;
@property(nonatomic, strong)UILabel *descr;
@property(nonatomic, strong)UIImageView *imgView;

- (void)setCell:(AppImage *)record;

@end
