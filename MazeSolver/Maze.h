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
-(bool) loadMaze:(NSString *) fileName;
-(bool) isEmpty:(State *) state;
-(bool) isFinished:(State *) state;
-(bool) isStart:(State *) state;
-(State *) getStart;
-(void) mark:(State *) state;
-(NSMutableArray *) getMazeArray;
-(int) getWidth;
-(int) getHeight;
@end
