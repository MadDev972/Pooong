//
//  IntroLayer.m
//  Pooong
//
//  Created by Sofia Maria Natacha Chevrolat on 2/26/13.
//  Copyright MadDev 2013. All rights reserved.
//


#import "IntroLayer.h"
#import "SceneManager.h"


@implementation IntroLayer

+(CCScene *) scene
{
	CCScene *scene = [CCScene node];
	
	IntroLayer *layer = [IntroLayer node];
	
	[scene addChild: layer];
	
	return scene;
}


-(id) init
{
	if( (self=[super init]))
    {
        CGSize size = [[CCDirector sharedDirector] winSize];
		
		CCSprite *background;
		
		if( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone )
        {
			background = [CCSprite spriteWithFile:@"Default.png"];
			background.rotation = 90;
		}
        else
        {
			background = [CCSprite spriteWithFile:@"Default-Landscape~ipad.png"];
		}
		background.position = ccp(size.width/2, size.height/2);
		
		[self addChild: background];
	}
	return self;
}


-(void) onEnter
{
	[super onEnter];
    [SceneManager goMenu];
}

@end
