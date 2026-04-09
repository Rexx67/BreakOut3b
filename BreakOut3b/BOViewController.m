//
//  BOViewController.m
//  BreakOut3b
//
//  Created by Carl Tengwall on 2012-11-06.
//  Copyright (c) 2012 Carl Tengwall. All rights reserved.
//

#import "BOViewController.h"

@interface BOViewController ()

// 2026-04-09:
// The original 2012 controller assumed a full-screen 320x436 playfield and
// relied on raw touch handling plus image-based paddle rendering. During the
// UIScene migration and modern iOS cleanup, the game view was updated to:
// 1. Render the legacy playfield inside a centered fixed-size board view.
// 2. Use a visible UIView-based paddle instead of the old image asset.
// 3. Move the paddle with a pan gesture recognizer instead of touchesMoved:.
// 4. Disable the navigation controller's edge-swipe gesture while playing.
// These changes preserve the original gameplay geometry while restoring stable
// paddle rendering and interaction on current iOS versions.
@property (nonatomic, strong) UIView *gameBoardView;
@property (nonatomic, strong) UIPanGestureRecognizer *paddlePanGesture;

- (void)presentResultAlertWithTitle:(NSString *)title
                            message:(NSString *)message
                         completion:(void (^)(void))completion;
- (void)cleanupGameState;
- (void)rebuildBoardViewIfNeeded;
- (void)clearBoardSubviews;
- (void)handlePaddlePan:(UIPanGestureRecognizer *)gestureRecognizer;

@end


@implementation BOViewController

@synthesize users = _users;
@synthesize delegate = _delegate;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self rebuildBoardViewIfNeeded];
    [self initLevel:0];
    
}
-(void) initLevel:(int) lvl {
    [self rebuildBoardViewIfNeeded];
    gameLevel = lvl;
    NSInteger currentPlayer = [[NSUserDefaults standardUserDefaults] integerForKey:@"currentPlayer"];
    //_ NSLog(@"currentPlayer %d", currentPlayer);
    NSArray *currentScores = [[NSUserDefaults standardUserDefaults] objectForKey:@"scores"];
    NSArray *currentColors = [[NSUserDefaults standardUserDefaults] objectForKey:@"colors"];
    color = [[currentColors objectAtIndex:currentPlayer] intValue];
     //_ NSLog(@"color %d", color);
    maxScore = [[currentScores objectAtIndex:currentPlayer] intValue];
         //_ NSLog(@"maxScore %d", maxScore);
    
    // Initialize the model of the game
    gameModel = [[BOModel alloc] initWithLevel: lvl];
    
    // Draw the Moving Object
    mo = [[UIImageView alloc] initWithImage:
          [UIImage imageNamed:@"mo.png"]];
    
    [mo setFrame:gameModel.moSquare];
    [self.gameBoardView addSubview:mo];
    
    // Draw the Paddel
    paddel = [[UIView alloc] initWithFrame:CGRectZero];
    paddel.backgroundColor = [UIColor blackColor];
    paddel.layer.cornerRadius = 4.0;
    
    CGRect centeredPaddelRect = gameModel.paddelRect;
    centeredPaddelRect.origin.x = floor((VIEW_WIDTH - CGRectGetWidth(centeredPaddelRect)) / 2.0);
    gameModel.paddelRect = centeredPaddelRect;
    [paddel setFrame:gameModel.paddelRect];
    [self.gameBoardView addSubview:paddel];

    
    // Iterate over the blocks in the model, drawing them
    for (BOBlockView* bobv in gameModel.blocks) {
        //	Add the block to the array
        [self.gameBoardView addSubview:bobv];
    }
    [self.gameBoardView bringSubviewToFront:paddel];
    [self.gameBoardView bringSubviewToFront:mo];
    
    switch (color)
    
    {
        case WHITE_BKGCOLOR:
            realColor = [UIColor whiteColor];
            break;
        case LIGHTGRAY_BKGCOLOR:
            realColor = [UIColor lightGrayColor];
            break;
        case GRAY_BKGCOLOR:
            realColor = [UIColor grayColor];
            break;
        case YELLOW_BKGCOLOR:
            realColor = [UIColor yellowColor];
            break;
        default:
            realColor = [UIColor whiteColor];
        break;
    }

     [self.gameBoardView setBackgroundColor:realColor];  // Set user specific background color
    
    
       
    
    
    // Set up the CADisplayLink for the animation
    gameTimer = [CADisplayLink displayLinkWithTarget:self
                                            selector:@selector(gameLoop:)];
    
    
    // Add the display link to the current run loop
    [gameTimer addToRunLoop:[NSRunLoop currentRunLoop]
                    forMode:NSRunLoopCommonModes];
    
    
}

-(void) gameLoop:(CADisplayLink*)sender
{
    // This method is called by the gameTimer each time the display should
    // update
    
    // Update the model
    [gameModel updateModelWithTime:sender.timestamp];
    
    // Update the display
    [mo setFrame:gameModel.moSquare];
    [paddel setFrame:gameModel.paddelRect];
    
    if ([gameModel.blocks count] == 0)
    {
        // No more blocks, end the game on the current level
        // Remove the last blocks from view
        [gameModel clearScreen];
        
        // [The model should return a score and update the top ten list]
        
        NSString *scoreString =[NSString stringWithFormat:@"Score = %d", gameModel.netScore];
        //_ NSLog(@"scoreString=%@", scoreString);
        if (gameLevel<1) [self levelOver:scoreString];
        else [self gameOver:scoreString];
        
    }
    
    
}

-(void) levelOver:(NSString *)message
{
    //_ NSLog(@"BOViewController levelOver");
    // Call this method to end the game
    // Invalidate the timer
    [gameTimer invalidate];
    
    [self presentResultAlertWithTitle:@"Level Over"
                              message:message
                           completion:^{
                               [self clearBoardSubviews];

                               [self->gameModel resetModel:0 color:1];
                               [self initLevel:1];
                           }];
    
}
-(void) gameOver:(NSString *)message
{
    //_ NSLog(@"BOViewController gameOver");
    // Call this method to end the game
    // Invalidate the timer
    [gameTimer invalidate];
    
    [self presentResultAlertWithTitle:@"Game Over"
                              message:message
                           completion:^{
                               [self clearBoardSubviews];

                               [self->gameModel resetModel:0 color:1];
                           }];

}

- (void)presentResultAlertWithTitle:(NSString *)title
                            message:(NSString *)message
                         completion:(void (^)(void))completion
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title
                                                                             message:message
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK"
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction *action) {
                                                         if (completion) {
                                                             completion();
                                                         }
                                                     }];
    [alertController addAction:okAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)cleanupGameState
{
    [gameTimer invalidate];
    [gameModel resetModel:0 color:1];
}

- (void)dealloc
{
    [self cleanupGameState];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self rebuildBoardViewIfNeeded];
}

- (void)viewWillDisappear:(BOOL)animated
{
	 //_ NSLog(@"BOViewController viewWillDisappear");
    [super viewWillDisappear:animated];
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
    [self cleanupGameState];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAllButUpsideDown;
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [self rebuildBoardViewIfNeeded];
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesMoved:touches withEvent:event];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)rebuildBoardViewIfNeeded
{
    CGRect availableBounds = self.view.bounds;
    if (@available(iOS 11.0, *)) {
        UIEdgeInsets safeInsets = self.view.safeAreaInsets;
        availableBounds = UIEdgeInsetsInsetRect(self.view.bounds, safeInsets);
    }

    CGFloat boardX = CGRectGetMinX(availableBounds) + floor((CGRectGetWidth(availableBounds) - VIEW_WIDTH) / 2.0);
    CGFloat boardY = CGRectGetMinY(availableBounds) + floor((CGRectGetHeight(availableBounds) - VIEW_HEIGHT) / 2.0);
    CGRect boardFrame = CGRectMake(boardX, boardY, VIEW_WIDTH, VIEW_HEIGHT);

    if (!self.gameBoardView) {
        self.gameBoardView = [[UIView alloc] initWithFrame:boardFrame];
        self.gameBoardView.clipsToBounds = YES;
        self.paddlePanGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePaddlePan:)];
        [self.gameBoardView addGestureRecognizer:self.paddlePanGesture];
        [self.view addSubview:self.gameBoardView];
    } else {
        self.gameBoardView.frame = boardFrame;
    }
}

- (void)clearBoardSubviews
{
    for (UIView *view in self.gameBoardView.subviews) {
        [view removeFromSuperview];
    }
}

- (void)handlePaddlePan:(UIPanGestureRecognizer *)gestureRecognizer
{
    CGPoint translation = [gestureRecognizer translationInView:self.gameBoardView];
    if (translation.x == 0.0) {
        return;
    }

    CGRect newPaddelRect = gameModel.paddelRect;
    newPaddelRect.origin.x += translation.x;
    CGFloat maxX = VIEW_WIDTH - CGRectGetWidth(newPaddelRect);
    newPaddelRect.origin.x = MIN(MAX(newPaddelRect.origin.x, 0.0), maxX);

    gameModel.paddelRect = newPaddelRect;
    paddel.frame = newPaddelRect;

    [gestureRecognizer setTranslation:CGPointZero inView:self.gameBoardView];
}

@end
