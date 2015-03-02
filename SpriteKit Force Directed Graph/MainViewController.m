//
//  GameViewController.m
//  SceneKit-Directed-Graph
//
//  Created by Joe Crozier on 2015-01-30.
//  Copyright (c) 2015 Joe Crozier. All rights reserved.
//

#import "MainViewController.h"


static NSString * kViewTransformChanged = @"view transform changed";

@implementation SKScene (Unarchive)

+ (instancetype)unarchiveFromFile:(NSString *)file {
    /* Retrieve scene file path from the application bundle */
    NSString *nodePath = [[NSBundle mainBundle] pathForResource:file ofType:@"sks"];
    /* Unarchive the file to an SKScene object */
    NSData *data = [NSData dataWithContentsOfFile:nodePath
                                          options:NSDataReadingMappedIfSafe
                                            error:nil];
    NSKeyedUnarchiver *arch = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
    [arch setClass:self forClassName:@"SKScene"];
    SKScene *scene = [arch decodeObjectForKey:NSKeyedArchiveRootObjectKey];
    [arch finishDecoding];
    
    return scene;
}

@end

@implementation MainViewController

- (void)viewWillLayoutSubviews

{
    
    [super viewDidLoad];
    
}

- (IBAction)buildScene:(id)sender{
    
    buildSceneButton.removeFromSuperview;
    [buildSceneButton removeFromSuperview];
    
    //Build a view to contain our game scene
    SKView *skView = (SKView *)self.view;
    //    skView.userInteractionEnabled = true;
    skView.showsFPS = true;
    skView.showsNodeCount = true;
    
    ScrollScene *scene = [ScrollScene sceneWithSize:skView.bounds.size];
    //    scene.userInteractionEnabled = true;
    scene.scaleMode = SKSceneScaleModeFill;
    scene.delegateViewController = self;
    
    [skView presentScene:scene];
    _scene = scene;
    
    CGSize contentSize = skView.frame.size;
    contentSize.height *= 2.0;
    contentSize.width *= 2.0;
    [scene setContentSize:contentSize];
    
    [scene drawNodes];
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:skView.frame];
    [scrollView setContentSize:contentSize];
    
    scrollView.delegate = self;
    [scrollView setMinimumZoomScale:0.2];
    [scrollView setMaximumZoomScale:3.0];
    [scrollView setIndicatorStyle:UIScrollViewIndicatorStyleWhite];
    UIView *clearContentView = [[UIView alloc] initWithFrame:(CGRect){.origin = CGPointZero, .size = contentSize}];
    [clearContentView setBackgroundColor:[UIColor clearColor]];
    [scrollView addSubview:clearContentView];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self.scene action:@selector(tapReceived:)];
    [tapGestureRecognizer setDelegate:self.scene];
    [self.scene.view addGestureRecognizer:tapGestureRecognizer];
    
    _clearContentView = clearContentView;
    
    [clearContentView addObserver:self
                       forKeyPath:@"transform"
                          options:NSKeyValueObservingOptionNew
                          context:&kViewTransformChanged];
    [skView addSubview:scrollView];
    
}

-(void)adjustContent:(UIScrollView *)scrollView
{
    CGFloat zoomScale = [scrollView zoomScale];
    [self.scene setContentScale:zoomScale];
    CGPoint contentOffset = [scrollView contentOffset];
    [self.scene setContentOffset:contentOffset];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self adjustContent:scrollView];
}

-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.clearContentView;
}

-(void)scrollViewDidTransform:(UIScrollView *)scrollView
{
    [self adjustContent:scrollView];
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    NSLog(@"Touches began");
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale; // scale between minimum and maximum. called after any 'bounce' animations
{
    [self adjustContent:scrollView];
}
#pragma mark - KVO

-(void)observeValueForKeyPath:(NSString *)keyPath
                     ofObject:(id)object
                       change:(NSDictionary *)change
                      context:(void *)context
{
    if (context == &kViewTransformChanged)
    {
        [self scrollViewDidTransform:(id)[(UIView *)object superview]];
    }
    else
    {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

-(void)dealloc
{
    @try {
        [self.clearContentView removeObserver:self forKeyPath:@"transform"];
    }
    @catch (NSException *exception) {    }
    @finally {    }
}


- (BOOL)shouldAutorotate
{
    return YES;
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    } else {
        return UIInterfaceOrientationMaskAll;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

@end
