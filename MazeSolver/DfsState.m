//
//  DfsState.m
//  MazeSolver
//
//  Created by Xander on 11/4/16.
//  Copyright © 2016 Xander. All rights reserved.
//

#import "DfsState.h"

@implementation DfsState
// 1 up
// 2 right
// 3 down
// 4 left
-(id) init{
    self = [super init];
    if(self){
        direction = 1;
    }
    return self;
}
-(id) initWithXY:(int) x y:(int)y{
    self = [super initWithXY:x y:y];
    if(self){
        direction = 1;
    }
    return self;
}
-(bool) hasNext:(Maze *)maze{
    return direction <= 4;
}

-(DfsState *) getNext:(Maze *) maze{
    if(direction == 1){
        DfsState *tempNext =[[DfsState alloc] initWithXY:self.x y:self.y-1];

        if([maze isEmpty:tempNext]){
            direction ++;
            return tempNext;
        }else{
            direction ++;
        }
    }
    if(direction == 2){
        DfsState *tempNext =[[DfsState alloc] initWithXY:self.x+1 y:self.y];
        if([maze isEmpty:tempNext]){
            direction ++;
            return tempNext;
        }else{
            direction ++;
        }
    }
    if(direction == 3){
        DfsState *tempNext =[[DfsState alloc] initWithXY:self.x y:self.y+1];
        if([maze isEmpty:tempNext]){
            direction ++;
            return tempNext;
        }else{
            direction ++;
        }
    }
    if(direction == 4){
        DfsState *tempNext =[[DfsState alloc] initWithXY:self.x-1 y:self.y];
        if([maze isEmpty:tempNext]){
            direction ++;
            return tempNext;
        }else{
            direction++;
            return nil;
        }
    }
    return nil;
}
@end
