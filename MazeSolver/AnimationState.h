//
//  AnimationState.h
//  MazeSolver
//
//  Created by Xander on 11/10/16.
//  Copyright © 2016 Xander. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "State.h"
@interface AnimationState : NSObject

@property State *state;
@property BOOL addToScreen;
@property BOOL removeFromScreen;

@end
