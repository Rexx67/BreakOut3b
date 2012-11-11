//
//  BOUser.h
//  BreakOut3b
//
//  Created by Carl Tengwall on 2012-11-09.
//  Copyright (c) 2012 Carl Tengwall. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BOUser : NSObject

@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSNumber *difficulty;
@property (nonatomic, copy) NSNumber *score;
@property (nonatomic, copy) NSNumber *backgroundColor;

- (id)initWithId:(NSString *) uid difficulty:(NSNumber *)diff score: (NSNumber *) aScore andBackground: (NSNumber *) bkgColor;

@end
