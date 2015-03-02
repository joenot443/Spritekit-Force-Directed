
#import <SpriteKit/SpriteKit.h>


@class MainViewController;


//Anchor point is {0,1} <-- Don't change that or scrolling will get messed-up
//If you want to use some other anchor point, add a subnode with a more appropriate
//anchor point and offset it appropriately; see the spriteForScrollingGeometry and
//spriteForStaticGeometry private properties in initWithSize: for how to do this.

@interface ScrollScene : SKScene {
    NSArray *artistNames;
    NSArray *nodes;
    NSMutableDictionary *nodesDictionary;
    bool changedCollision;
    bool sceneComplete;

}
@property (nonatomic) CGSize contentSize;
@property(nonatomic) CGPoint contentOffset;
@property(nonatomic) float totalEnergy;

@property (nonatomic, retain) MainViewController *delegateViewController;

@property (nonatomic) NSArray *nodes;
@property NSMutableArray *drawNodes, *edgeNodes, *nodeLocations;

-(void)setContentScale:(CGFloat)scale;

@end
