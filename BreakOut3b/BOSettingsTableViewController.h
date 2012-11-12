//
//  BOSettingsTableViewController.h
//  BreakOut3b
//
//  Created by Carl Tengwall on 2012-11-09.
//  Copyright (c) 2012 Carl Tengwall. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BONewUserViewController.h"
#import "BOViewController.h"
#import "BOUser.h"
#import "BOUserCell.h"


@interface BOSettingsTableViewController : UITableViewController <BONewUserViewControllerDelegate, BOViewControllerDelegate>

@property (strong, nonatomic) BONewUserViewController  *boNewUserViewController;
@property (strong, nonatomic) NSMutableArray *users; // This view controller's model consists of User objects
@property (strong, nonatomic) BOUser *player;

@end
