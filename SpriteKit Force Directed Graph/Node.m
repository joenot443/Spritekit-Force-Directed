//
//  ArtistNode.m
//  SceneKit Directed Graph Engine
//
//  Created by Joe Crozier on 2014-08-24.
//  Copyright (c) 2014 Joe Crozier Software. All rights reserved.
//

#import "Node.h"
#import "VectorMath.h"
#define REPULSION           100000.0;
#define RELATED_REPULSION   4000.0;
#define ATTRACTION          0.6;
#define CENTER_REPEL        1.0;
#define CENTER_ATTRACT      0.3;



@implementation Node{
    
}

@synthesize name, size, descriptionHTML, imageURLString;



-(void)initWithName:(NSString *)name{
    self.name = name;
    self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.frame.size];
    self.physicsBody.affectedByGravity = NO;
    self.physicsBody.collisionBitMask = 0;
    self.physicsBody.contactTestBitMask = nil;
}


- (void)runForces {
    //Iterate through the list of related nodes
    //Apply a hooke's law force to all nodes in related artists
    
    
    VectorMath *vectorMath = [[VectorMath alloc]init];
    
    //The force vector we'll be continually adding to
    CGVector forceVector = CGVectorMake(0,0);
    
    //Delegate is our parent controller, it contains an array of all drawn nodes
    for (Node *a2 in self.delegate.drawNodes) {
        
        //Check if related
        if ([self.relatedNodes containsObject:a2]) {
            
            //Since it's related, we apply Hooke's law
            
            //The vector between a1 and a2
            CGVector v1 = [vectorMath createVector:self with:a2];
            float j = ATTRACTION;
            v1 = [vectorMath scalarMultiply:v1 and:j];
            
            //Add this to our force vector
            forceVector = [vectorMath addVectors:forceVector and:v1];

            //Create a vector slightly repelling related nodes, so they don't get too close
            CGVector v2 = [vectorMath createVector:self with:a2];
            v2 = [vectorMath negateVector:v2];
            float r = [vectorMath magnitude:v2];
            j = RELATED_REPULSION;
            float t = j*(1/(r*r*r));
            CGVector u1 = [vectorMath unitVector:v2];
            CGVector f1 = [vectorMath scalarMultiply:u1 and:t];
            
            //Add this to our force vector
            forceVector = [vectorMath addVectors:forceVector and:f1];

            
        }
        else if (![a2.name isEqualToString:self.name]){
            //It's not related, so we'll apply Coulomb's law
            
            // F = k * ((q1*q2)/r^2) * R
            
            //Create a vector repelling the nodes
            CGVector v1 = [vectorMath createVector:self with:a2];
            v1 = [vectorMath negateVector:v1];
            float r = [vectorMath magnitude:v1];
            float j = REPULSION;
            float t = j * (1/(r*r));
            CGVector u1 = [vectorMath unitVector:v1];
            CGVector f1 = [vectorMath scalarMultiply:u1 and:t];
            
            //Add this to our force vector
            forceVector = [vectorMath addVectors:forceVector and:f1];
            
        }
    }
    //Create a vector that pushes the node to the center
    
    CGVector centerAttractVector = [vectorMath vectorToPoint:self point:CGPointMake(320, 568)];
    float j = CENTER_ATTRACT
    centerAttractVector = [vectorMath scalarMultiply:centerAttractVector and:j];
    CGVector centerRepelVector = [vectorMath vectorToPoint:self point:CGPointMake(320, 568)];
    centerRepelVector = [vectorMath negateVector:centerRepelVector];
    float r = [vectorMath magnitude:centerRepelVector];
    j = CENTER_REPEL;
    float t = j * (1/(r*r));
    CGVector u1 = [vectorMath unitVector:centerRepelVector];
    centerRepelVector = [vectorMath scalarMultiply:u1 and:t];
    CGVector centerVector = [vectorMath addVectors:centerRepelVector and:centerAttractVector];
    
    forceVector = [vectorMath addVectors:forceVector and:centerVector];
//    NSLog(@"Final force on %@: %f, %f", self.name, finalForce.dx, finalForce.dy);
    
    float forceMagnitude = [vectorMath magnitude:forceVector];
    //Check if vector is powerful enough to be counted
    if (forceMagnitude > 10.0) [self.physicsBody applyForce:forceVector];

    currentVector = forceVector;
    self.delegate.totalEnergy += [vectorMath magnitude:self.physicsBody.velocity]*100;

}



@end
