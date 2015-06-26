//
//  FAViewController.m
//  Compiler
//
//  Created by 王志龙 on 15/6/23.
//  Copyright (c) 2015年 wangzhilong. All rights reserved.
//

#import "FAViewController.h"
#import "NFA.h"
#import "mapExpr.h"
#import "DFA.h"
#import "TreeCanvas.h"
@interface FAViewController () <UIPickerViewDataSource,UIPickerViewDelegate>
@property (weak, nonatomic) IBOutlet UITextField *txtZ;
@property (strong, nonatomic) NSArray *pickerArray;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *pickerViewConstrant;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;
@property (weak, nonatomic) IBOutlet UIButton *selectFA;
@property (weak, nonatomic) IBOutlet TreeCanvas *grapView;
@property (weak, nonatomic) IBOutlet UITextView *outView;
@end

@implementation FAViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _pickerArray = @[@"NFA",@"DFA",@"MiniDFA"];
    self.pickerView.delegate = self;
    self.pickerView.dataSource = self;

    //(screen size 1024 * 768)
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

//select FA type
- (IBAction)selectFA:(id)sender {
    [self popPickerView];
}

//generate graphics
- (IBAction)generate:(id)sender {
    [self pushPickerView];
    [self.txtZ resignFirstResponder];
    NSString *input = self.txtZ.text;
    NFA *nfa = [[NFA alloc] initWithString:input];
    NSMutableArray *mp = [nfa getResult];
    [self printMp:mp end:[nfa getMapEnd]];
    TreeCanvas *canvas = [[TreeCanvas alloc] initWithnewTree:mp Interger:[nfa getMapEnd]];
    [self drawPicture:canvas];
}
- (IBAction)completePick:(id)sender {
    [self pushPickerView];
}

- (void)popPickerView {
    __weak FAViewController *wself = self;
    self.pickerViewConstrant.constant = 0;
    [UIView animateWithDuration:0.5 animations:^{
        [wself.view layoutIfNeeded];
    }];
    
}

- (void)pushPickerView {
    NSInteger row = [self.pickerView selectedRowInComponent:0];
    [self.selectFA setTitle:_pickerArray[row] forState:UIControlStateNormal];
    
    self.pickerViewConstrant.constant = - 320;
    __weak FAViewController *wself = self;
    [UIView animateWithDuration:0.5 animations:^{
        [wself.view layoutIfNeeded];
    }];
}

- (void)drawPicture:(UIView *)view {
    [self removeView:[self.grapView subviews]];
    view.backgroundColor = [UIColor whiteColor];
    view.translatesAutoresizingMaskIntoConstraints = NO;
    [self.grapView addSubview:view];
    NSArray *constrains = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[view]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(view,self.grapView)];
    NSArray *constrains2 = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[view]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(view,self.grapView)];
    [self.grapView addConstraints:constrains];
    [self.grapView addConstraints:constrains2];
}

- (void)removeView:(NSArray *)views {
    for (UIView *view in views) {
        [view removeFromSuperview];
    }
}
#pragma pickerViewDelegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.pickerArray.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return self.pickerArray[row];
}

- (void)printMp:(NSMutableArray *)mp end:(NSMutableArray *)end {
    NSMutableArray *list = [[NSMutableArray alloc] init];
    for (int i = 0; i < mp.count; ++i) {
        mapExpr *m = mp[i];
        NSString *string = [NSString stringWithFormat:@"(%ld,%c)-->%ld",m.qstart,m.letter,m.qend];
        [list addObject:string];
    }
    NSMutableString *display = [[NSMutableString alloc] init];
    for (int i = 0; i < list.count; ++i) {
        [display appendString:[NSString stringWithFormat:@"%@\n",list[i]]];
    }
    self.outView.text = display;
}
@end
