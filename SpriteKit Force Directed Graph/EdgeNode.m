//
//  EdgeNode.m
//  SceneKit Directed Graph Engine
//
//  Created by Joe Crozier on 2014-10-28.
//  Copyright (c) 2014 Joe Crozier Software. All rights reserved.
//

#import "EdgeNode.h"


@implementation EdgeNode

- (void)edgeWithArtists:(Node *)node1 and:(Node *)node2{
    self.node1 = node1;
    self.node2 = node2;
}

- (void)drawEdgePath {
    //Create a path between the two nodes
    self.linePath = CGPathCreateMutable();
    CGPathMoveToPoint(self.linePath, NULL, self.node1.position.x, self.node1.position.y);
    CGPathAddLineToPoint(self.linePath, NULL, self.node2.position.x, self.node2.position.y);
    self.path = self.linePath;
    [self setStrokeColor:[UIColor blackColor]];
    self.alpha = 0.1;
}

- (void)updateEdgePath{
    //Reset the path on each frame
    self.linePath = nil;
    self.linePath = CGPathCreateMutable();
    CGPathMoveToPoint(self.linePath, NULL, self.node1.position.x, self.node1.position.y);
    CGPathAddLineToPoint(self.linePath, NULL, self.node2.position.x, self.node2.position.y);
    self.path = self.linePath;
    [self setStrokeColor:[UIColor blackColor]];
    self.alpha = 0.1;
    //Release the path to prevent a memory leak
    CGPathRelease(self.linePath);
    
}


@end
