//
//  Paddle.m
//  Tennis
//
//  Created by Conner Evans on 13/05/2015.
//  Copyright (c) 2015 CocoBongo Games. All rights reserved.
//

#import "Paddle.h"

@implementation Paddle

-(instancetype)initWithColor:(NSColor *)color size:(CGSize)size
{
    self = [super initWithColor:color size:size];
    
    if (self)
        [self setUp];
    
    return self;
}

-(void)setUp
{
    self.name = @"Paddle";
    self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:PADDLE_SIZE];
    self.physicsBody.categoryBitMask = PaddleCategory;
    self.physicsBody.allowsRotation = NO;
    self.physicsBody.friction = 0.0;
    self.physicsBody.mass = 0.0f;
}

@end
