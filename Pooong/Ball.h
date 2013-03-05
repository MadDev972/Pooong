//
//  Ball.h
//  Pooong
//
//  Created by Sofia Maria Natacha Chevrolat on 3/3/13.
//  Copyright (c) 2013 MadDev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Box2D.h"
#import "GLES-Render.h"


@interface Ball : NSObject
{
    CCSprite* _sprite;
    b2Body *_ballBody;
    b2Fixture *_ballFixture;
}

@property (nonatomic, assign) CCSprite *sprite;
@property (nonatomic, assign) b2Body *ballBody;
@property (nonatomic, assign) b2Fixture *ballFixture;

- (id)initWithWorld:(b2World*)world Ground : (b2Body*)groundBody Position:(CGPoint)position Ratio:(int)r;

@end
