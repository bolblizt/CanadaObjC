//
//  TableViewCell.m
//  CanadaObjC
//
//  Created by user on 13/1/17.
//  Copyright © 2017 user. All rights reserved.
//

#import "TableViewCell.h"

@implementation TableViewCell


@synthesize imgView;
@synthesize appTitle;
@synthesize descr;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:
(NSString *)reuseIdentifier

{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        self.imgView = [[UIImageView alloc] initWithFrame:CGRectMake(4.0f, 3.0f, 49.0f,
                                                               49.0f)];
        self.appTitle = [[UILabel alloc] initWithFrame:CGRectMake(58.0f, 8.0f, 150.0f,
                                                                27.0f)];
       
        self.descr = [[UILabel alloc] initWithFrame:CGRectMake(58.0f, 40.0f, 250.0f,
                                                                  35.0f)];
        
        [self.contentView addSubview:self.imgView];
        [self.contentView addSubview:self.appTitle];
        [self.contentView addSubview:self.descr];
        
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

- (void)setCell:(AppImage *)record{
    
    [self.appTitle setText:record.title];
    [self.descr setText:record.descript];
    
    if (record.imageIcon != nil){
       
        self.imgView.image = record.imageIcon;
    }
    else{
        
        self.imgView.image = [UIImage imageNamed:@"Placeholder"];
    }

}


@end





