//
//  Node.m
//  Compiler
//
//  Created by 王志龙 on 15/6/24.
//  Copyright (c) 2015年 wangzhilong. All rights reserved.
//

#import "Node.h"

@implementation Node

- (instancetype)init {
    self = [super init];
    if (self) {
        self.edge = '^';
        self.accept = NO;
        self.next = nil;
        self.next2 = nil;
    }
    return self;
}
@end
