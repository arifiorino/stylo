//
//  ViewController.h
//  stylo
//
//  Created by Ari Fiorino on 12/15/14.
//  Copyright (c) 2014 Azul Engineering. All rights reserved.
//

#import <UIKit/UIKit.h>
float maxPenRadius, minPenRadius, circlesDissapearTime;
@interface circle : NSObject{
    float radius;
    CGPoint center;
    UIImageView *imageView;
}
-(float) distanceTo:(CGPoint)point;
-(void) startWithView:(UIView*) view withRadius:(float)Radius center:(CGPoint)Center;
-(void) dissapear;
-(UIImageView *) returnImageView;
-(CGPoint) returnCenter;
-(float) returnRadius;
@end

@interface ViewController : UIViewController{
    IBOutlet UIView *viewWithCircles;
    IBOutlet UIButton *clearButton;
    IBOutlet UIButton *undoButton;
    IBOutlet UISlider *sizeSlider;
    NSMutableArray* circles;
    NSMutableArray* strokeIndexes;
}

-(void) drawBetween:(circle*)circle1 and:(circle*)circle2;
-(IBAction) clear:(id)sender;
-(IBAction) undo:(id)sender;
-(void) deleteAllCircles;
-(void) deleteLastStroke;

@end

