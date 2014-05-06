//
//  ViewController.m
//  SizzleLogin
//
//  Created by maksa on 5/5/14.
//  Copyright (c) 2014 GlobalView. All rights reserved.
//

#import "SizzleLoginViewController.h"
#define DURATION 3.0
#define TIMING_FUNCTION kCAMediaTimingFunctionDefault

@interface SizzleLoginViewController ()

@end

@implementation SizzleLoginViewController

-(void)createImageLayer {
	UIImage*    backgroundImage = [UIImage imageNamed:@"spiderman"];
	self.imageLayer = [CALayer layer];
	CGFloat nativeWidth = CGImageGetWidth(backgroundImage.CGImage);
	CGFloat nativeHeight = CGImageGetHeight(backgroundImage.CGImage);
	CGRect  startFrame = CGRectMake(-500, -200, nativeWidth, nativeHeight);
	self.imageLayer.contents = (id)backgroundImage.CGImage;
	self.imageLayer.frame = startFrame;
	self.imageLayer.zPosition = -1;
	[self.sizzleView.layer addSublayer:self.imageLayer ];
}

-(void)createChartLayer {
	self.shapeLayer = [ CAShapeLayer layer];
	self.shapeLayer.strokeColor = [ UIColor cyanColor ].CGColor;
	self.shapeLayer.fillColor = [ UIColor clearColor ].CGColor;
	self.shapeLayer.lineWidth = 4.0;
//	CGMutablePathRef path = CGPathCreateMutable();
//	CGPathMoveToPoint(path, NULL, 0, 0);
	
	self.shapeLayer.zPosition = -1;
	
	//self.shapeLayer.path = [ self makeNewPath ];
//	self.shapeLayer.path = path;
	
	[self.sizzleView.layer addSublayer:self.shapeLayer];

}

- (void)viewDidLoad
{
	[ self createImageLayer ];
	[ self createChartLayer ];

	[super viewDidLoad];

}

-(void)viewDidAppear:(BOOL)animated {
	[ super viewDidAppear:animated];
	[ self performSelector:@selector(animateStuff) withObject:nil afterDelay:0.3];

	NSLog(@"%@",[self.view.layer.sublayers valueForKeyPath:@"zPosition"]);
	
	self.centerX.constant-=400;
}

-(void)animateStuff {

	CABasicAnimation* move = [ CABasicAnimation animationWithKeyPath:@"position"];
	move.duration = DURATION;
	move.autoreverses = NO;
	move.repeatCount = 0;
	move.removedOnCompletion = NO;
	move.fillMode = kCAFillModeForwards;
	move.timingFunction = [CAMediaTimingFunction functionWithName:TIMING_FUNCTION];
	move.delegate = self;
	CGPoint newPosition = CGPointMake(self.imageLayer.position.x - 200, self.imageLayer.position.y + 200 );
	
	move.toValue = [ NSValue valueWithCGPoint:newPosition];

	[self.imageLayer addAnimation:move forKey:@"pan"]
	;

	
	CABasicAnimation *line = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
	
	line.duration = DURATION;
	line.timingFunction = [CAMediaTimingFunction functionWithName:TIMING_FUNCTION];
	line.fromValue = @(0.0);
	line.toValue = @(1.0);
	self.shapeLayer.path = [ self makeNewPath ];
	
	[self.shapeLayer addAnimation:line forKey:@"animatePath"];

	CABasicAnimation* moveLine = [ CABasicAnimation animationWithKeyPath:@"position"];
	moveLine.duration = DURATION;
	moveLine.autoreverses = NO;
	moveLine.repeatCount = 0;
	moveLine.removedOnCompletion = NO;
	moveLine.timingFunction = [CAMediaTimingFunction functionWithName:TIMING_FUNCTION];
	moveLine.fillMode = kCAFillModeForwards;
	newPosition = CGPointMake(self.shapeLayer.position.x - 200, self.shapeLayer.position.y + 200 );
	moveLine.toValue = [ NSValue valueWithCGPoint:newPosition];
	
	[self.shapeLayer addAnimation:moveLine forKey:@"moveline"];
	
	[self slideInLoginControls ];
}



-(void)slideInLoginControls {
	self.centerX.constant = 0;
	[ UIView animateWithDuration:DURATION/3.0*2 animations:^{
		[self.view layoutIfNeeded];
	}];
}

-(void)fadeOutChart {
	CABasicAnimation* fadeout = [ CABasicAnimation animationWithKeyPath:@"opacity"];
	fadeout.duration = 1.0;
	fadeout.autoreverses = NO;
	fadeout.repeatCount = 0;
	fadeout.removedOnCompletion = NO;
	fadeout.fillMode = kCAFillModeForwards;
	fadeout.timingFunction = [CAMediaTimingFunction functionWithName:TIMING_FUNCTION];
	fadeout.fromValue = @(1.0);
	fadeout.toValue = @(0.0);
	[self.shapeLayer addAnimation:fadeout forKey:@"fadeout"];
}

-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
	CABasicAnimation* a = (CABasicAnimation*)anim;
	if( a == [self.imageLayer animationForKey:@"pan"]) {
		self.imageLayer.position = [a.toValue CGPointValue];
	}
	
	UIInterpolatingMotionEffect *horizontalMotionEffect = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.x" type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
	
	horizontalMotionEffect.minimumRelativeValue = @(-100);
	
	horizontalMotionEffect.maximumRelativeValue = @(100);
	[self fadeOutChart ];
	[self.sizzleView addMotionEffect:horizontalMotionEffect];
	
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(CGMutablePathRef)makeNewPath {
	CGMutablePathRef newPath = CGPathCreateMutable();
	CGPathMoveToPoint(newPath, NULL, 0, 0);
	
	for( int i = 0; i < 100; ++i ) {
		int signrand = arc4random_uniform(2);
		int sign;
		if( signrand == 0 ) {
			sign = -1;
		} else {
			sign = 1;
		}
		CGPathAddLineToPoint(newPath, nil, i * 5, 150 + (arc4random_uniform(30)+1) * sign - i  );
	}
	
	return newPath;
}

@end
