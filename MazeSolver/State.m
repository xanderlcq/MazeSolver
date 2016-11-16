//
//  State.m
//  MazeSolver
//
//  Created by Xander on 11/4/16.
//  Copyright © 2016 Xander. All rights reserved.
//

#import "State.h"

@implementation State
-(bool) equals:(State *) n{
    if(self == nil || n == nil){
        return NO;
    }
    return self.x==n.x&&self.y==n.y;
}
-(id) initWithXY:(int) x y:(int)y{
    self = [super init];
    if(self){
        self.x = x;
        self.y = y;
    }
    return self;
}
-(void) setupGraphics:(double) windowWidth windowHeight:(double)windowHeight blockWidth:(double) width blockHeight:(double)height{
    self.graphic = [SKShapeNode shapeNodeWithRect:CGRectMake(0-windowWidth/2+self.x*width, 0+windowHeight/2-height-self.y*height, width, height)];
    self.graphic.lineWidth = 0;
}
@end
