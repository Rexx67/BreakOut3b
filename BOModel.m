//
//  BOModel.m
//  BreakOut3b
//
//  Created by Carl Tengwall on 2012-11-06.
//  Copyright (c) 2012 Carl Tengwall. All rights reserved.
//

#import "BOModel.h"

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
        
        // Set the paddel rect by using the size of the paddel image
        UIImage* paddelImage = [UIImage imageNamed:@"paddel.png"];
        CGSize paddelSize = [paddelImage size];
        _paddelRect = CGRectMake(0.0, 420.0,
                                paddelSize.width, paddelSize.height);
        
        // Set the mo rect by using the size of the mo image
        UIImage* moImage = [UIImage imageNamed:@"mo.png"];
        CGSize moSize = [moImage size];
        _moSquare = CGRectMake(180.0, 220.0,
                              moSize.width, moSize.height);
        
        // Set the initial velocity for the mo
        moVelocity = CGPointMake(200.0, -200.0);
        
        // Initialize the lastTime
        lastTime = 0.0;
        
    }
    
    return self;
}

- (void) checkCollisionWithScreenEdges {
    // Change mo direction if it hit an edge of the screen
    // Left edge
    if (_moSquare.origin.x <= 0)
    {
        // Flip the x velocity component
        moVelocity.x = abs(moVelocity.x);
    }
    
    // Right edge
    if (_moSquare.origin.x >= VIEW_WIDTH - MO_SIZE)
    {
        // Flip the x velocity component
        moVelocity.x = -1 * abs(moVelocity.x);
    }
    
    // Top edge
    if (_moSquare.origin.y <=  0)
    {
        // Flip the x velocity component
        moVelocity.y = abs(moVelocity.y);
    }
    
    // Bottom edge
    if (_moSquare.origin.y >=  VIEW_HEIGHT - MO_SIZE)
    {
        // [Just let the mo bounce back!]
        // mo went off the bottom of the screen
        // In a production game, you'd want to reduce the player's
        // mo count by one and reset the mo.  To keep this example
        // simple, we are not keeping score or mo count. We'll
        // just reset the mo
        
        //_ moSquare.origin.x = 180.0;
        //_ moSquare.origin.y = 220.0;
        
        // Flip the y velocity component
        moVelocity.y = -1*abs(moVelocity.y);
        
        
    }
    
}

- (void) checkCollisionWithBlocks {
    // Iterate over the blocks to see if a collision has happened
    for (BOBlockView* bobv in _blocks) {
        if (CGRectIntersectsRect(bobv.frame,_moSquare)) {
            // [Here we should check whether it intersect with the bottom or top
            // of a block.  If not, we should flip the x-component instead]
            // Flip the y velocity component
            moVelocity.y = -moVelocity.y;
            
            // Remove the block from the collection
            [_blocks removeObject:bobv];
            
            // remove the block's view from the superview
            [bobv removeFromSuperview];
            
            
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
        // [Here we should check whether it intersect with the bottom or top
        // of a block.  If not, we should flip the x-component instead]
        // Flip the y velocity component
        moVelocity.y = -1 * abs( moVelocity.y);
        
    }
}

-(void) updateModelWithTime:(CFTimeInterval) timestamp{
    if (lastTime == 0.0)
    {
        // First time through, initialize the lastTime
        lastTime = timestamp;
    }
    else
    {
        // Calculate time elapsed since last call
        timeDelta = timestamp - lastTime;
        
        // Update the lastTime
        lastTime = timestamp;
        
        // Calculate new position of the mo
        _moSquare.origin.x += moVelocity.x * timeDelta;
        _moSquare.origin.y += moVelocity.y * timeDelta;
        
        // Check for collision with screen edges
        [self checkCollisionWithScreenEdges];
        
        
        // Do collision detection with blocks
        [self checkCollisionWithBlocks];
        
        // Do collision detection with paddel
        [self checkCollisionWithPaddel];
        
    }
    
}


@end

