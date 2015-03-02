//
//  GameViewController.h
//  SceneKit-Directed-Graph
//

//  Copyright (c) 2015 Joe Crozier. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SceneKit/SceneKit.h>
#import <SpriteKit/SpriteKit.h>
#import "ScrollScene.h"

@interface MainViewController : UIViewController <UIScrollViewDelegate> {
    UIView *scrollCanvas;
    IBOutlet UIButton *buildSceneButton;
}
@property(nonatomic, retain)ScrollScene *scene;
@property(nonatomic, weak)UIView *clearContentView;

@end
