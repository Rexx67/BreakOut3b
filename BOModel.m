//
//  BOModel.m
//  BreakOut3b
//
//  Created by Carl Tengwall on 2012-11-06.
//  Copyright (c) 2012 Carl Tengwall. All rights reserved.
//

#import "BOModel.h"

@interface BOModel ()
    -(BOOL)flipY:(CGRect) obstruction;
@end

@implementation BOModel

@synthesize blocks = _blocks;
@synthesize moSquare = _moSquare;
@synthesize paddelRect = _paddelRect;

- (id)init {
    self = [super init];
    
    if (self) {
        // Init blocks
        // The array to hold the blocks
        _blocks = [[NSMutableArray alloc] initWithCapacity:30];
        
        BOBlockView* bobv;
        
        for (int row = 0; row<=5; row++)
        {
            for (int col = 0; col<6; col++)
            {
                bobv = [[BOBlockView alloc ]
                      initWithFrame: CGRectMake( MARGIN * BLOCK_WIDTH + col * BLOCK_WIDTH ,
                                                TOP_OFFSET + MARGIN * BLOCK_HEIGHT + row * BLOCK_HEIGHT,
                                                SHRINK_FACTOR * BLOCK_WIDTH, SHRINK_FACTOR * BLOCK_HEIGHT)
                      color:(row)];
                
                //	Add the tile to the view
                [_blocks addObject:bobv];
                
            }
        }
        
        // Set Paddel Rect to the size of the Paddel image
        UIImage* paddelImage = [UIImage imageNamed:@"paddel.png"];
        CGSize paddelSize = [paddelImage size];
        _paddelRect = CGRectMake(0.0, 420.0,
                                paddelSize.width, paddelSize.height);
        
        BOMovingObject *bomo = [[BOMovingObject alloc] initAtPosition:CGPointMake(MO_POS_X, MO_POS_Y)];
    
        // Get the initial velocity vector for the Moving Object
        moVelocity = bomo.velocity;

        // Set Moving Object Rect to the size of the Moving Object image
        UIImage* moImage = [UIImage imageNamed:@"mo.png"];
        CGSize moSize = [moImage size];
        _moSquare = CGRectMake(bomo.position.x,
                               bomo.position.y,
                               moSize.width, moSize.height);
        
               
        // Initialize the lastTime
        timeOld = 0.0;
        
    }
    
    return self;
}

-(void) updateModelWithTime:(CFTimeInterval) timeNew {
    if (timeOld == 0.0)
    {
        // First time through, initialize timeOld
        timeOld  = timeNew;
    }
    else
    {
        timeDiff = timeNew - timeOld;
        
        // Remember the new time for next pass
        timeOld = timeNew;
        
        // Calculate new position of the mo
        _moSquare.origin.x += moVelocity.x * timeDiff;
        _moSquare.origin.y += moVelocity.y * timeDiff;
        
        // Check for collision with screen edges
        //_[self checkCollisionWithScreenEdges];
        // Handle collision with bounds by resetting direction if needed
        while([self changeDirectionForBounds])
        {
            // Calculate new position  based on updated velocity vector
            _moSquare.origin.x += moVelocity.x * timeDiff;
            _moSquare.origin.y += moVelocity.y * timeDiff;
        }
        
        // Do collision detection with blocks
        [self checkCollisionWithBlocks];
        
        // Do collision detection with paddel
        [self checkCollisionWithPaddel];
        
    }
    
}

- (BOOL) changeDirectionForBounds{
    
    // Change ball direction if it hit an edge of the screen

    BOOL hitBounds = NO;
    if ([self hitLeft])
    {
        moVelocity.x = abs(moVelocity.x);
        hitBounds = YES;
    }
    
    if ([self hitRight])
    {
        moVelocity.x = -1 * abs(moVelocity.x);
        hitBounds = YES;
    }
    
    if ([self hitTop])
    {
        moVelocity.y = abs(moVelocity.y);
        hitBounds = YES;
    }
    
    if ([self hitBottom])
    {
        // [Just let the mo bounce back!]
        // mo went off the bottom of the screen
        // In a production game, you'd want to reduce the player's
        // mo count by one and reset the mo.  To keep this example
        // simple, we are not keeping score or mo count. We'll
        // just reset the mo
        
        //_ moSquare.origin.x = 180.0;
        //_ moSquare.origin.y = 220.0;

        moVelocity.y = -1*abs(moVelocity.y);
        hitBounds = YES;
    }
    return hitBounds;
}

- (BOOL) hitLeft {
	if (_moSquare.origin.x <= 0)
    {
	    NSLog(@"hitLeft");
        return YES;
    }
    else return NO;
}

- (BOOL) hitRight {
    if (_moSquare.origin.x >= VIEW_WIDTH - MO_SIZE)
    {
        NSLog(@"hitRight");
        return YES;
    }
    else return NO;
}

- (BOOL) hitTop {
    if (_moSquare.origin.y <=  0)
    {
        NSLog(@"hitTop");
        return YES;
    }
    else return NO;
}

- (BOOL) hitBottom {
    if (_moSquare.origin.y >=  VIEW_HEIGHT - MO_SIZE)
    {
        NSLog(@"hitBottom");
        return YES;
    }
    else return NO;
}

- (void) checkCollisionWithBlocks {
    // Iterate over the blocks to see if a collision has happened
    for (BOBlockView* bobv in _blocks) {
        if (CGRectIntersectsRect(bobv.frame,_moSquare)) {
            
            if ([self flipY: bobv.frame]) {
                // Flip the y velocity component if we hit top or bottom
                moVelocity.y = -1 * moVelocity.y;
            } else {
                // Flip the x velocity component if we hit eft or right
                moVelocity.y = -1 * moVelocity.x;
            }
            // [Here we should check whether it intersect with the bottom or top
            // of a block.  If not, we should flip the x-component instead]
            // Flip the y velocity component
           // moVelocity.y = -moVelocity.y;
            
            // Animate the removal of the block
            
            // Make a CGColor
            CGColorRef cgOpaque = [[UIColor colorWithRed:1.0 green: 1.0 blue: 1.0 alpha: 1.0] CGColor];
            
            // Change the duration of the implict animation
            [CATransaction setValue:[NSNumber numberWithFloat:1.0f]
                             forKey:kCATransactionAnimationDuration];
            
            [bobv.blockLayer setBackgroundColor:cgOpaque];
            
            // Remove the block from the collection
            [_blocks removeObject:bobv];
            
            // Before we used animation this was the way to get rid of a block view
            //    [bobv removeFromSuperview];
            
            
            // In a production game, you'd want to add to the player's score
            // here, when a block is hit. To keep this example
            // simple, we are not keeping score.
            // [Add score keeping]
            
            break;
        }
        
    }
    
}

- (void) checkCollisionWithPaddel {
    // Check to see if the paddel has blocked the mo
    if (CGRectIntersectsRect(_moSquare,_paddelRect)) {
        
        if ([self flipY: _paddelRect]) {
            // Flip the y velocity component if we hit top or bottom
            moVelocity.y = -1 * moVelocity.y;
        }
            // Before we introduced paddel segmentation this was a way to add some fun
            // else {
            // Flip the x velocity component if we hit eft or right
            // moVelocity.y = -1 * moVelocity.x;
            // }
        
        // Go see how the place where the Moving Object hits affect the velocity vector
        [self changeDirection:_paddelRect];
    }
}

- (BOOL) flipY:(CGRect) obstruction {
    
    CGPoint origin = CGPointMake(obstruction.origin.x,obstruction.origin.y);
    CGSize size = CGSizeMake(obstruction.size.width,obstruction.size.height);
    
    CGRect upper = CGRectMake(origin.x, origin.y, size.width, THICKNESS);
    CGRect lower = CGRectMake(origin.x, origin.y + size.height - THICKNESS,
                              size.width, THICKNESS);
    
    if (CGRectIntersectsRect(_moSquare,upper)||
        CGRectIntersectsRect(_moSquare,lower)) {
        // Flip the y velocity component if we hit top or bottom surface
        return YES;
    } else {
        // Flip the x velocity component if we hit left or right edge
        // NSLog(@"Hit side");
        return NO;
    }
    
}

- (void) changeDirection:(CGRect) rectangle {
    
    CGPoint origin = CGPointMake(rectangle.origin.x,rectangle.origin.y);
    CGSize size = CGSizeMake(rectangle.size.width,rectangle.size.height);
    
    CGRect left = CGRectMake(origin.x,
                             origin.y,
                             PADDEL_EDGE * size.width,
                             THICKNESS);
    
    CGRect center = CGRectMake(origin.x + PADDEL_EDGE * size.width,
                              origin.y,
                              (1 - 2 * PADDEL_EDGE) * size.width,
                              THICKNESS);

    CGRect right = CGRectMake(origin.x,
                              origin.y + (1 - PADDEL_EDGE) * size.width ,
                              PADDEL_EDGE * size.width,
                              THICKNESS);
    
    if (CGRectIntersectsRect(_moSquare,left)){
        // We hit the left part of the paddel
        // Add left momentum
        moVelocity.x = moVelocity.x - ACCEL * abs(moVelocity.x) -MIN_CHANGE;
        //  NSLog(@"Added left momentum");
    }
    
    if (CGRectIntersectsRect(_moSquare,center)){
        // We hit the center part of the paddel
        // Add vertical momentum
        moVelocity.y = moVelocity.y - (ACCEL/2.0) * abs(moVelocity.x) + MIN_CHANGE;
        // NSLog(@"Added vertical momentum");
    }

    if (CGRectIntersectsRect(_moSquare,right)) {
        // We hit the right part of the paddel
        // Add rigt momentum
        moVelocity.x = moVelocity.x + ACCEL * abs(moVelocity.x) + MIN_CHANGE;
        // NSLog(@"Added right momentum");
    }
    
    return;
}



@end

