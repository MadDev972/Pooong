//
//  DualModeLayer.h
//  MyPong
//
//  Created by Sofia Maria Natacha Chevrolat on 2/26/13.
//  Copyright MadDev 2013. All rights reserved.
//


#import <GameKit/GameKit.h>

#import "cocos2d.h"
#import "Box2D.h"
#import "GLES-Render.h"
#import "Paddle.h"
#import "Ball.h"


#define PTM_RATIO 32

@interface DualModeLayer : CCLayer
{
    CGSize winSize;
    b2World *_world;
    b2Body *_groundBody;
    b2MouseJoint *_mouseJoint, *_mouseJoint2;
    CCLabelBMFont *label_points1, *label_points2;
    int points1, points2;
    Paddle *player1Paddle, *player2Paddle;
    Ball *ball;
}

+(id) scene;

- (id)init;
- (void)tick:(ccTime) dt;
- (void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)ccTouchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)checkContacts;
- (void)pointScored:(int)player;
- (void)manageScores:(int)player;
- (void)manageBall;
- (void)showRestartMenu:(int)winning_player;
- (void)restartTapped:(id)sender;
- (void)backTapped:(id)sender;

@end
