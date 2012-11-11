//
//  BOSettingsTableViewController.h
//  BreakOut3b
//
//  Created by Carl Tengwall on 2012-11-09.
//  Copyright (c) 2012 Carl Tengwall. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BOTabBarController.h"
#import "BONewUserViewController.h"
#import "BOUser.h"
#import "BOUserCell.h"

@class BOTabBarController;

@interface BOSettingsTableViewController : UITableViewController <BONewUserViewControllerDelegate>

@property (strong, nonatomic) BONewUserViewController  *boNewUserViewController;
@property (strong, nonatomic) BOTabBarController *boTabBarController;
@property (strong, nonatomic) NSMutableArray *users; // This view controllers model consists of User objects

@end
