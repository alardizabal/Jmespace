//
//  AALSpaceCustomCellTableViewCell.m
//  jmespace
//
//  Created by Albert Lardizabal on 8/6/14.
//  Copyright (c) 2014 Albert Lardizabal. All rights reserved.
//

#import "AALSpaceCustomCellTableViewCell.h"

@implementation AALSpaceCustomCellTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.name = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 300, 30)];
        self.name.font = [UIFont boldSystemFontOfSize:18];
        
        self.address = [[UILabel alloc]initWithFrame:CGRectMake(10, 15, 300, 30)];
        self.address.font = [UIFont systemFontOfSize:12];
        
        [self addSubview:self.name];
        [self addSubview:self.address];
        
        
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
