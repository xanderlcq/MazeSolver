//
//  State.h
//  MazeSolver
//
//  Created by Xander on 11/4/16.
//  Copyright © 2016 Xander. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SpriteKit/SpriteKit.h>
@interface State : NSObject


@property int x;
@property int y;
-(bool) equals:(State *) n;
-(id) initWithXY:(int) x y:(int)y;
@property SKShapeNode *graphic;

-(void) setupGraphics:(double) windowWidth windowHeight:(double)windowHeight blockWidth:(double) width blockHeight:(double)height;

@end
