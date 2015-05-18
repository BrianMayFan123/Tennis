//
//  GameOver.m
//  Tennis
//
//  Created by Conner Evans on 17/05/2015.
//  Copyright (c) 2015 CocoBongo Games. All rights reserved.
//

#import "GameOver.h"
#import "MainMenu.h"
#import "Constants.h"

@implementation GameOver

-(id)initWithSize:(CGSize)size playerWon:(BOOL)isWon
{
    if (self = [super initWithSize:size])
    {
        /* Setup your scene here */
        SKLabelNode *wonLabel = [SKLabelNode labelNodeWithFontNamed:@"Press Start 2P"];
        
        wonLabel.fontSize = 65;
        wonLabel.position = CGPointMake(CGRectGetMidX(self.frame),
                                          CGRectGetMaxY(self.frame) * 0.7);
        
        if (isWon == YES)
        {
            wonLabel.text = @"You Won!";
        }
        else if (isWon == NO)
        {
            wonLabel.text = @"You Lose!";
        }
        
        
        SKLabelNode *Label1 = [SKLabelNode labelNodeWithFontNamed:@"Press Start 2P"];
        Label1.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMaxY(self.frame) * 0.5);
        Label1.text = @"Press SPACE to continue";
        Label1.fontSize = 35;
        
        [self addChild:wonLabel];
        [self addChild:Label1];
        
    }
    return self;
}

-(void)keyDown:(NSEvent *)theEvent
{
    if ([theEvent keyCode] == SPACEBAR)
    {
        MainMenu * returnToMenu = [[MainMenu alloc] initWithSize:self.frame.size];
        [self.view presentScene:returnToMenu];
    }
    
}

@end
