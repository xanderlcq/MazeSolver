//
//  GameScene.h
//  MazeSolver
//
//  Created by Xander on 11/1/16.
//  Copyright © 2016 Xander. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "Maze.h"
#import "State.h"
@interface GameScene : SKScene{
    Maze *masterMaze;
}

@end
