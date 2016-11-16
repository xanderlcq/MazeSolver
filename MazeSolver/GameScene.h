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
#import "MazeSolver.h"

@interface GameScene : SKScene{
    Maze *masterMaze;
    SKLabelNode *_label1;
    SKLabelNode *_label2;
    SKLabelNode *_label3;
}

@end
