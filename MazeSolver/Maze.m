//
//  Maze.m
//  MazeSolver
//
//  Created by Xander on 11/4/16.
//  Copyright © 2016 Xander. All rights reserved.
//

#import "Maze.h"

@implementation Maze
-(NSMutableArray *) getMazeArray{
    return maze;
}

-(id) init{
    self = [super init];
    if(self){
        maze = [[NSMutableArray alloc] init];
    }
    return self;
}

-(int) getWidth{
    return (int)[[maze objectAtIndex:0] count];
}
-(int) getHeight{
    return (int)[maze count];
}

-(bool) isEmpty:(State *) state{
    //NSLog(@"X: %d  Y: %d",state.x,state.y);
    //NSLog(@"X max: %lu  Y max: %lu",(unsigned long)[[maze objectAtIndex:0] count],(unsigned long)[maze count]);
    if(state.y < 0||state.y >= (int)[maze count] ||state.x < 0 || state.x >= (int)[[maze objectAtIndex:0] count]){
      //  NSLog(@"Out of Maze");
        return NO;
    }
    NSString *point = [self getPointAt:state.x y:state.y];

    return [point  isEqual: @"."]||[point  isEqual: @"G"];
}
-(bool) isFinished:(State *) state{
    if(state.y < 0||state.y >= (int)[maze count] ||state.x < 0 || state.x >= (int)[[maze objectAtIndex:0] count]){
        //  NSLog(@"Out of Maze");
        return NO;
    }
    NSString *point = [self getPointAt:state.x y:state.y];
    return [point  isEqual: @"G"];
}
-(bool) isStart:(State *) state{
    if(state.y < 0||state.y >= (int)[maze count] ||state.x < 0 || state.x >= (int)[[maze objectAtIndex:0] count]){
        //  NSLog(@"Out of Maze");
        return NO;
    }
    NSString *point = [self getPointAt:state.x y:state.y];
    return [point  isEqual: @"S"];
}




-(NSString *) getPointAt:(int)x y:(int) y{
    return [[maze objectAtIndex:y] objectAtIndex:x];
}


-(BOOL) loadMaze:(NSString *) fileName{
    maze = [[NSMutableArray alloc] init];
    NSString* path = [[NSBundle mainBundle] pathForResource:fileName ofType:@"txt"];
    NSError *errorReading;
    if(errorReading){
        NSLog(@"Reading error  %@",errorReading);
        maze = nil;
        return NO;
    }
    NSArray *linesOfText = [[NSString stringWithContentsOfFile:path
                                                      encoding:NSUTF8StringEncoding
                                                         error:&errorReading]
                            componentsSeparatedByString:@"\n"];
    
    
    for(int i = 0; i < [linesOfText count]-1;i++){
        //NSLog(@"%@",[linesOfText objectAtIndex:i]);
        NSMutableArray *arr = [[NSMutableArray alloc]init];
        //NSLog(@"%lu",(unsigned long)[[linesOfText objectAtIndex:i] length]);
        for (int j = 0; j < [[linesOfText objectAtIndex:i] length]; j ++) {
            [arr addObject:[NSString stringWithFormat:@"%c", [[linesOfText objectAtIndex:i] characterAtIndex:j
                                                              ]]];
        }
        [maze addObject:arr];
    }
    return YES;
}
-(void) printMaze{
    for(int i = 0; i < [maze count];i++){
        for(int k = 0; k < [[maze objectAtIndex:i] count];k++){
            NSLog(@"%@",[[maze objectAtIndex:i] objectAtIndex:k]);
        }
        NSLog(@"\n");
    }
}
-(State *) getStart{
    for(int i = 0; i < [maze count];i++){
        for(int k = 0; k < [[maze objectAtIndex:i] count];k++){
            if([[[maze objectAtIndex:i] objectAtIndex:k]isEqual: @"S"]){
                return [[State alloc] initWithXY:k y:i];
            }
        }
    }
    return nil;
}
-(void) mark:(State *) state{
    [[maze objectAtIndex:state.y] setObject:@"#" atIndex:state.x];
}



@end
