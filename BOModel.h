//
//  BOModel.h
//  BreakOut3b
//
//  Created by Carl Tengwall on 2012-11-06.
//  Copyright (c) 2012 Carl Tengwall. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BOMovingObject.h"
#import "BOBlockView.h"

#define BLOCK_HEIGHT 20.0
#define BLOCK_WIDTH  53.3
#define THICKNESS 2
#define PADDEL_EDGE 0.333
#define ACCEL 0.2           // Every hit on the paddel contributes to a speed change by this relative amount
#define MIN_CHANGE 15       // To ensure that we have a finite speed
#define VIEW_WIDTH 320.0
#define VIEW_HEIGHT 366.0
#define MARGIN 0.05
#define SHRINK_FACTOR 0.9
#define TOP_OFFSET 20

@interface BOModel : NSObject {
    NSMutableArray* blocks;
    CGRect paddelRect;
    CGRect moSquare;
    CGPoint moVelocity;
    CGFloat timeOld;
    CGFloat timeDiff;
    CGFloat timeStart;
    CGFloat timeElapsed;
    int score;
}

@property (readonly) NSMutableArray* blocks;
@property (readonly) CGRect moSquare;
@property CGRect paddelRect;
@property (nonatomic) int score;
@property (nonatomic) CGFloat timeElapsed;


- (void) updateModelWithTime:(CFTimeInterval) timestamp;
- (void) checkCollisionWithBlocks;
- (void) checkCollisionWithPaddel;
- (void) clearScreen;



@end
