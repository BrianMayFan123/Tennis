//
//  AppDelegate.m
//  Tennis
//
//  Created by Conner Evans on 08/04/2015.
//  Copyright (c) 2015 CocoBongo Games. All rights reserved.
//

#import "AppDelegate.h"
#import "GameScene.h"
#import "MainMenu.h"

@implementation AppDelegate

@synthesize window = _window;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    //GameScene *scene = [GameScene sceneWithSize:CGSizeMake(1024, 768)];
    MainMenu *scene = [MainMenu sceneWithSize:CGSizeMake(1024, 768)];

    /* Set the scale mode to scale to fit the window */
    scene.scaleMode = SKSceneScaleModeAspectFit;

    [self.skView presentScene:scene];

    /* Sprite Kit applies additional optimizations to improve rendering performance */
    self.skView.ignoresSiblingOrder = YES;
    
    self.skView.showsFPS = NO;
    self.skView.showsNodeCount = NO;
}

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)sender {
    return YES;
}

@end
