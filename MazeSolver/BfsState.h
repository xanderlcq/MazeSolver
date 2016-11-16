//
//  BfsState.h
//  MazeSolver
//
//  Created by Xander on 11/8/16.
//  Copyright © 2016 Xander. All rights reserved.
//

#import "State.h"
#import "Maze.h"
#import "Queue.h"


@interface BfsState : State{
    int direction;
}
@property BfsState *prev;

//Check if there's neighbors or not
-(bool) hasNext:(Maze *)maze;

//Get the next neighbor
-(BfsState *) getNext:(Maze *) maze;

-(id) init;
-(id) initWithX:(int) x y:(int)y previousState:(BfsState *)p;
-(id) initWithXY:(int)x y:(int)y;
@end
