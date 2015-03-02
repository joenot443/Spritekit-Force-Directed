
#import "ScrollScene.h"
#import "Node.h"
#import "EdgeNode.h"
#import "MainViewController.h"

#define SPEED 7.0
#define DAMPING 700.0
//MIN_ENERGY defines the minimum threshold at which the simulation stops.
//A good metric is NodeCount * 100
#define MIN_ENERGY 600.0


typedef NS_ENUM(NSInteger, IIMySceneZPosition)
{
    kIIMySceneZPositionScrolling = 0,
    kIIMySceneZPositionVerticalAndHorizontalScrolling,
    kIIMySceneZPositionStatic,
};

@interface ScrollScene ()
//kIIMySceneZPositionScrolling
@property (nonatomic, weak) SKSpriteNode *spriteToScroll;
@property (nonatomic, weak) SKSpriteNode *spriteForScrollingGeometry;

//kIIMySceneZPositionStatic
@property (nonatomic, weak) SKSpriteNode *spriteForStaticGeometry;

//kIIMySceneZPositionVerticalAndHorizontalScrolling
@property (nonatomic, weak) SKSpriteNode *spriteToHostHorizontalAndVerticalScrolling;
@property (nonatomic, weak) SKSpriteNode *spriteForHorizontalScrolling;
@property (nonatomic, weak) SKSpriteNode *spriteForVerticalScrolling;


@end

@implementation ScrollScene

/**
    Builds an array of ArtistNode objects which will later populate our scene.
    The array is build from the data created earlier in ArtistData.plist and ArtistsPlayCount.plist.
 
 */

-(void)createArtistNodes {
    
    //Load the data dict and place the artists in an array

    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    //Read the data from our dictionary 
    
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"NodeData" ofType:@"plist"];
    NSDictionary *dataDict = [NSDictionary dictionaryWithContentsOfFile:plistPath];
    NSMutableArray *edgeNodesMutable = [NSMutableArray array];
    
    NSArray *nodeNamesArray = [dataDict allKeys];
    
    NSLog(@"Test");
    
    
    
    
    //Create a dictionary which will contain the artistString as key and the artistNode as the object
    
    nodesDictionary = [NSMutableDictionary dictionary];
    
    //Create an initial Node for each entry
    //Each Node will also contain eventually contain an array which includes other Node it is related to.
    
    for (NSString *nodeNameString in nodeNamesArray) {
        Node *node = [[Node alloc] init];
        [node initWithName:nodeNameString];
        [nodesDictionary setObject:node forKey:nodeNameString];
    }
    
    //Now that all the nodes exist, we can add an array to each node containing the other nodes it's related to
    
    for (NSString *nodeString in nodeNamesArray){
        NSLog(@"Making node %@", nodeString);
        Node *currentNode = [nodesDictionary objectForKey:nodeString];
        //Load the current artist data from the main dict
        NSDictionary *currentArtistDict = [dataDict objectForKey:nodeString];
        //Load related artists
        NSArray *relatedArray = [currentArtistDict objectForKey:@"RelatedNodes"];
        currentNode.delegate = self;
        NSMutableArray *relatedNodeArray = [NSMutableArray array];
        //Loop through the relatedArray,
        //Find the node for each artist in that
        //Add each artistNode to the relatedNodeArray
        
        for (NSString *relatedNodeString in relatedArray) {
            Node *relatedNode = [nodesDictionary objectForKey:relatedNodeString];
            [relatedNodeArray addObject:relatedNode];
            EdgeNode *lineShape = [EdgeNode node];
            [lineShape edgeWithArtists:currentNode and:relatedNode];
            [edgeNodesMutable addObject:lineShape];
        }
        NSNumber *colourNumber = [currentArtistDict objectForKey:@"Colour"];
        
        //Set color based off of Color in dictionary
        
        NSArray *colorsArray = [NSArray arrayWithObjects:[UIColor redColor], [UIColor blueColor], [UIColor greenColor], [UIColor blackColor],nil];
        
        currentNode.color = [colorsArray objectAtIndex:colourNumber.integerValue];
        
        //Set size based off of Size in dictionary
        
        NSNumber *size = [currentArtistDict objectForKey:@"Size"];
        currentNode.size = size.integerValue;
        currentNode.relatedNodes = relatedNodeArray;
        [nodesDictionary setObject:currentNode forKey:nodeString];
    }
    self.edgeNodes = [[NSMutableArray alloc]initWithArray:edgeNodesMutable];
    self.nodes = [nodesDictionary allValues];
    
}

- (void)buildNodes {
    
    //Test node for checking positions

    [self createArtistNodes];
    
    self.physicsWorld.gravity = CGVectorMake(1.0, 1.0);
    self.physicsWorld.speed = SPEED;
    //Set an initial totalEnergy to ensure collision isn't changed yet
    self.totalEnergy = 1000.0;
    changedCollision = false;
    sceneComplete = false;
    
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"NodeData" ofType:@"plist"];
    NSDictionary *dataDict = [NSDictionary dictionaryWithContentsOfFile:plistPath];
        self.physicsWorld.gravity = CGVectorMake(0, 0);
    
    
    
    self.drawNodes = [NSMutableArray array];
    self.nodeLocations = [NSMutableArray array];
    int j = [self.nodes count];
    
    NSLog(@"Ayy");
    
    //Loop through the list of artists and create a node for each one
    for (int i = 0; i < self.nodes.count; i++) {
        Node *currentNode = [self.nodes objectAtIndex:i];
        
        NSLog(@"Creating node named %@", currentNode.name);
        
        //Initialise it with Arial, a font of 6.0 + plays/100, and the tag color
        [currentNode initWithFontNamed:@"Arial"];
        float fontAdd = currentNode.size/25;
        currentNode.fontSize = 12.0 + fontAdd;
        currentNode.fontColor = currentNode.color;
        currentNode.text = currentNode.name;
        
        //Place the node randomly
        currentNode.position = CGPointMake(arc4random()%500, arc4random()%800);
        currentNode.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:currentNode.frame.size];
        
        //Bitmask of 0 makes it collide with nothing
        currentNode.physicsBody.collisionBitMask = 0;
        currentNode.physicsBody.allowsRotation = NO;
        
        //Assign it a linear of the DAMPING macro
        currentNode.physicsBody.linearDamping = DAMPING;
        [currentNode setZPosition:1.0f];
        
        [self.spriteForScrollingGeometry addChild:currentNode];
        [self.drawNodes addObject:currentNode];
        NSValue *point = [NSValue valueWithCGPoint:currentNode.position];
        [self.nodeLocations addObject:point];
        
    }
    
    //Actually draw the edge between relaed nodes
    for (EdgeNode *edgeNode in self.edgeNodes) {
        [edgeNode drawEdgePath];
        [edgeNode setZPosition:0.5f];
        [self.spriteForScrollingGeometry addChild:edgeNode];
    }
}



- (void)tapReceived:(UITapGestureRecognizer *)tapReognizer {
    CGPoint loc = [tapReognizer locationInView:self.scene.view];
    loc = [self convertPoint:loc toNode:self];
    
    loc = CGPointMake((loc.x+self.contentOffset.x)/self.spriteToScroll.xScale, ((568-loc.y)+(568-self.contentOffset.y))/self.spriteToScroll.yScale);
    
    Node *node = [self.spriteForScrollingGeometry nodeAtPoint:loc];
    
    //Make sure there is a node at that point
    
    if (node.name) {
//        [self.delegateViewController presentArtistPage:artist];
        NSLog(@"%@", node.name);
    }
    //Formula for finding position of tapped location inside spriteForScrollingGeometry
    NSLog(@"Location:   %f, %f", loc.x, 568-loc.y);
    NSLog(@"Scale:      %f, %f", self.spriteToScroll.xScale, self.spriteToScroll.yScale);
    NSLog(@"Offset:     %f, %f", self.contentOffset.x, self.contentOffset.y);
    NSLog(@"Green:      %f, %f", (loc.x+self.contentOffset.x)/self.spriteToScroll.xScale, ((568-loc.y/self.spriteToScroll.yScale)+(568-(self.contentOffset.y/self.spriteToScroll.yScale))));
    
}

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        self.zPosition = 1.0;
        //Tap recognition

        
        self.userInteractionEnabled = true;
        [self setAnchorPoint:(CGPoint){0,1}];
        SKSpriteNode *spriteToScroll = [SKSpriteNode spriteNodeWithColor:[SKColor clearColor] size:size];
        [spriteToScroll setAnchorPoint:(CGPoint){0,1}];
        [spriteToScroll setZPosition:kIIMySceneZPositionScrolling];
        [self addChild:spriteToScroll];

        //Overlay sprite to make anchor point 0,0 (lower left, default for SK)
        SKSpriteNode *spriteForScrollingGeometry = [SKSpriteNode spriteNodeWithColor:[SKColor clearColor] size:size];
        [spriteForScrollingGeometry setAnchorPoint:(CGPoint){0,0}];
        [spriteForScrollingGeometry setPosition:(CGPoint){0, -size.height}];
        
        [spriteToScroll addChild:spriteForScrollingGeometry];

        SKSpriteNode *spriteForStaticGeometry = [SKSpriteNode spriteNodeWithColor:[SKColor clearColor] size:size];
        [spriteForStaticGeometry setAnchorPoint:(CGPoint){0,0}];
        [spriteForStaticGeometry setPosition:(CGPoint){0, -size.height}];
        [spriteForStaticGeometry setZPosition:kIIMySceneZPositionStatic];
        
        
        [self addChild:spriteForStaticGeometry];

        SKSpriteNode *spriteToHostHorizontalAndVerticalScrolling = [SKSpriteNode spriteNodeWithColor:[SKColor clearColor] size:size];
        [spriteToHostHorizontalAndVerticalScrolling setAnchorPoint:(CGPoint){0,0}];
        [spriteToHostHorizontalAndVerticalScrolling setPosition:(CGPoint){0, -size.height}];
        [spriteToHostHorizontalAndVerticalScrolling setZPosition:kIIMySceneZPositionVerticalAndHorizontalScrolling];
        [self addChild:spriteToHostHorizontalAndVerticalScrolling];

        CGSize upAndDownSize = size;
        upAndDownSize.width = 30;
        SKSpriteNode *spriteForVerticalScrolling = [SKSpriteNode spriteNodeWithColor:[SKColor clearColor] size:upAndDownSize];
        [spriteForVerticalScrolling setAnchorPoint:(CGPoint){0,0}];
        [spriteForVerticalScrolling setPosition:(CGPoint){0,30}];
        [spriteToHostHorizontalAndVerticalScrolling addChild:spriteForVerticalScrolling];

        CGSize leftToRightSize = size;
        leftToRightSize.height = 30;
        SKSpriteNode *spriteForHorizontalScrolling = [SKSpriteNode spriteNodeWithColor:[SKColor clearColor] size:leftToRightSize];
        [spriteForHorizontalScrolling setAnchorPoint:(CGPoint){0,0}];
        [spriteForHorizontalScrolling setPosition:(CGPoint){10,0}];
        [spriteToHostHorizontalAndVerticalScrolling addChild:spriteForHorizontalScrolling];

        //Test sprites for constrained Scrolling
        CGFloat labelPosition = -500.0;
        CGFloat stepSize = 50.0;
        while (labelPosition < 2000.0)
        {
            NSString *labelText = [NSString stringWithFormat:@"%5.0f", labelPosition];

            SKLabelNode *scrollingLabel = [SKLabelNode labelNodeWithFontNamed:@"HelveticaNeue"];
            [scrollingLabel setText:labelText];
            [scrollingLabel setFontSize:14.0];
            [scrollingLabel setFontColor:[SKColor darkGrayColor]];
            [scrollingLabel setPosition:(CGPoint){.x = 0.0, .y = labelPosition}];
            [scrollingLabel setHorizontalAlignmentMode:SKLabelHorizontalAlignmentModeLeft];
            [spriteForHorizontalScrolling addChild:scrollingLabel];

            scrollingLabel = [SKLabelNode labelNodeWithFontNamed:@"HelveticaNeue"];
            [scrollingLabel setText:labelText];
            [scrollingLabel setFontSize:14.0];
            [scrollingLabel setFontColor:[SKColor darkGrayColor]];
            [scrollingLabel setPosition:(CGPoint){.x = labelPosition, .y = 0.0}];
            [scrollingLabel setHorizontalAlignmentMode:SKLabelHorizontalAlignmentModeLeft];
            [scrollingLabel setZPosition:kIIMySceneZPositionVerticalAndHorizontalScrolling];
            [spriteForVerticalScrolling addChild:scrollingLabel];
            labelPosition += stepSize;
        }

        //Set properties
        self.backgroundColor = [UIColor whiteColor];
        _contentSize = size;
        _spriteToScroll = spriteToScroll;
        _spriteForScrollingGeometry = spriteForScrollingGeometry;
        _spriteForStaticGeometry = spriteForStaticGeometry;
        _spriteToHostHorizontalAndVerticalScrolling = spriteToHostHorizontalAndVerticalScrolling;
        _spriteForVerticalScrolling = spriteForVerticalScrolling;
        _spriteForHorizontalScrolling = spriteForHorizontalScrolling;
        _contentOffset = (CGPoint){0,0};
    }

    [self buildNodes];
    return self;
}



-(void)didChangeSize:(CGSize)oldSize
{
    CGSize size = [self size];

    CGPoint lowerLeft = (CGPoint){0, -size.height};

    [self.spriteForStaticGeometry setSize:size];
    [self.spriteForStaticGeometry setPosition:lowerLeft];

    [self.spriteToHostHorizontalAndVerticalScrolling setSize:size];
    [self.spriteToHostHorizontalAndVerticalScrolling setPosition:lowerLeft];
}

-(void)setContentSize:(CGSize)contentSize
{
    if (!CGSizeEqualToSize(contentSize, _contentSize))
    {
        _contentSize = contentSize;
        [self.spriteToScroll setSize:contentSize];
        [self.spriteForScrollingGeometry setSize:contentSize];
        [self.spriteForScrollingGeometry setPosition:(CGPoint){0, -contentSize.height}];
        [self updateConstrainedScrollerSize];
    }
}

-(void)setContentOffset:(CGPoint)contentOffset
{
    _contentOffset = contentOffset;
    contentOffset.x *= -1;
    [self.spriteToScroll setPosition:contentOffset];

    CGPoint scrollingLowerLeft = [self.spriteForScrollingGeometry convertPoint:(CGPoint){0,0} toNode:self.spriteToHostHorizontalAndVerticalScrolling];

    CGPoint horizontalScrollingPosition = [self.spriteForHorizontalScrolling position];
    horizontalScrollingPosition.y = scrollingLowerLeft.y;
    [self.spriteForHorizontalScrolling setPosition:horizontalScrollingPosition];

    CGPoint verticalScrollingPosition = [self.spriteForVerticalScrolling position];
    verticalScrollingPosition.x = scrollingLowerLeft.x;
    [self.spriteForVerticalScrolling setPosition:verticalScrollingPosition];
}

-(void)setContentScale:(CGFloat)scale;
{
    [self.spriteToScroll setScale:scale];
    [self updateConstrainedScrollerSize];
}

-(void)updateConstrainedScrollerSize
{

    CGSize contentSize = [self contentSize];
    CGSize verticalSpriteSize = [self.spriteForVerticalScrolling size];
    verticalSpriteSize.height = contentSize.height;
    [self.spriteForVerticalScrolling setSize:verticalSpriteSize];

    CGSize horizontalSpriteSize = [self.spriteForHorizontalScrolling size];
    horizontalSpriteSize.width = contentSize.width;
    [self.spriteForHorizontalScrolling setSize:horizontalSpriteSize];

    CGFloat xScale = [self.spriteToScroll xScale];
    CGFloat yScale = [self.spriteToScroll yScale];
    [self.spriteForVerticalScrolling setYScale:yScale];
    [self.spriteForVerticalScrolling setXScale:xScale];
    [self.spriteForHorizontalScrolling setXScale:xScale];
    [self.spriteForHorizontalScrolling setYScale:yScale];
    CGFloat xScaleReciprocal = 1.0/xScale;
    CGFloat yScaleReciprocal = 1/yScale;
    for (SKNode *node in [self.spriteForVerticalScrolling children])
    {
        [node setXScale:xScaleReciprocal];
        [node setYScale:yScaleReciprocal];
    }
    for (SKNode *node in [self.spriteForHorizontalScrolling children])
    {
        [node setXScale:xScaleReciprocal];
        [node setYScale:yScaleReciprocal];
    }

    [self setContentOffset:self.contentOffset];
}

-(void)update:(CFTimeInterval)currentTime {
    //Run update if the scene is not yet complete
    if (!sceneComplete){
    
    //Run the simulation, and update the relative rect for every node
        
    
    for (Node *node in self.drawNodes) {
        [node runForces];
        //The relative point for the node
        CGPoint point = [self.spriteForScrollingGeometry convertPoint:node.position toNode:self];
        point.y = -point.y;
        
        CGRect rect = CGRectMake(point.x, point.y, node.frame.size.width*self.spriteForScrollingGeometry.xScale, node.frame.size.height*self.spriteForScrollingGeometry.yScale);
        
        
        //Have to reverse the Y coordinate of the artist. Why? I'm not sure.
        
        node.relativePosition = point;
        node.relativeRect = rect;
    }
    //Draw the edge paths every frame
    for (EdgeNode *edgeNode in self.edgeNodes) {
        [edgeNode updateEdgePath];
    }
        NSLog(@"Energy: %f", self.totalEnergy);

    
    //Once the system has reached energy < 75, allow the nodes to collide to straighten them out further
        
    if (!changedCollision && self.totalEnergy < MIN_ENERGY * 1.3){
        for (Node *node in self.drawNodes) {
            node.physicsBody.collisionBitMask = 1;
            changedCollision = true;
            NSLog(@"Changed collision!");
        }
    }
    //Once the system has reached an energy < 50, consider it complete and halt simulation
        
    if (changedCollision && self.totalEnergy < MIN_ENERGY)
        sceneComplete = true;
        
    //Reset the total energy on each update
    self.totalEnergy = 0.0f;
    }

}
@end
