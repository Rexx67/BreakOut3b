//
//  BOBlockView.m
//  BreakOut3b
//
//  Created by Carl Tengwall on 2012-11-06.
//  Copyright (c) 2012 Carl Tengwall. All rights reserved.
//

#import "BOBlockView.h"

@implementation BOBlockView

@synthesize color = _color;
@synthesize blockLayer;

- (id)initWithFrame:(CGRect)frame color:(int) inputColor;
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.color = inputColor;
        
        
    /*    NSLog(@"Frame x=%f, y=%f, width=%f, height=%f",
              self.frame.origin.x,
              self.frame.origin.y,
              self.frame.size.width,
              self.frame.size.height); */
        
        // Create new Layer object
        blockLayer = [[CALayer alloc] init];
        
        // Give it a size
        [blockLayer setBounds:CGRectMake(0, 0, self.frame.size.width,self.frame.size.height)];
        
        // Give it a position
        [blockLayer setPosition:CGPointMake(0.5*self.frame.size.width,
                                            0.5*self.frame.size.height)];
        
        // Make a color
        UIColor *transparent = [UIColor colorWithRed:0.0 green: 0.0 blue: 0.0 alpha: 0.0];
        
        // Get a CGColor objectwith the same color value
        CGColorRef cgTransparent = [transparent CGColor];
        [blockLayer setBackgroundColor:cgTransparent];
        
        // Make it a subview of the view's layer
        [[self layer] addSublayer:blockLayer];
        
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.

- (void)drawRect:(CGRect)rect
{
    float viewWidth, viewHeight;
	viewWidth = self.bounds.size.width;
	viewHeight = self.bounds.size.height;
    
	//	Get the drawing context
	CGContextRef context =  UIGraphicsGetCurrentContext ();
	
    // Define a rect in the shape of the block
    CGRect blockRect = CGRectMake(0, 0,  viewWidth, viewHeight);
    
    // Define a path using the rect
    UIBezierPath* path = [UIBezierPath bezierPathWithRect:blockRect];
    
    // Set the line width of the path
    path.lineWidth = 2.0;
    
    //	Define a gradient to use to fill the blocks
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	CGGradientRef myGradient;
    int num_locations = 2;
    CGFloat locations[2] = { 0.0, 1.0 };
    
    CGFloat components[8] = { 0.0, 0.0, 0.0, 1.0,  // Start color
        0.0, 0.0, 0.0, 1.0 }; // End color
    //_Orig:    1.0, 1.0, 1.0, 1.0 }; // End color
    
    // Determine gradient color based on color property
    switch (self.color) {
        case RED_COLOR:
            // Red Block
            components[0] = 1.0;
            components[4] = 1.0; // Uniform  color
            break;
        case GREEN_COLOR:
            // Green Block
            components[1] = 1.0;
            components[5] = 1.0; // Uniform  color
            break;
        case BLUE_COLOR:
            // Blue Block
            components[2] = 1.0;
            components[6] = 1.0; // Uniform  color
            break;
        case YELLOW_COLOR:
            // Yellow Block
            components[0] = 1.0;
            components[1] = 1.0;
            components[4] = 1.0; // Uniform  col
            components[5] = 1.0;
            break;
        case CYAN_COLOR:
            // Cyan Block
            components[1] = 1.0;
            components[2] = 1.0;
            components[5] = 1.0; // Uniform  col
            components[6] = 1.0;
            break;
        case MAGENTA_COLOR:
            // Cyan Block
            components[0] = 1.0;
            components[2] = 1.0;
            components[4] = 1.0; // Uniform  col
            components[6] = 1.0;
            break;


        default:
            break;
    }
    
    myGradient = CGGradientCreateWithColorComponents (colorSpace, components,
                                                      locations, num_locations);
    
    CGContextDrawLinearGradient (context, myGradient, CGPointMake(0, 0),
                                 CGPointMake(viewWidth, 0), 0);
    
	//	Clean up the color space & gradient
	CGColorSpaceRelease(colorSpace);
	CGGradientRelease(myGradient);
	
    // Stroke the path
	[path stroke];
    
}

@end
