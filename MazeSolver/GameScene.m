//
//  GameScene.m
//  MazeSolver
//
//  Created by Xander on 11/1/16.
//  Copyright © 2016 Xander. All rights reserved.
//

#import "GameScene.h"
#import "DfsState.h"
#import "Stack.h"
#import "Queue.h"
#import "BfsState.h"

@implementation GameScene {
    
    //Graphics config
    double blockWidth;
    double blockHeight;
    double mazeScreenWidth;
    double mazeScreenHeight;
    
    // Animation config
    float previousTime;
    float interval;
    BOOL isForwardAnimating;
    BOOL isBackwardAnimating;
    BOOL isLoaded;
    int steps;
    
    // Maze config
    NSString *file;
    NSMutableArray *solution;
    int solveMethod;
    
}

- (void)didMoveToView:(SKView *)view {
    previousTime = -1;
    isForwardAnimating = NO;
    isBackwardAnimating = NO;
    isLoaded = NO;
    steps = 0;
    interval = 0.005;
    mazeScreenWidth = self.size.width;
    mazeScreenHeight = self.size.height-160;
    solveMethod = 2;
    file = @"mediumMaze";
    [self solve:file method:solveMethod];
}



-(void) solve:(NSString *) fname method:(int) m{
    [self removeAllChildren];
    NSString *fileName = fname;
    
    masterMaze = [[Maze alloc] init];
    if(![masterMaze loadMaze:fileName]){
        return;
    }
    blockWidth =mazeScreenWidth/[masterMaze getWidth];
    blockHeight = mazeScreenHeight/[masterMaze getHeight];
    [self drawMaze:masterMaze];
    
    
    MazeSolver *solver = [[MazeSolver alloc] initWithWindowSize:fileName windowWidth:mazeScreenWidth windowHeight:mazeScreenHeight];
    solution = [solver solve:m];
}


-(void) drawMaze:(Maze *) maze{
    NSMutableArray *mazeArray = [maze getMazeArray];
    double x = 0-mazeScreenWidth/2;
    double y = 0+mazeScreenHeight/2-blockHeight;
    steps = 0;
    
    for(int i = 0; i < [mazeArray count];i++){
        for(int k = 0; k < [[mazeArray objectAtIndex:0] count];k++){
            SKShapeNode *_rectNode = [SKShapeNode shapeNodeWithRect:CGRectMake(x, y, blockWidth, blockHeight)];
            if([[[mazeArray objectAtIndex:i] objectAtIndex:k] isEqual: @"S"]){
                _rectNode.fillColor = [SKColor greenColor];
            }
            if([[[mazeArray objectAtIndex:i] objectAtIndex:k] isEqual: @"G"]){
                _rectNode.fillColor = [SKColor redColor];
            }
            if([[[mazeArray objectAtIndex:i] objectAtIndex:k] isEqual: @"."]){
                _rectNode.fillColor = [SKColor whiteColor];
            }
            if([[[mazeArray objectAtIndex:i] objectAtIndex:k] isEqual: @"#"]){
                _rectNode.fillColor = [SKColor blackColor];
            }
    
            [self addChild:_rectNode];
            
            x+=blockWidth;
        }
        x = 0-mazeScreenWidth/2;
        y -=  blockHeight;
    }
}
-(void) keyDown:(NSEvent *)event{
    if([event keyCode] == 49)
        isForwardAnimating = YES;
    if([event keyCode] == 51)
        isBackwardAnimating = YES;
}
-(void) keyUp:(NSEvent *)event{
    NSLog(@"%d",[event keyCode]);
    //Speed operation
    if([event keyCode] == 126){
        if(interval > 0.001){
            interval -=0.001;
        }
        return;
    }
    
    if([event keyCode] == 125){
        if(interval < 0.1){
            interval +=0.001;
        }
        return;
    }
    
    //Animation operations
    
    isForwardAnimating = NO;
    isBackwardAnimating = NO;
    
    if([event keyCode] == 124)
        [self nextAnimationFrame];
    
    if([event keyCode] == 123)
        [self previousAnimationFrame];
    
    // Switching maze or mode
    if([event keyCode] == 18){
        file =@"smallMaze";
        [self solve:file method:solveMethod];
    }
    if([event keyCode] == 19){
        file = @"mediumMaze";
        [self solve:file method:solveMethod];
    }
    if([event keyCode] == 20){
        file = @"largeMaze";
        [self solve:file method:solveMethod];
    }
    if([event keyCode] == 11){
        solveMethod = 1;
        [self solve:file method:solveMethod];
    }
    if([event keyCode] == 2){
        solveMethod = 2;
        [self solve:file method:solveMethod];
    }
}

- (void)mouseDown:(NSEvent *)theEvent {
    isForwardAnimating = !isForwardAnimating;
}
-(void) previousAnimationFrame{
    if(steps < 0)
        return;
    AnimationState *aState = [solution objectAtIndex:steps];
    if(aState.addToScreen){
        [aState.state.graphic removeFromParent];
    }else{
        [self addChild:aState.state.graphic];
    }
    steps--;
}

-(void) nextAnimationFrame{
    steps++;
    if(steps == [solution count]){
        isForwardAnimating = NO;
        isBackwardAnimating = NO;
        steps = (int)[solution count]-1;
        return;
    }
    AnimationState *aState = [solution objectAtIndex:steps];
    if(aState.addToScreen){
        [self addChild:aState.state.graphic];
    }else{
        [aState.state.graphic removeFromParent];
    }
}

-(void)update:(CFTimeInterval)currentTime {
    if(isForwardAnimating){
        if(currentTime!=-1){
            if(currentTime-previousTime > interval){
                [self nextAnimationFrame];
                previousTime = currentTime;
            }
        }else{
            previousTime = currentTime;
        }
    }
    if(isBackwardAnimating){
        if(currentTime!=-1){
            if(currentTime-previousTime > interval){
                [self previousAnimationFrame];
                previousTime = currentTime;
                
            }
        }else{
            previousTime = currentTime;
        }
    }
}

@end
