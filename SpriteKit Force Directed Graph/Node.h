//
//  ArtistNode.h
//  SceneKit Directed Graph Engine
//
//  Created by Joe Crozier on 2014-08-24.
//  Copyright (c) 2014 Joe Crozier Software. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "ScrollScene.h"

@class ScrollScene;

@interface Node : SKLabelNode {
    CGVector currentVector;
}

@property (nonatomic, retain) ScrollScene* delegate;
@property (nonatomic, retain) NSArray *relatedNodes, *topTracks;
@property (nonatomic) CGSize *nodeSize;
@property (nonatomic, retain) NSMutableArray *drawnArtists;
@property (nonatomic, retain) NSString *name, *descriptionHTML, *imageURLString;
@property (nonatomic, retain) UIColor *color;
@property (nonatomic) int size, albums;
@property (nonatomic) CGPoint relativePosition;
@property (nonatomic) CGRect relativeRect;

-(void)initWithName:(NSString *)name;

-(void)runForces;


@end
