//
//  Interactor.h
//  CustomTransitions
//
//  Created by Brexton Pham on 7/1/15.
//  Copyright (c) 2015 Brexton Pham. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Interactor : UIPercentDrivenInteractiveTransition <UIViewControllerTransitioningDelegate, UIViewControllerAnimatedTransitioning>

@property (nonatomic, assign) CGRect modalCollapsedFrame;
@property (nonatomic, assign) CGRect modalExpandedFrame;
@property (nonatomic, assign) BOOL isPresenting;
@property (nonatomic, assign) BOOL isInteractive;

@end
