//
//  VectorMath.h
//
//  Created by Joe Crozier on 2014-09-21.
//  Copyright (c) 2014 Joe Crozier Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SpriteKit/SpriteKit.h>
#import "Node.h"

@interface VectorMath : NSObject

- (CGVector) addVectors: (CGVector)v1 and: (CGVector)v2;

- (CGVector) subtractVectors: (CGVector)v1 and: (CGVector)v2;

- (CGVector) scalarMultiply: (CGVector)v1 and: (float)c;

- (CGVector) sumArray: (NSArray* )vectors;

- (CGVector) createVector: (Node *)a1 with: (Node *) a2;

- (float)magnitude: (CGVector)v1;

- (CGVector)unitVector: (CGVector)v1;

- (CGVector)negateVector: (CGVector)v1;

- (CGVector)vectorToPoint: (Node *)a1 point:(CGPoint)p;

@end
