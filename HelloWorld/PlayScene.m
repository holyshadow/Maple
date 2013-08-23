//
//  PlayScene.m
//  HelloWorld
//
//  Created by PiggyDance on 8/17/56 BE.
//  Copyright 2556 PiggyDance. All rights reserved.
//

#import "PlayScene.h"

@interface PlayScene ()
{
    BOOL bearMoving;
    NSTimeInterval      mLastTapTime;
    BOOL bearWaiking;
    BOOL bearRunning;
    
    BOOL manMoving;
}

@property (nonatomic, strong) CCSprite *bear;
@property (nonatomic, strong) CCAction *walkAction;
@property (nonatomic, strong) CCAction *runAction;
@property (nonatomic, strong) CCAction *moveAction;

@property (nonatomic, strong) CCSprite *yeti;
@property (nonatomic, strong) CCSprite *standAction;

@property (nonatomic, strong) CCSprite *man;
@property (nonatomic, strong) CCSprite *standmanAction;
@property (nonatomic, strong) CCAction *walkmanAction;
@property (nonatomic, strong) CCAction *movemanAction;


@end

@implementation PlayScene

+(id) scene
{
	CCScene *scene = [CCScene node];
	PlayScene *layer = [PlayScene node];
	[scene addChild:layer];
	return scene;
}
-(id) init
{
	if( (self=[super init] )) {
        mLastTapTime = [NSDate timeIntervalSinceReferenceDate]; // set initial time;
		
        CGSize size = [[CCDirector sharedDirector] winSize];
		//CCLabelTTF *label = [CCLabelTTF labelWithString:@"Play" fontName:@"Marker Felt" fontSize:42];
		//label.position = ccp(size.width/2, size.height-50);
        CCSprite *bg = [CCSprite spriteWithFile:@"bg_ice.jpg"];
        CGSize imageSize = [bg boundingBox].size;
		//[self addChild:label];
        [bg setScaleX:(size.width/imageSize.width)];
        [bg setScaleY:(size.height/imageSize.height)];
        [bg setPosition:ccp(size.width/2,size.height/2)];
        [self addChild:bg z:0];
        
        //stand
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"yeti.plist"];
        CCSpriteBatchNode *spriteSheetStand = [CCSpriteBatchNode batchNodeWithFile:@"yeti.png"];
        
        NSMutableArray *standAnimFrames = [NSMutableArray array];
        for (int i=1; i<=3; i++) {
            [standAnimFrames addObject:
             [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:
              [NSString stringWithFormat:@"yetistand%d.png",i]]];
        }
        CCAnimation *standAnim = [CCAnimation animationWithSpriteFrames:standAnimFrames delay:0.3f];
        //stand
        
        //walk

        NSMutableArray *walkAnimFrames = [NSMutableArray array];
        for (int i=1; i<=5; i++) {
            [walkAnimFrames addObject:
             [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:
              [NSString stringWithFormat:@"yetiwalk%d.png",i]]];
        }
        CCAnimation *walkAnim = [CCAnimation animationWithSpriteFrames:walkAnimFrames delay:0.3f];
        //walk
        
        //man stand
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"man.plist"];
        CCSpriteBatchNode *spriteSheetMan = [CCSpriteBatchNode batchNodeWithFile:@"man.png"];
        
        NSMutableArray *standManAnimFrames = [NSMutableArray array];
        for (int i=1; i<=4; i++) {
            [standManAnimFrames addObject:
             [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:
              [NSString stringWithFormat:@"manstand%d.png",i]]];
        }
        CCAnimation *standManAnim = [CCAnimation animationWithSpriteFrames:standManAnimFrames delay:0.3f];
        //man stand
        
        //man walk
        NSMutableArray *walkManAnimFrames = [NSMutableArray array];
        for (int i=1; i<=4; i++) {
            [walkManAnimFrames addObject:
             [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:
              [NSString stringWithFormat:@"manwalk%d.png",i]]];
        }
        CCAnimation *walkManAnim = [CCAnimation animationWithSpriteFrames:walkManAnimFrames delay:0.3f];
        //man walk
        
        self.man = [CCSprite spriteWithSpriteFrameName:@"manstand1.png"];
        
        self.man.position = ccp((size.width/2)*0.5, (size.height/2)-75);
        self.man.scale=1;
        
        
        self.yeti = [CCSprite spriteWithSpriteFrameName:@"yetistand1.png"];
        
        self.yeti.position = ccp((size.width/2)*1.5, (size.height/2)-60);
        self.yeti.scale=1;
       
        
//        self.runAction = [CCRepeatForever actionWithAction:
//                           [CCAnimate actionWithAnimation:runAnim]];
//
        
        self.standmanAction = [CCRepeatForever actionWithAction:
                            [CCAnimate actionWithAnimation:standManAnim]];
        self.walkmanAction = [CCRepeatForever actionWithAction:
                               [CCAnimate actionWithAnimation:walkManAnim]];
        
        
        self.standAction = [CCRepeatForever actionWithAction:
                          [CCAnimate actionWithAnimation:standAnim]];
        
        self.walkAction = [CCRepeatForever actionWithAction:
                            [CCAnimate actionWithAnimation:walkAnim]];
        
        self.man.flipX = YES;
        
        [self.yeti runAction:self.standAction];
        [self.man runAction:self.standmanAction];
        
        [spriteSheetStand addChild:self.yeti];
        [spriteSheetMan addChild:self.man];
        //[spriteSheet addChild:self.yeti];
        //[spriteSheet addChild:self.yeti];
        
        bearMoving = NO;
        manMoving = NO;
        
        [self addChild:spriteSheetStand];
        [self addChild:spriteSheetMan];
        //[self addChild:spriteSheet];
        
		//เพื่อให้สามารถ Touch หน้าจอได้
		self.isTouchEnabled = YES;
	}
	return self;
}

- (void)registerWithTouchDispatcher
{
    [[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:
     self priority:0 swallowsTouches:YES];
}

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    return YES;
}

- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
    NSTimeInterval currentTime = [NSDate timeIntervalSinceReferenceDate];
    NSTimeInterval diff = currentTime - mLastTapTime;
    NSLog(@"(%f,%d)", diff,bearMoving);
    mLastTapTime = currentTime;
   
    
    
        CGPoint touchLocation = [self convertTouchToNodeSpace:touch];
        CGSize screenSize = [[CCDirector sharedDirector] winSize];
        float bearVelocity = screenSize.width / 3.0;
        
        CGPoint moveDifference = ccpSub(touchLocation, self.man.position);
        float distanceToMove = ccpLength(moveDifference);
        float moveDuration = distanceToMove / bearVelocity;
        
        
        if (moveDifference.x < 0) {
            self.man.flipX = NO;
        } else {
            self.man.flipX = YES;
        }
      //  [self.yeti stopAction:self.moveAction];
        [self.man stopAction:self.movemanAction];
    // NSLog(@"before change action");
    
    if(!manMoving){
        NSLog(@"Changed Action");
        [self.man stopAction:self.standmanAction];
        [self.man runAction:self.walkmanAction];
    }
   // NSLog(@"After change action");
    manMoving =YES;
    NSLog(@"\nmove_duration = %f\nx= %f y=%f\n",moveDuration,touchLocation.x,touchLocation.y);
    
        self.movemanAction = [CCSequence actions:
                           [CCMoveTo actionWithDuration:moveDuration position:touchLocation],
                           [CCCallFunc actionWithTarget:self selector:@selector(bearMoveEnded)],
                           nil];
        
        [self.man runAction:self.movemanAction];
    

}
- (void)bearMoveEnded
{
    //[self.yeti stopAction:self.walkAction];
    //[self.yeti runAction:self.standAction];
    //bearMoving = NO;
    
    [self.man stopAction:self.walkmanAction];
    [self.man runAction:self.standmanAction];
    manMoving = NO;
}

-(void)dealloc
{
	[super dealloc];
}
@end
