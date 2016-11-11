//
//  Stack.m
//  MazeSolver
//
//  Created by Xander on 11/4/16.
//  Copyright © 2016 Xander. All rights reserved.
//

#import "Stack.h"

@implementation Stack
-(id) init{
    self = [super init];
    if(self){
        myStack = [[NSMutableArray alloc] init];
    }
    return self;
}
-(id) initWith:(State *)s{
    self = [super init];
    if(self){
        myStack = [[NSMutableArray alloc] init];
        [myStack addObject:s];
    }
    return self;
}
-(State *) pop{
    State *top = [myStack firstObject];
    [myStack removeObjectAtIndex:0];
    return top;
}
-(State *) peek{
    return [myStack firstObject];
}
-(bool) isEmpty{
    return 0==[myStack count];
}
-(void) push:(State *) s{
    [myStack insertObject:s atIndex:0];
}

@end
