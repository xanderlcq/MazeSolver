//
//  DfsState.h
//  MazeSolver
//
//  Created by Xander on 11/4/16.
//  Copyright © 2016 Xander. All rights reserved.
//

#import "State.h"
#import "Maze.h"
#import "Stack.h"
@interface DfsState : State{
    int direction;
}

-(bool) hasNext:(Maze *)maze;
-(DfsState *) getNext:(Maze *) maze;
-(id) init;
-(id) initWithXY:(int) x y:(int)y;
@end
