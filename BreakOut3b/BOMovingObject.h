//
//  BOMovingObject.h
//  BreakOut3b
//
//  Created by Carl Tengwall on 2012-11-06.
//  Copyright (c) 2012 Carl Tengwall. All rights reserved.
//

#import <Foundation/Foundation.h>

#define MO_SIZE 10
#define MO_SPEED 200
#define MO_X 180.0
#define MO_Y 220.0
#define MO_POS_X 180.0
#define MO_POS_Y 220.0
#define MO_DIR_X 1.0
#define MO_DIR_Y -1.0

@interface BOMovingObject : NSObject 


@property (nonatomic, assign) CGPoint direction;
@property (nonatomic, assign) CGPoint position;
@property (nonatomic, assign) CGPoint velocity;

- (id) initAtPosition: (CGPoint) pos;

@end


