//
//  BOViewController.h
//  BreakOut3b
//
//  Created by Carl Tengwall on 2012-11-06.
//  Copyright (c) 2012 Carl Tengwall. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <QuartzCore/QuartzCore.h>
#import "BOBlockView.h"
#import "BOSettingsTableViewController.h"
#import "BOModel.h"

#define WHITE_BKGCOLOR     1
#define LIGHTGRAY_BKGCOLOR 2
#define GRAY_BKGCOLOR      3
#define YELLOW_BKGCOLOR    4

@interface BOViewController : UIViewController {
    BOModel* gameModel;
    CADisplayLink* gameTimer;
    UIImageView* mo;
    UIImageView* paddel;
    int maxScore;
    int color;
    UIColor *realColor;
}

-(void) gameLoop:(CADisplayLink*)sender ;
-(void) gameOver:(NSString*) message;

@end
