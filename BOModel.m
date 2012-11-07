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
        [self checkCollisionWithScreenEdges];
        
        
        // Do collision detection with blocks
        [self checkCollisionWithBlocks];
        
        // Do collision detection with paddel
        [self checkCollisionWithPaddel];
        
    }
    
}


@end

