//
//  MainMenu.m
//  Tennis
//
//  Created by Conner Evans on 12/04/2015.
//  Copyright (c) 2015 CocoBongo Games. All rights reserved.
//

#import "MainMenu.h"
#import "GameScene.h"

@implementation MainMenu

-(id)initWithSize:(CGSize)size
{
    if (self = [super initWithSize:size])
    {
        /* Setup your scene here */
        SKLabelNode *titleLabel = [SKLabelNode labelNodeWithFontNamed:@"Press Start 2P"];
    
        titleLabel.text = @"Tennis";
        titleLabel.fontSize = 65;
        titleLabel.position = CGPointMake(CGRectGetMidX(self.frame),
                                       CGRectGetMaxY(self.frame) * 0.9);

        SKLabelNode *Label1 = [SKLabelNode labelNodeWithFontNamed:@"Press Start 2P"];
        
        Label1.text = @"Use W to move up and S to move down";
        Label1.fontSize = 25;
        Label1.position = CGPointMake(CGRectGetMidX(self.frame),
                                       CGRectGetMaxY(self.frame) * 0.7);
        
        SKLabelNode *Label2 = [SKLabelNode labelNodeWithFontNamed:@"Press Start 2P"];
        
        Label2.text = @"Press space to pause and start the game";
        Label2.fontSize = 25;
        Label2.position = CGPointMake(CGRectGetMidX(self.frame),
                                      CGRectGetMaxY(self.frame) * 0.6);
        
        SKLabelNode *Label3 = [SKLabelNode labelNodeWithFontNamed:@"Press Start 2P"];
        
        Label3.text = @"Press SPACE to start";
        Label3.fontSize = 35;
        Label3.position = CGPointMake(CGRectGetMidX(self.frame),
                                      CGRectGetMaxY(self.frame) * 0.2);
        
        SKLabelNode *copyrightLabel = [SKLabelNode labelNodeWithFontNamed:@"Press Start 2P"];
        
        copyrightLabel.text = @"Copyright ©2015 Conner Evans";
        copyrightLabel.fontSize = 18;
        copyrightLabel.position = CGPointMake(CGRectGetMidX(self.frame),
                                      CGRectGetMinY(self.frame) + 10 );
        
        
        [self addChild:titleLabel];
        [self addChild:Label1];
        [self addChild:Label2];
        [self addChild:Label3];
        [self addChild:copyrightLabel];

    }
    return self;
}

-(void)keyDown:(NSEvent *)theEvent
{
    if ([theEvent keyCode] == SPACEBAR)
    {
        GameScene * Game = [[GameScene alloc] initWithSize:self.frame.size];
        [self.view presentScene:Game];
    }
    
}


@end
