//
//  Ball.m
//  Pooong
//
//  Created by Sofia Maria Natacha Chevrolat on 3/3/13.
//  Copyright (c) 2013 MadDev. All rights reserved.
//

#import "Ball.h"

@implementation Ball

@synthesize sprite = _sprite;
@synthesize ballBody = _ballBody;
@synthesize ballFixture = _ballFixture;


- (id)initWithWorld:(b2World*)world Ground : (b2Body*)groundBody Position:(CGPoint)position Ratio:(int)r;
{
    if ((self = [super init]))
    {
        self.sprite = [CCSprite spriteWithFile:@"ball.png"];
        self.sprite.position = position;
        self.sprite.tag = 1;
        
        b2BodyDef ballBodyDef;
        ballBodyDef.type = b2_dynamicBody;
        ballBodyDef.position.Set(position.x/r, position.y/r);
        ballBodyDef.userData = self.sprite;
        self.ballBody = world->CreateBody(&ballBodyDef);
        
        b2CircleShape circle;
        circle.m_radius = 26.0/r;
        
        b2FixtureDef ballShapeDef;
        ballShapeDef.shape = &circle;
        ballShapeDef.density = 1.0f;
        ballShapeDef.friction = 0.f;
        ballShapeDef.restitution = 1.0f;
        self.ballFixture = self.ballBody->CreateFixture(&ballShapeDef);
        
        b2Vec2 force = b2Vec2(10, 10);
        self.ballBody->ApplyLinearImpulse(force, ballBodyDef.position);
    }
    return self;
}

@end
