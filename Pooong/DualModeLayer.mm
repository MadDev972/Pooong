#import "DualModeLayer.h"
#import "SimpleAudioEngine.h"
#import "SceneManager.h"


@implementation DualModeLayer


+ (id)scene
{
    CCScene *scene = [CCScene node];
    DualModeLayer *layer = [DualModeLayer node];
    [scene addChild:layer];
    
    return scene;
}



- (id)init
{
    if ((self=[super init]))
    {        
        [self schedule:@selector(update:)interval:0.015];
    }
    
    return self;
}


- (void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (_mouseJoint != NULL && _mouseJoint2 != NULL) return;
    
    NSArray *touchArray = [touches allObjects];
    
    for (int i=0; i<[touchArray count]; i++)
    {
        UITouch *myTouch = [touchArray objectAtIndex:i];
        CGPoint location = [myTouch locationInView:[myTouch view]];
        location = [[CCDirector sharedDirector] convertToGL:location];
        b2Vec2 locationWorld = b2Vec2(location.x/PTM_RATIO, location.y/PTM_RATIO);
        
        if (paddle1.paddleFixture->TestPoint(locationWorld))
        {
            b2MouseJointDef md;
            md.bodyA = _groundBody;
            md.bodyB = paddle1.paddleBody;
            md.target = locationWorld;
            md.collideConnected = true;
            md.maxForce = 1000.0f * paddle1.paddleBody->GetMass();
            
            _mouseJoint = (b2MouseJoint *)_world->CreateJoint(&md);
            paddle1.paddleBody->SetAwake(true);
        }
        else if (paddle2.paddleFixture->TestPoint(locationWorld))
        {
            b2MouseJointDef md;
            md.bodyA = _groundBody;
            md.bodyB = paddle2.paddleBody;
            md.target = locationWorld;
            md.collideConnected = true;
            md.maxForce = 1000.0f * paddle2.paddleBody->GetMass();
            
            _mouseJoint2 = (b2MouseJoint *)_world->CreateJoint(&md);
            paddle2.paddleBody->SetAwake(true);
        }
    }
    
}


-(void)ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{    
    if (_mouseJoint == NULL && _mouseJoint2 == NULL) return;
    
    NSArray *touchArray = [touches allObjects];
    
    for (int i=0; i<[touchArray count]; i++)
    {
        UITouch *myTouch = [touchArray objectAtIndex:i];
        CGPoint location = [myTouch locationInView:[myTouch view]];
        location = [[CCDirector sharedDirector] convertToGL:location];
        b2Vec2 locationWorld = b2Vec2(location.x/PTM_RATIO, location.y/PTM_RATIO);
        
        if (location.x < winSize.width*0.1 && _mouseJoint)
        {
            _mouseJoint->SetTarget(locationWorld);
            
        }
        else if (location.x > winSize.width*0.9 && _mouseJoint2)
        {
            _mouseJoint2->SetTarget(locationWorld);
        }
    }
}


-(void)ccTouchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{    
    NSArray *touchArray = [touches allObjects];
    
    for (int i=0; i<[touchArray count]; i++)
    {
        UITouch *myTouch = [touchArray objectAtIndex:i];
        CGPoint location = [myTouch locationInView:[myTouch view]];
        location = [[CCDirector sharedDirector] convertToGL:location];
        
        if (location.x < winSize.width*0.1 && _mouseJoint)
        {
            _world->DestroyJoint(_mouseJoint);
            _mouseJoint = NULL;
        }
        else if (location.x > winSize.width*0.9 && _mouseJoint2)
        {
            _world->DestroyJoint(_mouseJoint2);
            _mouseJoint2 = NULL;
        }
    }
}


- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{    
    NSArray *touchArray = [touches allObjects];
    
    for (int i=0; i<[touchArray count]; i++)
    {
        UITouch *myTouch = [touchArray objectAtIndex:i];
        CGPoint location = [myTouch locationInView:[myTouch view]];
        location = [[CCDirector sharedDirector] convertToGL:location];
        
        if (location.x < winSize.width*0.2 && _mouseJoint)
        {
            _world->DestroyJoint(_mouseJoint);
            _mouseJoint = NULL;
        }
        else if (location.x > winSize.width*0.8 && _mouseJoint2)
        {
            _world->DestroyJoint(_mouseJoint2);
            _mouseJoint2 = NULL;
        }
    }
}


@end