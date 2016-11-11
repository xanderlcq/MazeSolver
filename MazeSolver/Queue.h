//
//  Queue.h
//  MazeSolver
//
//  Created by Xander on 11/8/16.
//  Copyright © 2016 Xander. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "State.h"
@interface Queue : NSObject{
    NSMutableArray *myQueue;
}
-(id) init;
-(id) initWith:(State *)s;
-(void) enqueue:(State *)s;
-(State *) dequeue;
-(State *) peek;
-(bool) isEmpty;
@end
