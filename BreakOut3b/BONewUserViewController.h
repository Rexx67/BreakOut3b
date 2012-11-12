//
//  BONewUserViewController.h
//  BreakOut3b
//
//  Created by Carl Tengwall on 2012-11-09.
//  Copyright (c) 2012 Carl Tengwall. All rights reserved.
//

#import <UIKit/UIKit.h>



@class BONewUserViewController;

@protocol BONewUserViewControllerDelegate

- (void)boNewUserViewController:(BONewUserViewController *) sender
                      gotUserId:(NSString *)uid
                  gotDifficulty:(NSNumber *)diff
                          score:(NSNumber *) aScore
          andGotBackgroundColor:(NSNumber *) bkg;
@end

@interface BONewUserViewController : UIViewController


@property (nonatomic, copy) NSString *theUserId;
@property (nonatomic, copy) NSNumber *theDifficulty;
@property (nonatomic, copy) NSNumber *theBackgroundColor;
@property (nonatomic, getter=isEditing) BOOL editing;
@property (nonatomic, strong) id<BONewUserViewControllerDelegate> delegate;

@end

