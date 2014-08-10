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
        
        
        self.name = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, self.bounds.size.width, 30)];
        self.name.font = [UIFont boldSystemFontOfSize:16];
        
        self.address = [[UILabel alloc]initWithFrame:CGRectMake(10, 15, self.bounds.size.width, 30)];
        self.address.font = [UIFont systemFontOfSize:12];
        
        self.open = [[UIView alloc]initWithFrame:CGRectMake(self.bounds.size.width - 20, self.bounds.size.height/2 - 5, 10, 10)];
        self.open.layer.cornerRadius = self.open.bounds.size.height/2;
        self.open.clipsToBounds = YES;
        
        [self addSubview:self.name];
        [self addSubview:self.address];
        [self addSubview:self.open];
        
        
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
