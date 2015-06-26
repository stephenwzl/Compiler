//
//  Tree.h
//  Compiler
//
//  Created by 王志龙 on 15/6/23.
//  Copyright (c) 2015年 wangzhilong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "mapExpr.h"
@interface Tree : NSObject
@property (strong, nonatomic) NSMutableArray *treeNode;
@property (strong, nonatomic) NSMutableArray *cs;   //Circle
@property (strong, nonatomic) NSMutableArray *ls;   //Line
@property (strong, nonatomic) NSMutableArray *vdraw; //Vector

- (instancetype)initWithMap:(NSMutableArray *)mp;
@end
