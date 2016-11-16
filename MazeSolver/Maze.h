//
//  Maze.h
//  MazeSolver
//
//  Created by Xander on 11/4/16.
//  Copyright © 2016 Xander. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "State.h"
@interface Maze : NSObject{
    NSMutableArray *maze;
}
-(id) init;

//Load a maze txt file with given name, the files must be in the project folder
-(bool) loadMaze:(NSString *) fileName;

//Check if a state can be placed or not
-(bool) isEmpty:(State *) state;

//Check if state is the end or not
-(bool) isFinished:(State *) state;

//Check if state is the start or not
-(bool) isStart:(State *) state;

//Return a state with the starting location
-(State *) getStart;

//Mark the maze as visited
-(void) mark:(State *) state;

//Return the 2d array of maze
-(NSMutableArray *) getMazeArray;

//Number of blocks horizontally
-(int) getWidth;

//Number of blocks vertically
-(int) getHeight;
@end
