//
//  Stack.h
//  MazeSolver
//
//  Created by Xander on 11/4/16.
//  Copyright © 2016 Xander. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "State.h"
@interface Stack : NSObject{
    NSMutableArray *myStack;
}
-(id) init;
-(id) initWith:(State *)s;
-(State *) pop;
-(State *) peek;
-(bool) isEmpty;
-(void) push:(State *) s;
@end
