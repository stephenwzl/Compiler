//
//  TreeNode.m
//  Compiler
//
//  Created by 王志龙 on 15/6/23.
//  Copyright (c) 2015年 wangzhilong. All rights reserved.
//

#import "TreeNode.h"

@implementation TreeNode

- (NSString *)description {
    return [NSString stringWithFormat:@"%ld,%c,%ld",(long)self.s,self.ch,(long)self.e];
}
@end
