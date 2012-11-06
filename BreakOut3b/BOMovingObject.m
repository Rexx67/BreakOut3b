//
//  BOMovingObject.m
//  BreakOut3b
//
//  Created by Carl Tengwall on 2012-11-06.
//  Copyright (c) 2012 Carl Tengwall. All rights reserved.
//

#import "BOMovingObject.h"

@interface BOMovingObject() {
    float speed;                // Keep the speed private
}
@property float speed;
@end

@implementation BOMovingObject

@synthesize speed = _speed;
@synthesize direction = _direction;
@synthesize position = _position;
@synthesize velocity = _velocity;


- (id)initAtPosition: (CGPoint) pos
{
    self = [super init];
    if (self) {
        _position = pos;
        _speed = MO_SPEED;
        _direction = CGPointMake(MO_DIR_X,MO_DIR_Y);
        _velocity = CGPointMake(_speed*_direction.x, _speed*_direction.y);
    }
    return self;
}

@end