//
//  EdgeNode.h
//  SceneKit Directed Graph Engine
//
//  Created by Joe Crozier on 2014-10-28.
//  Copyright (c) 2014 Joe Crozier Software. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "Node.h"

@interface EdgeNode : SKShapeNode

@property Node *node1, *node2;
@property CGMutablePathRef linePath;

- (void)edgeWithArtists: (Node *)artist1 and:(Node *)artist2;

- (void)drawEdgePath;
- (void)updateEdgePath;
@end
