//
//  Interactor.m
//  CustomTransitions
//
//  Created by Brexton Pham on 7/1/15.
//  Copyright (c) 2015 Brexton Pham. All rights reserved.
//

#import "Interactor.h"

@interface Interactor ()

@property (nonatomic, strong) id <UIViewControllerContextTransitioning> transitionContext;

@end

@implementation Interactor

- (void)startInteractiveTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    self.transitionContext = transitionContext;
    self.modalExpandedFrame = [transitionContext containerView].bounds;
}

- (void)updateInteractiveTransition:(CGFloat)percentComplete {
    CGFloat xOriginDelta = self.modalExpandedFrame.origin.x - self.modalCollapsedFrame.origin.x;
    CGFloat yOriginDelta = self.modalExpandedFrame.origin.y - self.modalCollapsedFrame.origin.y;
    CGFloat xWidthDelta = self.modalExpandedFrame.size.width - self.modalCollapsedFrame.size.width;
    CGFloat yHeightDelta = self.modalExpandedFrame.size.height - self.modalCollapsedFrame.size.height;
    
    CGFloat transitionX = self.modalCollapsedFrame.origin.x + (xOriginDelta * percentComplete);
    CGFloat transitionY = self.modalCollapsedFrame.origin.y + (yOriginDelta * percentComplete);
    CGFloat transitionWidth = self.modalCollapsedFrame.size.width + (xWidthDelta * percentComplete);
    CGFloat transitionHeight = self.modalCollapsedFrame.size.height + (yHeightDelta *percentComplete);
    
    UIView *fromView = [self.transitionContext viewForKey:UITransitionContextFromViewKey];
    fromView.frame = CGRectMake(transitionX, transitionY, transitionWidth, transitionHeight);
}

- (void)cancelInteractiveTransition {
    UIView *fromView = [self.transitionContext viewForKey:UITransitionContextFromViewKey];
    [self animateWithModalView:fromView destinationFrame:self.modalExpandedFrame didComplete:NO];
}

- (void)finishInteractiveTransition {
    UIView *fromView = [self.transitionContext viewForKey:UITransitionContextFromViewKey];
    [self animateWithModalView:fromView destinationFrame:self.modalCollapsedFrame didComplete:YES];
}

// tell modal controller that self is transitioning delegate
- (id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    return self;
}

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    return self;
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 0.5;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    self.transitionContext = transitionContext;
    
    UIView *fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
    UIView *toView = [transitionContext viewForKey:UITransitionContextToViewKey];
    
    self.modalExpandedFrame = [transitionContext containerView].bounds;
    
    UIView *modalView;
    CGRect destinationFrame;
    
    if (self.isPresenting) {
        modalView = toView;
        destinationFrame = self.modalExpandedFrame;
        [[transitionContext containerView] addSubview:toView];
        toView.frame = self.modalCollapsedFrame;
        [toView layoutIfNeeded];
    } else {
        modalView = fromView;
        destinationFrame = self.modalCollapsedFrame;
    }
    
    [self animateWithModalView:modalView destinationFrame:destinationFrame didComplete:YES];
}

- (void)animateWithModalView:(UIView *)view destinationFrame:(CGRect)destinationFrame didComplete:(BOOL)didComplete {
    [UIView animateWithDuration:[self transitionDuration:self.transitionContext] delay:0 usingSpringWithDamping:1 initialSpringVelocity:1 options:0 animations:^{
        view.frame = destinationFrame;
        [view layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self.transitionContext completeTransition:didComplete];
    }];
}

- (id <UIViewControllerInteractiveTransitioning>)interactionControllerForPresentation:(id<UIViewControllerAnimatedTransitioning>)animator {
    return self.isInteractive ? self : nil;
}

- (id <UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id<UIViewControllerAnimatedTransitioning>)animator {
    return self.isInteractive ? self : nil;
}

- (void)animationEnded:(BOOL)transitionCompleted {
    self.isInteractive = NO;
    self.isPresenting = NO;
}


@end
