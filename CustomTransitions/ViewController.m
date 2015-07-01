//
//  ViewController.m
//  CustomTransitions
//
//  Created by Brexton Pham on 7/1/15.
//  Copyright (c) 2015 Brexton Pham. All rights reserved.
//

#import "ViewController.h"
#import "CustomModalViewController.h"
#import "Interactor.h"

@interface ViewController () <UIViewControllerTransitioningDelegate, UIViewControllerAnimatedTransitioning>

@property (nonatomic, strong) Interactor *interactor;

@property (nonatomic, strong) UIButton *button;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button addTarget:self action:@selector(presentModal:) forControlEvents:UIControlEventTouchUpInside];
    [button setImage:[UIImage imageNamed:@"mabelFlip.jpg"] forState:UIControlStateNormal];
    button.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:button];
    self.button = button;
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[button(150)]-(30)-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(button)]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(30)-[button(150)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(button)]];
    
    self.interactor = [Interactor new];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    if (self.interactor && self.button) {
        self.interactor.modalCollapsedFrame = self.button.frame;
    }
}

- (void)presentModal:(UIButton *)sender {
    CustomModalViewController *modalViewController = [[CustomModalViewController alloc]initWithInteractor:self.interactor];
    modalViewController.modalPresentationStyle = UIModalPresentationCustom;
    modalViewController.transitioningDelegate = self.interactor;
    self.interactor.isPresenting = YES;
    self.interactor.modalCollapsedFrame = sender.frame;
    [self presentViewController:modalViewController animated:YES completion:^{
        self.interactor.isPresenting = NO;
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
