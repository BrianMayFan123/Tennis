//
//  GameScene.h
//  Tennis
//

//  Copyright (c) 2015 CocoBongo Games. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "Constants.h"
#import "Paddle.h"

@interface GameScene : SKScene <SKPhysicsContactDelegate>

-(void)pauseGame;
-(void)unpauseGame;


@end
