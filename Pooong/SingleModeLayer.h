//
//  SingleModeLayer.h
//  Pooong
//
//  Created by Sofia Maria Natacha Chevrolat on 2/26/13.
//  Copyright 2013 MadDev. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <GameKit/GameKit.h>
#import "cocos2d.h"
#import "Box2D.h"
#import "GLES-Render.h"
#import "Paddle.h"
#import "Ball.h"


#define PTM_RATIO 32

@interface SingleModeLayer : CCLayer
{
    CGSize winSize;
    b2World *_world;
    b2Body *_groundBody;
    b2MouseJoint *_mouseJoint;
    CCLabelBMFont *label_points1, *label_points2;
    int points1, points2;
    Paddle *computerPaddle, *playerPaddle;
    Ball *ball;
}

+(id) scene;

- (id)init;
- (void)tick:(ccTime) dt;
- (void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)ccTouchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)paddleMotion:(ccTime)dt;
- (void)checkContacts;
- (void)pointScored:(int)player;
- (void)manageScores:(int)player;
- (void)manageBall;
- (void)showRestartMenu:(int)winning_player;
- (void)restartTapped:(id)sender;
- (void)backTapped:(id)sender;






@end
