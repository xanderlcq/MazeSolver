//
//  MazeSolver.h
//  MazeSolver
//
//  Created by Xander on 11/10/16.
//  Copyright © 2016 Xander. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SpriteKit/SpriteKit.h>
#import "Maze.h"
#import "DfsState.h"
#import "BfsState.h"
#import "Queue.h"
#import "Stack.h"
#import "AnimationState.h"
@interface MazeSolver : NSObject{
    
    Maze *masterMaze;
    double windowWidth;
    double windowHeight;
    double blockWidth;
    double blockHeight;
    
}
@property NSString *fileName;

-(id) initWithWindowSize:(NSString *)f windowWidth:(double)w windowHeight:(double) h;


/**
 Solve the maze and return an animation array

 @param mode 1 for bfs, 2 for dfs

 @return array of animationStates
 */
-(NSMutableArray *) solve:(int) mode;

@end
