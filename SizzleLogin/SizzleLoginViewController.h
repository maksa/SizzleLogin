//
//  ViewController.h
//  SizzleLogin
//
//  Created by maksa on 5/5/14.
//  Copyright (c) 2014 GlobalView. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SizzleLoginViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIView *loginControls;
@property (nonatomic, strong) CALayer* imageLayer;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *centerX;
@property (weak, nonatomic) IBOutlet UIView *otherView;
@property (nonatomic, strong) CAShapeLayer* shapeLayer;
@property (weak, nonatomic) IBOutlet UIView *sizzleView;
@end
