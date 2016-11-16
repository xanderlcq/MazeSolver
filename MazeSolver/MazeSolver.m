//
//  MazeSolver.m
//  MazeSolver
//
//  Created by Xander on 11/10/16.
//  Copyright © 2016 Xander. All rights reserved.
//

#import "MazeSolver.h"

@implementation MazeSolver

-(id) initWithWindowSize:(NSString *)f windowWidth:(double)w windowHeight:(double) h{
    self = [super init];
    if(self){
        windowWidth = w;
        windowHeight = h;
        masterMaze = [[Maze alloc] init];
        [masterMaze loadMaze:f];
        blockWidth =w/[masterMaze getWidth];
        blockHeight =h/[masterMaze getHeight];
        self.fileName = f;
    }
    return self;
}



-(NSMutableArray *) solve:(int) mode{
    NSMutableArray *animationArray = [[NSMutableArray alloc] init];
    if(!masterMaze || (mode!= 1 && mode != 2))
        return nil;
    
    Maze *maze = [[Maze alloc] init];
    [maze loadMaze:self.fileName];
    State *start = [maze getStart];
    
    if(mode == 1){
        BfsState *state0 = [[BfsState alloc] initWithXY:start.x y:start.y];
        Queue *q = [[Queue alloc] initWith:state0];
        
        if(![self solveBfsIterative:q maze:maze animation:animationArray]){
            return animationArray;
        }
        
        BfsState *state = (BfsState *)[q peek];
        
        //For Graphic
        state = state.prev;
        
        
        while(state.prev){
            //NSLog(@"Bfs -- X: %d Y: %d",state.x,state.y);
            
            //Back Tracking Graphics
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
            return animationArray;
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
        
        // Add searching head animation
        BfsState *currentSearchAnimation = [[BfsState alloc] initWithXY:current.x y:current.y];
        [currentSearchAnimation setupGraphics:windowWidth windowHeight:windowHeight blockWidth:blockWidth blockHeight:blockHeight];
        currentSearchAnimation.graphic.fillColor = [SKColor redColor];
        AnimationState *addingSearchState = [[AnimationState alloc] init];
        addingSearchState.state = currentSearchAnimation;
        addingSearchState.addToScreen = YES;
        addingSearchState.removeFromScreen = NO;
        [aArray addObject:addingSearchState];
        
        
        
        while([current hasNext:maze]){
            BfsState *neighbor = [current getNext:maze];
            if(neighbor){
                [aArray addObject:[self createAnimationState:neighbor addToScreen:YES]];
                [q enqueue:neighbor];
            }
        }
        
        // Removing searching head animation
        AnimationState *removingSearchState = [[AnimationState alloc] init];
        removingSearchState.state = currentSearchAnimation;
        removingSearchState.addToScreen = NO;
        removingSearchState.removeFromScreen = YES;
        [aArray addObject:removingSearchState];
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
    [aArray addObject:[self createAnimationState:current addToScreen:YES]];

    while([current hasNext:maze]){
        BfsState *neighbor = [current getNext:maze];
        if(neighbor){
            [q enqueue:neighbor];
        }
    }
    return [self solveBfsRecursive:q maze:maze animation:aArray];
}



-(BOOL)solveDfs:(DfsState *) current path:(Stack *) path maze:(Maze *) maze  animation:(NSMutableArray *) aArray{
    //Not solvable
    if([path isEmpty]){
        if(![maze isStart:current])
            return NO;
        else
            [aArray addObject:[self createAnimationState:current addToScreen:YES]];
    }
    //Done
    if([maze isFinished:current]){
        [aArray removeLastObject];
        [path push:current];
        return YES;
    }
    //Solve
    while([current hasNext:maze]){
        DfsState *next = [current getNext:maze];
        if(next){
            if(![[path peek] equals:next]){
                NSLog(@"PUSHING x: %d y: %d",current.x,current.y);

                [aArray addObject:[self createAnimationState:next addToScreen:YES]];
                
                [path push:current];
                [maze mark:current];
                if(![self solveDfs:next path:path maze:maze animation:aArray]){
                    [path pop];
                    NSLog(@"POPING x: %d y: %d",next.x,next.y);
                    [aArray addObject:[self createAnimationState:next addToScreen:NO]];
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



-(AnimationState *)createAnimationState:(State *) current addToScreen:(BOOL) aToScreen{
    [current setupGraphics:windowWidth windowHeight:windowHeight blockWidth:blockWidth blockHeight:blockHeight];
    current.graphic.fillColor = [SKColor purpleColor];
    AnimationState *aState = [[AnimationState alloc] init];
    aState.state = current;
    if(aToScreen){
        aState.addToScreen = YES;
    }else{
        aState.removeFromScreen = YES;
    }
    return aState;
}

@end
