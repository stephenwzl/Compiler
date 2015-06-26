//
//  TreeCanvas.h
//  Compiler
//
//  Created by 王志龙 on 15/6/24.
//  Copyright (c) 2015年 wangzhilong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIkit.h>
#import "Circle.h"
#import "Line.h"
#import "mapExpr.h"
@interface TreeCanvas : UIView
@property (assign, nonatomic) BOOL update;
@property (strong, nonatomic) NSMutableArray *cs;
@property (strong, nonatomic) NSMutableArray *ls;

- (void)clear;
- (instancetype)initWithnewTree:(NSMutableArray *)mapExpr Interger:(NSMutableArray *)n;
- (void)newTree:(NSMutableArray *)mapExpr Integer:(NSMutableArray *) n;
@end
