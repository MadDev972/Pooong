//
//  SingleModeLayer.m
//  Pooong
//
//  Created by Sofia Maria Natacha Chevrolat on 2/26/13.
//  Copyright 2013 MadDev. All rights reserved.
//

#import "SingleModeLayer.h"
#import "SimpleAudioEngine.h"
#import "SceneManager.h"


@implementation SingleModeLayer

+ (id)scene
{
    CCScene *scene = [CCScene node];
    SingleModeLayer *layer = [SingleModeLayer node];
    [scene addChild:layer];
    
    return scene;
}


- (id)init
{
    if ((self=[super init]))
    {
        paddle1.sprite.tag = 2;
        
        [self schedule:@selector(update:)interval:0.015];
    }
        
    return self;
}


-(void)update:(ccTime)dt
{
    _world->Step(dt, 10, 10);
    
    //AI for paddle
    [self paddleMotion];
}


-(void)paddleMotion
{    
    for(b2Body *b = _world->GetBodyList(); b; b=b->GetNext())
    {
        if (b->GetUserData() != NULL)
        {
            CCSprite *sprite = (CCSprite *)b->GetUserData();
            
            //Get the position of the ball
            if (sprite.tag == 1)
            {
                ball.sprite.position = sprite.position;
            }
            
            //Get the position of the computer's paddle.
            else if (sprite.tag == 2)
            {
                int x;
                
                //If the ball is higher than the paddle, apply positive linear force to the paddle, else apply negative linear force.
                if (ball.sprite.position.y>b->GetPosition().y*PTM_RATIO)
                {
                    x = 7;
                }
                else
                {
                    x = -7;
                }
                
                b2Vec2 force = b2Vec2(0, x);
                
                b->ApplyLinearImpulse(force, b->GetPosition());
            }
        }
    }
}


-(void)manageScores:(int)player
{
    if (player == 1)
    {
        [[SimpleAudioEngine sharedEngine] playEffect:@"Buzzer.wav"];
        points1++;
        [label_points1 setString:[NSString stringWithFormat:@"%d",points1]];
    }
    else if (player == 2)
    {
        [[SimpleAudioEngine sharedEngine] playEffect:@"Cheer.wav"];
        points2++;
        [label_points2 setString:[NSString stringWithFormat:@"%d",points2]];
    }
    
    //if someone won, show the restart menu with accompanying message
    if (points1==10)
    {
        [self showRestartMenu:1];
    }
    else if(points2 ==10)
    {
        [self showRestartMenu:2];
    }
}

@end