//
//  ViewController.m
//  stylo
//
//  Created by Ari Fiorino on 12/15/14.
//  Copyright (c) 2014 Azul Engineering. All rights reserved.
//

#import "ViewController.h"
@interface circle()
@end
@implementation circle
-(void) startWithView:(UIView*) view withRadius:(float)Radius center:(CGPoint)Center{
    center=Center;
    radius=Radius;
    if (radius<minPenRadius){
        radius=minPenRadius;
    }
    imageView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, radius*2, radius*2)];
    [imageView setCenter:center];
    [imageView setBackgroundColor:[UIColor blackColor]];
    [imageView.layer setCornerRadius:radius];
    [view addSubview:imageView];
}
-(void) dissapear{
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:circlesDissapearTime];
    [imageView setFrame:CGRectMake(imageView.center.x, imageView.center.y, 0, 0)];
    [UIView commitAnimations];
}
-(UIImageView *) returnImageView{
    return imageView;
}
-(CGPoint) returnCenter{
    return center;
}
-(float) returnRadius{
    return radius;
}
-(float) distanceTo:(CGPoint)point{
    return sqrtf(powf(center.x-point.x,2)+powf(center.y-point.y,2));
}


@end

@interface ViewController ()
@end

@implementation ViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    maxPenRadius=7;
    minPenRadius=2;
    circlesDissapearTime=.5;
    circles=[[NSMutableArray alloc] init];
    strokeIndexes=[[NSMutableArray alloc] init];

    // Do any additional setup after loading the view, typically from a nib.
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void) touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event {
    maxPenRadius=sizeSlider.value;
    [strokeIndexes addObject:[NSNumber numberWithInt:[circles count]]];
    [circles addObject:[circle alloc] ];
    [[circles lastObject] startWithView:viewWithCircles withRadius:maxPenRadius center:[[touches anyObject] locationInView:viewWithCircles]];
}
- (void) touchesMoved:(NSSet*)touches withEvent:(UIEvent*)event {
    maxPenRadius=sizeSlider.value;
    CGPoint touch=[[touches anyObject] locationInView:viewWithCircles];
    [circles addObject:[circle alloc] ];
    [[circles lastObject] startWithView:viewWithCircles withRadius:maxPenRadius-([[circles objectAtIndex:[circles count]-2] distanceTo:touch]/4) center:touch];
    [self drawBetween:[circles objectAtIndex:[circles count]-2] and:[circles lastObject]];
}
- (void) touchesEnded:(NSSet*)touches withEvent:(UIEvent*)event {
    
}
-(void) drawBetween:(circle*)circle1 and:(circle*)circle2{
    float rate=1;
    
    CGPoint circle1Center, circle2Center;
    float distance=[circle1 distanceTo:[circle2 returnCenter]];
    if (distance>rate){
        circle1Center=[circle1 returnCenter];
        circle2Center=[circle2 returnCenter];
        for (float i=0; i<distance; i+=rate) {
            CGPoint newCenter=CGPointMake(circle1Center.x+((circle2Center.x-circle1Center.x)*(i/distance)), circle1Center.y+((circle2Center.y-circle1Center.y)*(i/distance)));
            float newRadius=[circle1 returnRadius]+([circle2 returnRadius]-[circle1 returnRadius])*(i/distance);
            
            [circles addObject:[circle alloc] ];
            [[circles lastObject] startWithView:viewWithCircles withRadius:newRadius center:newCenter];
        }
    }
}
-(void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator{
    
    [clearButton setCenter:CGPointMake(size.width*.25, clearButton.center.y)];
    [undoButton setCenter:CGPointMake(size.width*.75, undoButton.center.y)];
    [sizeSlider setCenter:CGPointMake(size.width/2, size.height-sizeSlider.frame.size.height)];
}
-(IBAction) clear:(id)sender{
    for (circle *Circle in circles){
        [Circle dissapear];
    }
    [NSTimer scheduledTimerWithTimeInterval:(circlesDissapearTime) target:self selector:@selector(deleteAllCircles) userInfo:nil repeats:NO];
}
-(IBAction) undo:(id)sender{
    for (int i=[[strokeIndexes lastObject] integerValue]; i<[circles count]; i++) {
        [[circles objectAtIndex:i] dissapear];
    }
    [NSTimer scheduledTimerWithTimeInterval:(circlesDissapearTime) target:self selector:@selector(deleteLastStroke) userInfo:nil repeats:NO];
}
-(void) deleteAllCircles{
    for (circle* Circle in circles){
        [[Circle returnImageView] removeFromSuperview];
    }
    [circles removeAllObjects];
    [strokeIndexes removeAllObjects];
}
-(void) deleteLastStroke{
    for (int i=[[strokeIndexes lastObject] integerValue]; i<[circles count]; i++) {
        [[[circles objectAtIndex:i] returnImageView] removeFromSuperview];
        [circles removeObjectAtIndex:[[strokeIndexes lastObject] integerValue]];
    }
    [strokeIndexes removeLastObject];
}
@end
