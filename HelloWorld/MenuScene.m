//
//  MenuScene.m
//  HelloWorld
//
//  Created by PiggyDance on 8/17/56 BE.
//  Copyright 2556 PiggyDance. All rights reserved.
//

#import "MenuScene.h"
#import "PlayScene.h"

@implementation MenuScene
+(id) scene{
    CCScene *scene = [CCScene node];
    MenuScene *layer = [MenuScene node];
    [scene addChild:layer];
    return scene;
}

-(id) init
{
	if( (self=[super init] )) {
		//เก็บขนาดของหน้าจอ
		CGSize size = [[CCDirector sharedDirector] winSize];
		//สร้างเมนูจากข้อความและกำหนดตำแหน่งการวาง
        CCSprite *bg = [CCSprite spriteWithFile:@"BG.jpg"];
        CGSize imageSize = [bg boundingBox].size;
		//CCLabelTTF *menu = [CCLabelTTF labelWithString:@"Menu" fontName:@"Marker Felt" fontSize:42];
		//menu.position = ccp(size.width/2, size.height-50);
		CCLabelTTF *menuPlay = [CCLabelTTF labelWithString:@"Play" fontName:@"Marker Felt" fontSize:30];
		menuPlay.position = ccp(size.width/2, size.height-170);
		CCLabelTTF *menuHowToPlay = [CCLabelTTF labelWithString:@"How To Play" fontName:@"Marker Felt" fontSize:30];
		menuHowToPlay.position = ccp(size.width/2, size.height-220);
		CCLabelTTF *menuAbout = [CCLabelTTF labelWithString:@"About Us" fontName:@"Marker Felt" fontSize:30];
		menuAbout.position = ccp(size.width/2, size.height-270);
        [bg setScaleX:(size.width/imageSize.width)];
        [bg setScaleY:(size.height/imageSize.height)];
        [bg setPosition:ccp(size.width/2,size.height/2)];
        [self addChild:bg z:0];
        //  [self addChild:menu];
		[self addChild:menuPlay];
		[self addChild:menuHowToPlay];
		[self addChild:menuAbout];
		//เพื่อให้สามารถ Touch หน้าจอได้
		self.isTouchEnabled = YES;
	}
	return self;
}

-(BOOL) ccTouchesBeganed:(NSSet *) touches withEvent:(UIEvent *) event
{
	return YES;
}

-(void) ccTouchesEnded:(NSSet *) touches withEvent:(UIEvent *) event
{
	UITouch *touch = [touches anyObject];
	CGPoint location = [touch locationInView:[touch view]];
	location = [[CCDirector sharedDirector] convertToGL:location];
    
	//ตรวจสอบตำแหน่งที่เรา Touch ว่าตรงกับเมนู Play หรือไม่
	if (location.x >= 170 && location.x <= 320 && location.y >= 130 && location.y <= 170)
	{
		//NSLog(@"(%f, %f)", location.x, location.y);
        //แสดงตำหน่งที่เรา Touch ใน Console
        [[CCDirector sharedDirector] replaceScene:[CCTransitionFlipX transitionWithDuration:1.5f scene:[PlayScene node]]];
	}
}

-(void) dealloc
{
	[super dealloc];
}
@end
