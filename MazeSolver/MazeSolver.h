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

@end
