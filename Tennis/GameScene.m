//
//  GameScene.m
//  Tennis
//
//  Created by Conner Evans on 08/04/2015.
//  Copyright (c) 2015 CocoBongo Games. All rights reserved.
//

#import "GameScene.h"
#import "GameOver.h"

@interface GameScene()

@property (nonatomic, strong) Paddle *computerPaddle;
@property (nonatomic, strong) Paddle *playerPaddle;
@property (nonatomic, strong) SKSpriteNode * ball;

@property (nonatomic, assign) CGPoint previousLocation;
@property (nonatomic, assign) CGPoint currentLocation;

@property (nonatomic, assign) BOOL gamePaused;
@property (nonatomic, assign) BOOL gameStarted;
@property (nonatomic, assign) BOOL moveUp;
@property (nonatomic, assign) BOOL moveDown;
@property (nonatomic, assign) BOOL bounceUp;
@property (nonatomic, assign) BOOL bounceLeft;

@property (nonatomic, assign) CGFloat ballVelocityX;
@property (nonatomic, assign) CGFloat ballVelocityY;
@property (nonatomic, assign) CGFloat computerPaddleVelocityY;
@property (nonatomic, assign) CGFloat fixedPositionXForPlayer;
@property (nonatomic, assign) CGFloat fixedPositionXForComputer;
@property (nonatomic, assign) CGFloat ballVelocityModifier;

@property (nonatomic, assign) NSUInteger playerScore;
@property (nonatomic, assign) NSUInteger computerScore;
@property (nonatomic, assign) NSUInteger hitCounter;

@property (nonatomic, strong) SKLabelNode *playerScoreLabel;
@property (nonatomic, strong) SKLabelNode *computerScoreLabel;
@property (nonatomic, strong) SKLabelNode *pauseLabel;

@property (nonatomic, strong) SKAction *fadeOutAction;
@property (nonatomic, strong) SKAction *fadeInAction;
@property (nonatomic, strong) SKAction *blipAction;



@end

@implementation GameScene


-(id)initWithSize:(CGSize)size
{
    if (self = [super initWithSize:size])
    {
        //Scene background color and gravity
        self.backgroundColor = [NSColor colorWithCalibratedRed:0.1 green:0.1 blue:0.1 alpha:1];
        self.physicsWorld.contactDelegate = self;
        self.physicsWorld.gravity = CGVectorMake(0, 0);
        
        self.gameStarted = NO;
        self.gamePaused = NO;
        
        //Paddle Initialization
        self.fixedPositionXForPlayer = (CGRectGetMaxX(self.frame) - PADDLE_SIZE.width/2) - PADDING;
        self.playerPaddle = [[Paddle alloc] initWithColor:[NSColor whiteColor] size: PADDLE_SIZE];
        [self addChild:self.playerPaddle];
        
        self.fixedPositionXForComputer = (CGRectGetMinX(self.frame) + PADDLE_SIZE.width/2) + PADDING;
        self.computerPaddle = [[Paddle alloc] initWithColor:[NSColor whiteColor] size:PADDLE_SIZE];
        [self addChild:self.computerPaddle];
        
        
        //Ball Initialisztion
        self.ball = [SKSpriteNode spriteNodeWithColor:[NSColor whiteColor] size:CGSizeMake(20, 20)];
        self.ball.name = @"Ball";
        self.ball.color = [NSColor whiteColor];
        self.ball.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.ball.size];
        self.ball.physicsBody.categoryBitMask = BallCategory;
        self.ball.physicsBody.contactTestBitMask = PaddleCategory;
        self.ball.physicsBody.friction = 0.0f;
        self.ball.physicsBody.mass = 0.0f;
        self.ball.physicsBody.velocity = CGVectorMake(0, 0);
        [self addChild:self.ball];
        
        
        //Actions
        self.fadeInAction = [SKAction fadeInWithDuration:0.5];
        self.fadeOutAction = [SKAction fadeOutWithDuration:0.5];
        self.blipAction = [SKAction playSoundFileNamed:@"blip1.wav" waitForCompletion:NO];
        
        
        //Score Labels
        self.playerScoreLabel = [SKLabelNode labelNodeWithFontNamed:@"Press Start 2P"];
        self.playerScoreLabel.fontSize = 44;
        self.playerScoreLabel.position = CGPointMake(CGRectGetMidX(self.frame) + 100, CGRectGetMaxY(self.frame) - 85);
        [self addChild:self.playerScoreLabel];
        
        self.computerScoreLabel = [SKLabelNode labelNodeWithFontNamed:@"Press Start 2P"];
        self.computerScoreLabel.fontSize = 44;
        self.computerScoreLabel.position = CGPointMake(CGRectGetMidX(self.frame) - 100, CGRectGetMaxY(self.frame) - 85);
        [self addChild:self.computerScoreLabel];
        
        //Pause Label
        self.pauseLabel = [[SKLabelNode alloc] initWithFontNamed:@"Press Start 2P"];
        self.pauseLabel.fontSize = 70;
        self.pauseLabel.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
        self.pauseLabel.text = nil;
        [self addChild:self.pauseLabel];
        
        //centre marker
        CGMutablePathRef midPath = CGPathCreateMutable();
        CGPathMoveToPoint(midPath, NULL, CGRectGetMidX(self.frame), CGRectGetMaxY(self.frame));
        CGPathAddLineToPoint(midPath, NULL, CGRectGetMidX(self.frame), CGRectGetMinY(self.frame));
        SKShapeNode * centreLine = [SKShapeNode node];
        centreLine.path = midPath;
        centreLine.strokeColor = [NSColor whiteColor];
        [self addChild:centreLine];
        CGPathRelease(midPath);
        
        _playerScore = 10;
                                                                                        
        
    }
    
    return self;
}

//Keyboard events

-(void)keyUp:(NSEvent *) theEvent
{
    [self handleKeyEvent:theEvent keyDown:NO];
}

-(void)keyDown:(NSEvent *)theEvent
{
    if ([theEvent keyCode] == SPACEBAR)
    {
        [self togglePause];
    }
    
    [self handleKeyEvent:theEvent keyDown:YES];
    
}

-(void)handleKeyEvent:(NSEvent*)theEvent keyDown:(BOOL)isKeyDown
{
    if ([theEvent keyCode] == MOVE_UP)
    {
        self.moveUp = isKeyDown;
    }
    else if ([theEvent keyCode] == MOVE_DOWN)
    {
        self.moveDown = isKeyDown;
    }
    
}

-(void)startGame
{
    self.gameStarted = YES;
    
    self.playerScore = 0;
    self.computerScore = 0;
    self.hitCounter = 0;
    
    self.playerPaddle.position = CGPointMake(self.fixedPositionXForPlayer, CGRectGetMidY(self.frame));
    self.computerPaddle.position = CGPointMake(self.fixedPositionXForComputer, CGRectGetMidY(self.frame));
    
    [self resetPositions];
}

-(void)pauseGame
{
    self.gamePaused = YES;
    if (!self.pauseLabel.text)
    {
        self.pauseLabel.text = @"Paused";
    }
    [self.pauseLabel runAction:self.fadeInAction];
}

-(void)unpauseGame
{
    self.gamePaused = NO;
    [self.pauseLabel runAction:self.fadeOutAction];
}

-(void)togglePause
{
    if (self.gamePaused)
        [self unpauseGame];
    else
        [self pauseGame];
}




//Restarts gamescene and moves ball in random direction
-(void)resetPositions
{
    self.ballVelocityX = CGRectGetMidX(self.frame);
    self.ballVelocityY = CGRectGetMidY(self.frame);
    self.ball.position = CGPointMake(self.ballVelocityX, self.ballVelocityY);
    
    
}

-(CGFloat)randomAngle
{
    return [self randomNumberFrom:21 To:28] * M_PI / 100;
}

-(int)randomNumberFrom:(int)low To:(int)high
{
    return low + arc4random() % (high - low + 1);
    
}

-(CGFloat)randomPercentageFrom:(int)low To:(int)high
{
    return ([self randomNumberFrom:low To:high] / 100.0);
}

-(BOOL)reachedBottom:(Paddle*) paddle
{
    return CGRectGetMinY(self.frame) > (paddle.position.y - paddle.size.height/2 +7);
}

-(BOOL)reachedTop:(Paddle*) paddle
{
    return CGRectGetMaxY(self.frame) <= (paddle.position.y + paddle.size.height/2 + 7 );
}




//- (void)keyDown:(NSEvent *)event {
//    [self handleKeyEvent:event keyDown:YES];
//}
//
//- (void)keyUp:(NSEvent *)event {
//    [self handleKeyEvent:event keyDown:NO];
//}

//- (void)handleKeyEvent:(NSEvent *)event keyDown:(BOOL)downOrUp
//{
//    // First check the arrow keys since they are on the numeric keypad.
//    if ([event modifierFlags] & NSNumericPadKeyMask)
//    { // arrow keys have this mask
//        NSString *theArrow = [event charactersIgnoringModifiers];
//        unichar keyChar = 0;
//        if ([theArrow length] == 1)
//        {
//            keyChar = [theArrow characterAtIndex:0];
//            switch (keyChar)
//            {
//                case NSUpArrowFunctionKey:
//                {
//                    //SKAction *moveUp = [SKAction moveByX:0 y:20 duration:0];
//                    //[player runAction:moveUp];
//                    [leftPaddle.physicsBody applyImpulse:CGVectorMake(0, 5)];
//
//                }
//                    break;
//                case NSDownArrowFunctionKey:
//                {
//                    [leftPaddle.physicsBody applyImpulse:CGVectorMake(0, -5)];
//                }
//                    break;
//            }
//        }
//    }
//
//    // Now check the rest of the keyboard
//    NSString *characters = [event characters];
//    for (int s = 0; s<[characters length]; s++)
//    {
//        unichar character = [characters characterAtIndex:s];
//        switch (character)
//        {
//            case 'w':
//                NSLog(@" W key pressed!");
//                break;
//            case 'a':
//                NSLog(@" A key pressed!");
//                break;
//            case 'd':
//                NSLog(@" D key pressed!");
//                break;
//        }
//    }
//}
//

#pragma mark - Updates

-(void)update:(CFTimeInterval)currentTime
{
    /* Called before each frame is rendered */
    
    if (!self.gameStarted)
    {
        [self startGame];
    }
    
    if (self.gamePaused)
    {
        return;
    }
    
    
    //Ball movement
    float boostBallSpeed = (self.hitCounter * 0.2);
    float currentBallVelocityY = (BALL_SPEED * self.ballVelocityModifier) + boostBallSpeed;
    float speedDifference = (BALL_SPEED - currentBallVelocityY) + boostBallSpeed;
    if (self.bounceUp)
    {
        self.ballVelocityY += currentBallVelocityY;
    }
    else
    {
        self.ballVelocityY -= currentBallVelocityY;
    }
    
    if (self.bounceLeft)
    {
        self.ballVelocityX -= (BALL_SPEED + speedDifference);
    }
    else
    {
        self.ballVelocityX += (BALL_SPEED + speedDifference);
    }
    
    self.ball.position = CGPointMake(self.ballVelocityX, self.ballVelocityY);
    
    //Ball movement when it hit the top or bottom
    if (self.ballVelocityY >= self.frame.size.height - self.ball.size.height/2)
    {
        self.bounceUp = NO;
        //self.ballVelocityModifier = tan([self randomAngle]);
    }
    else if (self.ballVelocityY <= self.ball.size.height/2)
    {
        self.bounceUp = YES;
        self.ballVelocityModifier = tan([self randomAngle]);
    }
    
    // Ball Movement when it hits the sides
    if (self.ballVelocityX >= self.frame.size.width + self.ball.size.width * 2)
    {
        self.computerScore++;
        [self resetPositions];
    }
    else if (self.ballVelocityX < self.ball.size.width/10)
    {
        self.playerScore++;
        [self resetPositions];
    }
    
    
    //Move player paddle
    if (self.moveUp && ![self reachedTop:self.playerPaddle])
    {
        CGPoint currentPosition = self.playerPaddle.position;
        self.playerPaddle.position = CGPointMake(self.fixedPositionXForPlayer, currentPosition.y + PADDLE_SPEED);
    }
    else if (self.moveDown && ![self reachedBottom:self.playerPaddle])
    {
        CGPoint currentPosition = self.playerPaddle.position;
        self.playerPaddle.position = CGPointMake(self.fixedPositionXForPlayer, currentPosition.y - PADDLE_SPEED);
    }
    
    
    if (self.playerPaddle.position.x != self.fixedPositionXForPlayer)
    {
        CGPoint currentPosition = self.playerPaddle.position;
        self.playerPaddle.position = CGPointMake(self.fixedPositionXForPlayer, currentPosition.y);
    }
    
    
    //move compouter paddle
    self.computerPaddle.position = CGPointMake(self.computerPaddle.position.x, self.ballVelocityY * CPU_THROTTLE + boostBallSpeed);
    if ([self reachedTop:self.computerPaddle])
    {
        self.computerPaddle.position = CGPointMake(self.computerPaddle.position.x, CGRectGetMaxY(self.frame) - PADDLE_PADDING);
    }
    else if ([self reachedBottom:self.computerPaddle])
    {
        self.computerPaddle.position = CGPointMake(self.computerPaddle.position.x, CGRectGetMinY(self.frame) + PADDLE_PADDING);
    }
    
    if (self.computerPaddle.position.x != self.fixedPositionXForComputer)
    {
        CGPoint computerCurrentPosition = self.computerPaddle.position;
        self.computerPaddle.position = CGPointMake(self.fixedPositionXForComputer, computerCurrentPosition.y);
    }
    
    
    
    //Win/Lose logic
    if (_playerScore == 11)
    {
        GameOver *gameOverScene = [[GameOver alloc] initWithSize:self.frame.size playerWon: YES];
        [self.view presentScene:gameOverScene];
    }
    
    if (_computerScore == 11)
    {
        GameOver *gameOverScene = [[GameOver alloc] initWithSize:self.frame.size playerWon: NO];
        [self.view presentScene:gameOverScene];
    }
    
}

- (void)didBeginContact:(SKPhysicsContact*)contact
{
    
    BOOL ballTouched   = contact.bodyA.categoryBitMask == PaddleCategory;
    BOOL paddleTouched = contact.bodyB.categoryBitMask == BallCategory;
    
    if (ballTouched && paddleTouched)
    {
        
        ++self.hitCounter;
        
        // Apply some force
        if (self.moveUp)
        {
            self.bounceUp = YES;
        }
        else if (self.moveDown)
        {
            self.bounceUp = NO;
        }
        
        self.bounceLeft = !self.bounceLeft;
        self.ballVelocityModifier = tanf([self randomAngle]);
        
        [self runAction:self.blipAction];
    }
}

-(void)setPlayerScore:(NSUInteger)playerScore
{
    _playerScore = playerScore;
    self.playerScoreLabel.text = [NSString stringWithFormat:@"%lu", _playerScore];
    
}

-(void)setComputerScore:(NSUInteger)computerScore
{
    _computerScore = computerScore;
    self.computerScoreLabel.text = [NSString stringWithFormat:@"%lu", _computerScore];
}


@end
