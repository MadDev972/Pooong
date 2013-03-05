//
//  Paddle.m
//  Pooong
//
//  Created by Sofia Maria Natacha Chevrolat on 3/1/13.
//  Copyright (c) 2013 MadDev. All rights reserved.
//

#import "Paddle.h"

@implementation Paddle

@synthesize sprite = _sprite;
@synthesize paddleBody = _paddleBody;
@synthesize paddleFixture = _paddleFixture;

- (id)initWithWorld:(b2World*)world Ground : (b2Body*)groundBody Position:(CGPoint)position Ratio:(int)r;
{
    if ((self = [super init]))
    {
        self.sprite = [CCSprite spriteWithFile:@"paddle.png"];
        self.sprite.position = position;
        
        b2BodyDef paddleBodyDef;
        paddleBodyDef.type = b2_dynamicBody;
        paddleBodyDef.position.Set(position.x/r, position.y/r);
        paddleBodyDef.userData = self.sprite;
        self.paddleBody = world->CreateBody(&paddleBodyDef);
        
        b2PolygonShape paddleShape;
        paddleShape.SetAsBox(self.sprite.contentSize.width/r/2,
                             self.sprite.contentSize.height/r/2);
        
        b2FixtureDef paddleShapeDef;
        paddleShapeDef.shape = &paddleShape;
        paddleShapeDef.density = 10.0f;
        paddleShapeDef.friction = 0.4f;
        paddleShapeDef.restitution = 0.1f;
        self.paddleFixture = self.paddleBody->CreateFixture(&paddleShapeDef);
        
        b2PrismaticJointDef jointDef;
        b2Vec2 worldAxis(0.0f, 1.0f);
        jointDef.collideConnected = true;
        jointDef.Initialize(self.paddleBody, groundBody,
                             self.paddleBody->GetWorldCenter(), worldAxis);
        world->CreateJoint(&jointDef);
    }
    return self;
}


@end
