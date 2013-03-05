//
//  DualModeLayer.h
//  MyPong
//
//  Created by Sofia Maria Natacha Chevrolat on 2/26/13.
//  Copyright MadDev 2013. All rights reserved.
//


#import <GameKit/GameKit.h>
#import "PlayLayer.h"


@interface DualModeLayer : PlayLayer
{
    b2MouseJoint *_mouseJoint2;
}

+(id) scene;

- (void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)ccTouchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event;


@end
