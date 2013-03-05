//
//  Paddle.h
//  Pooong
//
//  Created by Sofia Maria Natacha Chevrolat on 3/1/13.
//  Copyright (c) 2013 MadDev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Box2D.h"
#import "GLES-Render.h"


@interface Paddle : NSObject
{
    CCSprite* _sprite;
    b2Body *_paddleBody;
    b2Fixture *_paddleFixture;
}

@property (nonatomic, assign) CCSprite *sprite;
@property (nonatomic, assign) b2Body *paddleBody;
@property (nonatomic, assign) b2Fixture *paddleFixture;

- (id)initWithWorld:(b2World*)world Ground : (b2Body*)groundBody Position:(CGPoint)position Ratio:(int)r;

@end
