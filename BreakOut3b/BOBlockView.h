//
//  BOBlockView.h
//  BreakOut3b
//
//  Created by Carl Tengwall on 2012-11-06.
//  Copyright (c) 2012 Carl Tengwall. All rights reserved.
//

#import <UIKit/UIKit.h>


#define BLUE_COLOR 0
#define GREEN_COLOR 1
#define RED_COLOR 2
#define YELLOW_COLOR 3
#define CYAN_COLOR 4
#define MAGENTA_COLOR 5


@interface BOBlockView : UIView {
    
    int color;
}

- (id)initWithFrame:(CGRect)frame color:(int) inputColor;

@property int color;

@end

