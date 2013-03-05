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
        winSize = [CCDirector sharedDirector].winSize;
        
        
        CCSprite *background;
        background = [CCSprite spriteWithFile:@"background.png"];
        background.position = ccp(winSize.width/2, winSize.height/2);
        [self addChild: background];
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        {
            label_points1 = [CCLabelBMFont labelWithString:@"0" fntFile:@"Arial-hd.fnt"];
            label_points2= [CCLabelBMFont labelWithString:@"0" fntFile:@"Arial-hd.fnt"];
        }
        else
        {
            label_points1 = [CCLabelBMFont labelWithString:@"0" fntFile:@"Arial.fnt"];
            label_points2 = [CCLabelBMFont labelWithString:@"0" fntFile:@"Arial.fnt"];
        }
        
        label_points1.scale = 0.8;
        label_points1.position = ccp(winSize.width * 0.35, winSize.height * 0.94);
        [self addChild:label_points1];
        
        label_points2.scale = 0.8;
        label_points2.position = ccp(winSize.width*0.65, winSize.height * 0.94);
        [self addChild:label_points2];
        
        CCMenuItemImage *goBack = [CCMenuItemImage itemWithNormalImage:@"Button_Menu.png"
                                                         selectedImage:@"Button_Menu_Pressed.png"
                                                                target:self
                                                              selector:@selector(backTapped:)];
        
        CCMenu *menu_back = [CCMenu menuWithItems:goBack, nil];
        menu_back.position = ccp(winSize.width*0.5,winSize.height*0.94);
        [self addChild:menu_back];
        
        
        // Create the world
        b2Vec2 gravity = b2Vec2(0.0f, 0.0f);
        _world = new b2World(gravity);
        
        
        // Create edges around the entire screen
        b2BodyDef groundBodyDef;
        groundBodyDef.position.Set(0,0);
        _groundBody = _world->CreateBody(&groundBodyDef);
        
        b2EdgeShape groundBox;
        b2FixtureDef groundBoxDef;
        groundBoxDef.shape = &groundBox;
        
        groundBox.Set(b2Vec2(0,0), b2Vec2(winSize.width/PTM_RATIO, 0));
        _groundBody->CreateFixture(&groundBoxDef);
        
        groundBox.Set(b2Vec2(0, winSize.height/PTM_RATIO), b2Vec2(winSize.width/PTM_RATIO,
                                                                  winSize.height/PTM_RATIO));
        _groundBody->CreateFixture(&groundBoxDef);
        
        
        // Create ball and add it to the layer, plus bouncing and contact check
        ball = [[Ball alloc] initWithWorld:_world Ground : _groundBody Position:ccp(100, 100) Ratio:PTM_RATIO];
        [self addChild:ball.sprite];
        [self schedule:@selector(tick:) interval:0.005];
        
        // Create the paddles and add them to the layer
        player1Paddle = [[Paddle alloc] initWithWorld:_world Ground : _groundBody Position:ccp(winSize.width*0.05, winSize.height*0.5) Ratio:PTM_RATIO];
        [self addChild:player1Paddle.sprite];
        
        player2Paddle = [[Paddle alloc] initWithWorld:_world Ground : _groundBody Position:ccp(winSize.width*0.95, winSize.height*0.5) Ratio:PTM_RATIO];
        [self addChild:player2Paddle.sprite];
        
        b2PrismaticJointDef jointDef;
        b2Vec2 worldAxis(0.0f, 1.0f);
        jointDef.collideConnected = true;
        jointDef.Initialize(player1Paddle.paddleBody, _groundBody,
                            player1Paddle.paddleBody->GetWorldCenter(), worldAxis);
        _world->CreateJoint(&jointDef);
        
        b2PrismaticJointDef jointDef2;
        jointDef2.collideConnected = true;
        jointDef2.Initialize(player2Paddle.paddleBody, _groundBody,
                             player2Paddle.paddleBody->GetWorldCenter(), worldAxis);
        _world->CreateJoint(&jointDef2);
        
        self.touchEnabled = YES;
    }
    
    [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"background-music-aac.caf"];
    
    return self;
}


- (void)tick:(ccTime) dt
{
    _world->Step(dt, 10, 10);
    for(b2Body *b = _world->GetBodyList(); b; b=b->GetNext())
    {
        if (b->GetUserData() != NULL)
        {
            CCSprite *sprite = (CCSprite *)b->GetUserData();
            
            // if ball is going too fast, turn on damping
            if (sprite.tag == 1)
            {
                static int maxSpeed = 10;
                
                b2Vec2 velocity = b->GetLinearVelocity();
                float32 speed = velocity.Length();
                
                if (speed > maxSpeed)
                {
                    b->SetLinearDamping(0.5);
                }
                else if (speed < maxSpeed)
                {
                    b->SetLinearDamping(0.0);
                }
                
            }
            
            sprite.position = ccp(b->GetPosition().x * PTM_RATIO,b->GetPosition().y * PTM_RATIO);
            sprite.rotation = -1 * CC_RADIANS_TO_DEGREES(b->GetAngle());
        }
    }
    
    [self checkContacts];
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
        
        if (player1Paddle.paddleFixture->TestPoint(locationWorld))
        {
            b2MouseJointDef md;
            md.bodyA = _groundBody;
            md.bodyB = player1Paddle.paddleBody;
            md.target = locationWorld;
            md.collideConnected = true;
            md.maxForce = 1000.0f * player1Paddle.paddleBody->GetMass();
            
            _mouseJoint = (b2MouseJoint *)_world->CreateJoint(&md);
            player1Paddle.paddleBody->SetAwake(true);
        }
        else if (player2Paddle.paddleFixture->TestPoint(locationWorld))
        {
            b2MouseJointDef md;
            md.bodyA = _groundBody;
            md.bodyB = player2Paddle.paddleBody;
            md.target = locationWorld;
            md.collideConnected = true;
            md.maxForce = 1000.0f * player2Paddle.paddleBody->GetMass();
            
            _mouseJoint2 = (b2MouseJoint *)_world->CreateJoint(&md);
            player2Paddle.paddleBody->SetAwake(true);
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


-(void)checkContacts
{
    winSize = [CCDirector sharedDirector].winSize;
    
    if (
        (
         (ball.sprite.position.x - player1Paddle.sprite.position.x < 35) &&
         (ball.sprite.position.x - player1Paddle.sprite.position.x > 0) &&
         (abs(ball.sprite.position.y - player1Paddle.sprite.position.y) < 70)
         )
        ||
        (
         (player2Paddle.sprite.position.x - ball.sprite.position.x < 35) &&
         (player2Paddle.sprite.position.x - ball.sprite.position.x > 0) &&
         (abs(ball.sprite.position.y - player2Paddle.sprite.position.y) < 70)
         )
        )
    {
        [[SimpleAudioEngine sharedEngine] playEffect:@"blip.caf"];
    }
    
    else if (ball.sprite.position.x >  winSize.width)
    {
        [self pointScored:1];
    }
    else if (ball.sprite.position.x < 0)
    {
        [self pointScored:2];
    }
}


-(void)pointScored:(int)player
{
    [self manageScores:player];
    [self manageBall];
}


-(void) manageScores:(int) player
{
    [[SimpleAudioEngine sharedEngine] playEffect:@"Cheer.wav"];
    
    if (player == 1)
    {
        points1++;
        [label_points1 setString:[NSString stringWithFormat:@"%d",points1]];
    }
    else if(player ==2)
    {
        points2++;
        [label_points2 setString:[NSString stringWithFormat:@"%d",points2]];
    }
    
    //if someone won, show the restart menu with accompanying message
    if (points1==10)
    {
        [self showRestartMenu:1];
    }
    else if(points2 ==10)
    {
        [self showRestartMenu:2];
    }
}


-(void)manageBall
{
    CCSprite *sprite = (CCSprite *) ball.ballBody->GetUserData();
    [self removeChild:sprite cleanup:YES];
    
    _world->DestroyBody(ball.ballBody);
    ball = NULL;
    
    //If nobody has won, spawn a ball
    if (points1 <10 && points2 < 10)
    {
        ball = [[Ball alloc] initWithWorld:_world Ground : _groundBody Position:ccp(100, 100) Ratio:PTM_RATIO];
        [self addChild:ball.sprite];
    }
}



- (void)showRestartMenu:(int)winning_player
{    
    NSString *message;
    if (winning_player==1)
    {
        message = @"Congrats Player 1, you win!";
        [[SimpleAudioEngine sharedEngine] playEffect:@"Cheer.wav"];
        
    }
    else
    {
        message = @"Congrats Player 2, you win!";
        [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"Cheer.wav"];
    }
    
    CCLabelBMFont *label;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        label = [CCLabelBMFont labelWithString:message fntFile:@"Arial-hd.fnt"];
    }
    else
    {
        label = [CCLabelBMFont labelWithString:message fntFile:@"Arial.fnt"];
    }
    //label.scale = 0.1;
    label.scale = 0.8;
    label.position = ccp(winSize.width/2, winSize.height * 0.6);
    [self addChild:label];
    
    CCLabelBMFont *restartLabel;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        restartLabel = [CCLabelBMFont labelWithString:@"Restart" fntFile:@"Arial-hd.fnt"];
    }
    else
    {
        restartLabel = [CCLabelBMFont labelWithString:@"Restart" fntFile:@"Arial.fnt"];
    }
    
    CCMenuItemLabel *restartItem = [CCMenuItemLabel itemWithLabel:restartLabel target:self selector:@selector(restartTapped:)];
    //restartItem.scale = 0.8;
    restartItem.scale = 0.8;
    restartItem.position = ccp(winSize.width/2, winSize.height * 0.4);
    
    CCMenu *menu = [CCMenu menuWithItems:restartItem, nil];
    menu.position = CGPointZero;
    [self addChild:menu z:10];
    
    /*[restartItem runAction:[CCScaleTo actionWithDuration:0.5 scale:1.0]];
     [label runAction:[CCScaleTo actionWithDuration:0.5 scale:1.0]];*/
}


- (void)restartTapped:(id)sender
{
    CCScene *scene = [DualModeLayer scene];
    [[CCDirector sharedDirector] replaceScene:[CCTransitionZoomFlipX transitionWithDuration:0.5 scene:scene]];
}


- (void)backTapped:(id)sender
{
    [SceneManager goMenu];
}



















- (void)dealloc
{
    delete _world;
    _groundBody = NULL;
    label_points1 = NULL;
    label_points2 = NULL;
    [super dealloc];
}

@end