//
//  MazeSolver.m
//  MazeSolver
//
//  Created by Xander on 11/10/16.
//  Copyright © 2016 Xander. All rights reserved.
//

#import "MazeSolver.h"

@implementation MazeSolver

-(id) initWithWindowSize:(Maze *) m windowWidth:(double)w windowHeight:(double) h{
    self = [super init];
    if(self){
        windowWidth = w;
        windowHeight = h;
        masterMaze = m;
        blockWidth =w/[masterMaze getWidth];
        blockHeight =h/[masterMaze getHeight];
    }
    return self;
}



-(NSMutableArray *) solve:(Maze *) maze mode:(int) mode{
    NSMutableArray *animationArray = [[NSMutableArray alloc] init];
    if(!masterMaze || (mode!= 1 && mode != 2))
        return nil;
    State *start = [masterMaze getStart];
    
    if(mode == 1){
        BfsState *state0 = [[BfsState alloc] initWithXY:start.x y:start.y];
        Queue *q = [[Queue alloc] initWith:state0];
        
        if(![self solveBfsIterative:q maze:maze animation:animationArray]){
            return nil;
        }
        
        BfsState *state = (BfsState *)[q peek];
        while(state.prev){
            NSLog(@"Bfs -- X: %d Y: %d",state.x,state.y);
            
            BfsState *animationTemp = [[BfsState alloc] initWithXY:state.x y:state.y];
            [animationTemp setupGraphics:windowWidth windowHeight:windowHeight blockWidth:blockWidth blockHeight:blockHeight];
            animationTemp.graphic.fillColor = [SKColor blueColor];
            AnimationState *aState = [[AnimationState alloc] init];
            aState.state = animationTemp;
            aState.addToScreen = YES;
            [animationArray addObject:aState];
            
            state = state.prev;

        }
    }
    
    //DFS
    if(mode == 2){
        DfsState *state0 = [[DfsState alloc] initWithXY:start.x y:start.y];
        Stack *stack = [[Stack alloc] init];
        if(![self solveDfs:state0 path:stack maze:maze animation:animationArray]){
            return nil;
        }
    }
    return animationArray;
}

//Iterative
-(BOOL) solveBfsIterative:(Queue *) q maze:(Maze *) maze animation:(NSMutableArray *) aArray{
    while(YES){
        if([q isEmpty]){
            return NO;
        }
        
        if([maze isFinished:[q peek]]){
            return YES;
        }
        
        BfsState *current = (BfsState *)[q dequeue];
        [maze mark:current];
        
        //Without initing new state
        [current setupGraphics:windowWidth windowHeight:windowHeight blockWidth:blockWidth blockHeight:blockHeight];
        current.graphic.fillColor = [SKColor yellowColor];
        AnimationState *aState = [[AnimationState alloc] init];
        aState.state = current;
        aState.addToScreen = YES;
        [aArray addObject:aState];
        
        while([current hasNext:maze]){
            BfsState *neighbor = [current getNext:maze];
            if(neighbor){
                [q enqueue:neighbor];
            }
        }
    }

}


// Recursive
-(BOOL) solveBfsRecursive:(Queue *) q maze:(Maze *) maze animation:(NSMutableArray *) aArray{
    if([q isEmpty]){
        return NO;
    }
    if([maze isFinished:[q peek]]){
        return YES;
    }
    BfsState *current = (BfsState *)[q dequeue];
    [maze mark:current];
    
    //Without initing new state
    [current setupGraphics:windowWidth windowHeight:windowHeight blockWidth:blockWidth blockHeight:blockHeight];
    current.graphic.fillColor = [SKColor yellowColor];
    AnimationState *aState = [[AnimationState alloc] init];
    aState.state = current;
    aState.addToScreen = YES;
    [aArray addObject:aState];

    while([current hasNext:maze]){
        BfsState *neighbor = [current getNext:maze];
        if(neighbor){
            [q enqueue:neighbor];
        }
    }
    return [self solveBfsRecursive:q maze:maze animation:aArray];
}



-(BOOL)solveDfs:(DfsState *) current path:(Stack *) path maze:(Maze *) maze  animation:(NSMutableArray *) aArray{
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

                //Without initing new state
                [current setupGraphics:windowWidth windowHeight:windowHeight blockWidth:blockWidth blockHeight:blockHeight];
                current.graphic.fillColor = [SKColor yellowColor];
                AnimationState *aState = [[AnimationState alloc] init];
                aState.state = current;
                aState.addToScreen = YES;
                [aArray addObject:aState];
                
                [path push:current];
                [maze mark:current];
                if(![self solveDfs:next path:path maze:maze animation:aArray]){
                    
                    //Without initing new state
                    DfsState *temp = (DfsState *)[path pop];
                    NSLog(@"POPING x: %d y: %d",temp.x,temp.y);
                    AnimationState *aState = [[AnimationState alloc] init];
                    aState.state = temp;
                    aState.removeFromScreen = YES;
                    [aArray addObject:aState];

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
