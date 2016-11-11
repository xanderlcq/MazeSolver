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
    SKShapeNode *_spinnyNode;
    SKLabelNode *_label;
    int counter;
    double width;
    double height;
    int steps;
    NSString *fileName;
    
}

- (void)didMoveToView:(SKView *)view {
    
    steps = 0;
    fileName = @"largeMaze";
    // Setup your scene here
    
    // Get label node from scene and store it for use later
    _label = (SKLabelNode *)[self childNodeWithName:@"//helloLabel"];
    
    _label.alpha = 0.0;
    [_label runAction:[SKAction fadeInWithDuration:2.0]];
    
    CGFloat w = (self.size.width + self.size.height) * 0.05;
    
    // Create shape node to use during mouse interaction
    _spinnyNode = [SKShapeNode shapeNodeWithRectOfSize:CGSizeMake(w, w) cornerRadius:w * 0.3];
    _spinnyNode.lineWidth = 2.5;
    
    [_spinnyNode runAction:[SKAction repeatActionForever:[SKAction rotateByAngle:M_PI duration:1]]];
    [_spinnyNode runAction:[SKAction sequence:@[
                                                [SKAction waitForDuration:0.5],
                                                [SKAction fadeOutWithDuration:0.5],
                                                [SKAction removeFromParent],
                                                ]]];
    SKShapeNode *_rectNode = [SKShapeNode shapeNodeWithRect:CGRectMake(0.0, 0.0, 10, 10)];
    _rectNode.lineWidth = 3;
    _rectNode.strokeColor = [SKColor redColor];

    masterMaze = [[Maze alloc] init];
    [masterMaze loadMaze:fileName];
    width =self.size.width/[[[masterMaze getMazeArray] objectAtIndex:0] count];
    height =self.size.height/[[masterMaze getMazeArray] count];
    //[self drawMaze:masterMaze];
    
}
-(void) drawMaze:(Maze *) maze{
    NSMutableArray *mazeArray = [maze getMazeArray];
    double x = 0-self.size.width/2;
    double y = 0+self.size.height/2-height; //Why 0,0 of the rectangle is the bottom left
    
    for(int i = 0; i < [mazeArray count];i++){
        for(int k = 0; k < [[mazeArray objectAtIndex:0] count];k++){
            SKShapeNode *_rectNode = [SKShapeNode shapeNodeWithRect:CGRectMake(x, y, width, height)];
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
            
            x+=width;
        }
        x = 0-self.size.width/2;
        y -=  height;
    }
    

}
- (void)touchDownAtPoint:(CGPoint)pos {
    SKShapeNode *n = [_spinnyNode copy];
    n.position = pos;
    n.strokeColor = [SKColor greenColor];
    [self addChild:n];
}

- (void)touchMovedToPoint:(CGPoint)pos {
    SKShapeNode *n = [_spinnyNode copy];
    n.position = pos;
    n.strokeColor = [SKColor blueColor];
    [self addChild:n];
}

- (void)touchUpAtPoint:(CGPoint)pos {
    SKShapeNode *n = [_spinnyNode copy];
    n.position = pos;
    n.strokeColor = [SKColor redColor];
    [self addChild:n];
}

- (void)keyDown:(NSEvent *)theEvent {
    switch (theEvent.keyCode) {
        case 0x31 /* SPACE */:
            // Run 'Pulse' action from 'Actions.sks'
            [_label runAction:[SKAction actionNamed:@"Pulse"] withKey:@"fadeInOut"];
            break;
            
        default:
            NSLog(@"keyDown:'%@' keyCode: 0x%02X", theEvent.characters, theEvent.keyCode);
            break;
    }
}

- (void)mouseDown:(NSEvent *)theEvent {
    steps++;
    [self removeAllChildren];
    [masterMaze loadMaze:fileName];
    [self drawMaze:masterMaze];
    [self solve:masterMaze solution:[[NSMutableArray alloc] init] mode:2];
}
- (void)mouseDragged:(NSEvent *)theEvent {
}
- (void)mouseUp:(NSEvent *)theEvent {
}


-(void)update:(CFTimeInterval)currentTime {
    // Called before each frame is rendered
}
-(BOOL) solve:(Maze*) maze solution:(NSMutableArray *) sol mode:(int) mode{
    if(!sol){
        sol = [[NSMutableArray alloc] init];
    }
    State *start = [maze getStart];
    counter = 0;
    //BFS
    if(mode == 1){
        BfsState *state0 = [[BfsState alloc] initWithXY:start.x y:start.y];
        Queue *q = [[Queue alloc] initWith:state0];
        if(![self solveBfsIterative:q maze:maze]){
            return NO;
        }
        
        //Trace it back from the end
        BfsState *state = (BfsState *)[q peek];
        [sol addObject:state];
        while(state.prev){
            NSLog(@"Bfs -- X: %d Y: %d",state.x,state.y);
            state = state.prev;
            [sol addObject:state];
        }
    }
    //DFS
    if(mode == 2){
        DfsState *state0 = [[DfsState alloc] initWithXY:start.x y:start.y];
        Stack *stack = [[Stack alloc] init];
        if(![self solveDfs:state0 path:stack maze:maze]){
            return NO;
        }
        DfsState *end = (DfsState *)[stack peek];
        while([stack peek]){
            [sol insertObject:[stack pop] atIndex:0];
        }
        NSLog(@"Dfs -- X: %d Y: %d",end.x,end.y);
    }
    NSLog(@"Depth: %d",counter);
    return YES;
}

//Iterative
-(BOOL) solveBfsIterative:(Queue *) q maze:(Maze *) maze{
    while(YES){
        //Debugger
        counter ++;
        
        if([q isEmpty]){
            return NO;
        }
        
        if([maze isFinished:[q peek]]){
            return YES;
        }
        
        BfsState *current = (BfsState *)[q dequeue];
        [maze mark:current];
        while([current hasNext:maze]){
            BfsState *neighbor = [current getNext:maze];
            if(neighbor){
                [q enqueue:neighbor];
            }
        }
    }
}


// Recursive
-(BOOL) solveBfsRecursive:(Queue *) q maze:(Maze *) maze{
    counter ++;
    if([q isEmpty]){
        return NO;
    }
    if([maze isFinished:[q peek]]){
        return YES;
    }
    BfsState *current = (BfsState *)[q dequeue];
    [maze mark:current];
    while([current hasNext:maze]){
        BfsState *neighbor = [current getNext:maze];
        if(neighbor){
            [q enqueue:neighbor];
        }
    }
    return [self solveBfsRecursive:q maze:maze];
}



-(BOOL)solveDfs:(DfsState *) current path:(Stack *) path maze:(Maze *) maze{
    if(counter > steps){
        //return YES;
    }
    counter ++;
    if([path isEmpty]){
        if(![maze isStart:current])
            return NO;
    }
    if([maze isFinished:current]){
        [path push:current];
        return YES;
    }
    
    while([current hasNext:maze]){
        DfsState *next = [current getNext:maze];
        if(next){
            if(![[path peek] equals:next]){
                NSLog(@"PUSHING x: %d y: %d",current.x,current.y);
                [current setupGraphics:self.size.width windowHeight:self.size.height blockWidth:width blockHeight:height];
                current.graphic.fillColor = [SKColor yellowColor];
                [self addChild:current.graphic];
                [path push:current];
                [maze mark:current];
                if(![self solveDfs:next path:path maze:maze]){
                    DfsState *temp = (DfsState *)[path pop];
                    NSLog(@"POPING x: %d y: %d",temp.x,temp.y);
                    [temp.graphic removeFromParent];
                }else{
                    return YES;
                }
            }
        }else{
            break;
        }
    }
    return NO;
}
@end
