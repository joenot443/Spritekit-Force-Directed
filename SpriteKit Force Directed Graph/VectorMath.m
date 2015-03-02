//
//  VectorMath.m
//  SceneKit Directed Graph Engine
//
//  Created by Joe Crozier on 2014-09-21.
//  Copyright (c) 2014 Joe Crozier Software. All rights reserved.
//

#import "VectorMath.h"
#import "Node.h"

@implementation VectorMath

//Addition of two vectors, v1 + v2

- (CGVector) addVectors:(CGVector)v1 and:(CGVector)v2 {
    CGVector v3 = CGVectorMake(v1.dx+v2.dx, v1.dy+v2.dy);
    return v3;
}

//Subtraction of two vectors, v1 - v2

- (CGVector) subtractVectors:(CGVector)v1 and:(CGVector)v2 {
    CGVector v3 = CGVectorMake(v1.dx-v2.dx, v1.dy-v2.dy);
    return v3;
}

//Scalar multiplication of a vector and a constant float, v1*c

- (CGVector) scalarMultiply:(CGVector)v1 and:(float)c {
    CGVector v3 = CGVectorMake(v1.dx*c, v1.dy*c);
    return v3;
}

//Summation of an NSArray of vectors

- (CGVector)sumArray:(NSArray *)vectors {
    
    CGVector v1 = CGVectorMake(0, 0);
    for (int i = 0; i < vectors.count; i++) {
        NSValue *v = [vectors objectAtIndex:i];
        CGVector v2 = [v CGVectorValue];
        v1 = [self addVectors:v1 and:v2];
    }
    return v1;
}

//Create a vector between two SKNodes

- (CGVector)createVector:(Node *)a1 with:(Node *)a2 {
    CGVector v1 = CGVectorMake(a2.position.x - a1.position.x, a2.position.y - a1.position.y);
    return v1;
}

//Magnitude of a vector

- (float)magnitude: (CGVector)v1 {
    float m = v1.dx*v1.dx + v1.dy*v1.dy;
    m = sqrt(m);
    return m;
}

//Unit vector of a vector

- (CGVector)unitVector: (CGVector)v1{
    float m = [self magnitude:v1];
    v1 = [self scalarMultiply:v1 and:1/m];
    return v1;
}

//Negation of a vector

- (CGVector)negateVector: (CGVector)v1{
    return CGVectorMake(v1.dx*(-1), v1.dy*(-1));
}

//Vector from an SKNode to a point to a vector

- (CGVector)vectorToPoint: (Node *)a1 point:(CGPoint)p {
    CGVector v1 = CGVectorMake(p.x-a1.position.x, p.y-a1.position.y);
    return v1;
}

@end
