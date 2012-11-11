//
//  BOUserCell.m
//  BreakOut3b
//
//  Created by Carl Tengwall on 2012-11-09.
//  Copyright (c) 2012 Carl Tengwall. All rights reserved.
//

#import "BOUserCell.h"

@implementation BOUserCell

@synthesize userIdLabel = _userIdLabel;
@synthesize scoreLabel = _scoreLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
