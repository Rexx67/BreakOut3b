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
#import "BOModel.h"

@interface BOViewController : UIViewController {
    BOModel* gameModel;
    CADisplayLink* gameTimer;
    UIImageView* mo;
    UIImageView* paddel;
}

-(void) updateDisplay:(CADisplayLink*)sender ;
-(void) endGameWithMessage:(NSString*) message;

@end
