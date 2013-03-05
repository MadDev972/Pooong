//
//  SceneManager.m
//  Pooong
//
//  Created by Sofia Chevrolat on 22/08/12.
//
//

#import "SceneManager.h"
#import "MenuLayer.h"
#import "SingleModeLayer.h"
#import "DualModeLayer.h"


#define TRANSITION_DURATION (1.2f)

@interface FadeWhiteTransition : CCTransitionFade
+(id) transitionWithDuration:(ccTime)t scene:(CCScene *)s;
@end

@implementation FadeWhiteTransition
+(id) transitionWithDuration:(ccTime)t scene:(CCScene *)s
{
    return [self transitionWithDuration:t scene:s withColor:ccWHITE];
}
@end



@interface ZoomFlipXLeftOver : CCTransitionZoomFlipX
+(id) transitionWithDuration:(ccTime)t scene:(CCScene *)s;
@end

@implementation ZoomFlipXLeftOver
+(id) transitionWithDuration:(ccTime)t scene:(CCScene *)s
{
    return [self transitionWithDuration:t scene:s orientation:kCCTransitionOrientationLeftOver];
}
@end


@interface FlipYDownOver : CCTransitionFlipY
+(id) transitionWithDuration:(ccTime)t scene:(CCScene *)s;
@end

@implementation FlipYDownOver
+(id) transitionWithDuration:(ccTime)t scene:(CCScene *)s
{
    return [self transitionWithDuration:t scene:s orientation:kCCTransitionOrientationDownOver];
}
@end


static int sceneIdx = 0;
static NSString *transitions[] = {
                                    @"FlipYDownOver",
                                    @"FadeWhiteTransition",
                                    @"ZoomFlipXLeftOver"
                                };


Class nextTransition()
{
    [CCTransitionSlideInL node];
    
    sceneIdx++;
    sceneIdx = sceneIdx % ( sizeof(transitions) / sizeof(transitions[0]));
    NSString *r = transitions[sceneIdx];
    Class c = NSClassFromString(r);
    return c;
}


@interface SceneManager()
+(void) go: (CCLayer *) layer;
+(CCScene *) wrap: (CCLayer *) layer;
@end


@implementation SceneManager

+(void) goMenu
{
    CCLayer *layer = [MenuLayer node];
    [SceneManager go: layer];
}

+(void) goPlaySingleMode
{
    CCLayer *layer = [SingleModeLayer node];
    [SceneManager go:layer];
}

+(void) goPlayDualMode
{
    CCLayer *layer = [DualModeLayer node];
    [SceneManager go:layer];
}

+(void)go: (CCLayer *) layer
{
    CCDirector *director = [CCDirector sharedDirector];
    CCScene *newScene = [SceneManager wrap:layer];
    Class transition = nextTransition();
    
    if([director runningScene])
    {
        [director replaceScene:[transition transitionWithDuration:TRANSITION_DURATION scene:newScene]];
    }
    else
    {
        [director runWithScene:newScene];
    }
}

+(CCScene *) wrap:(CCLayer *)layer
{
    CCScene *newScene = [CCScene node];
    [newScene addChild:layer];
    return newScene;
}

@end
