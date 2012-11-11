//
//  BOUserCell.h
//  BreakOut3b
//
//  Created by Carl Tengwall on 2012-11-09.
//  Copyright (c) 2012 Carl Tengwall. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BOUserCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *userIdLabel;
@property (strong, nonatomic) IBOutlet UILabel *scoreLabel;

@end
