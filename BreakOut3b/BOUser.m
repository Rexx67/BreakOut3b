//
//  BOUser.m
//  BreakOut3b
//
//  Created by Carl Tengwall on 2012-11-09.
//  Copyright (c) 2012 Carl Tengwall. All rights reserved.
//

#import "BOUser.h"

@implementation BOUser


@synthesize userId = _userId;
@synthesize difficulty = _difficulty;
@synthesize score = _score;
@synthesize backgroundColor = _backgroundColor;

// Constructor

- (id)initWithId:(NSString *) uid difficulty:(NSNumber *)diff score:(NSNumber *) aScore andBackground: (NSNumber *) bkgColor {
    self = [super init];
    
    if (self) {
        _userId = uid;
        _difficulty = diff;
        _score = aScore;
        _backgroundColor = bkgColor;
        //_ NSLog(@"bkgColor %@", bkgColor);
    }
    
    return self;
}

@end
