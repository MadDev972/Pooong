//
//  MenuLayer.m
//  TileSlide
//
//  Created by Sofia Chevrolat on 22/08/12.
//
//

#import "MenuLayer.h"
#import "SimpleAudioEngine.h"



@implementation MenuLayer

-(id) init
{
    if ((self=[super init]))
    {
        CGSize winSize = [CCDirector sharedDirector].winSize;
        CCSprite *background;
        background = [CCSprite spriteWithFile:@"background.png"];
        background.position = ccp(winSize.width/2, winSize.height/2);
        [self addChild: background];
        
        CCMenuItemImage *startNewSingleGame = [CCMenuItemImage
                                               itemWithNormalImage:@"Button.png"
                                               selectedImage:@"Button_Pressed.png"
                                               target:self
                                               selector:@selector(onNewSingleGame:)];
        
        CCMenuItemImage *startNewDualGame = [CCMenuItemImage itemWithNormalImage:@"Button_Dual.png"
                                                             selectedImage:@"Button_Dual_Pressed.png"
                                                             target:self
                                                             selector:@selector(onNewDualGame:)];
        

        CCMenu *menu_game = [CCMenu menuWithItems:startNewSingleGame, startNewDualGame, nil];
        menu_game.position = ccp(winSize.width*0.5,winSize.height*0.5);
        [menu_game alignItemsVerticallyWithPadding:winSize.width/10];
        [self addChild:menu_game];
        

        [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"Menu_music.wav"];
    }
    
    return self;
}


-(void) onNewSingleGame:(id)sender
{
    [SceneManager goPlaySingleMode];
}


-(void) onNewDualGame:(id)sender
{
    [SceneManager goPlayDualMode];
}
                                 
@end
