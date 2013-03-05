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
#import "PlayLayer.h"


#define PTM_RATIO 32

@interface SingleModeLayer : PlayLayer
{
    
}

+(id) scene;

- (id)init;
- (void)update:(ccTime)dt;
- (void)paddleMotion;
- (void)manageScores:(int)player;


@end
