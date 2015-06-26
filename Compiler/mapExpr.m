//
//  mapExpr.m
//  Compiler
//
//  Created by 王志龙 on 15/6/23.
//  Copyright (c) 2015年 wangzhilong. All rights reserved.
//

#import "mapExpr.h"

@implementation mapExpr

- (instancetype)init {
    self = [super init];
    if (self) {
        self.qstart = 0;
        self.letter = ' ';
        self.qend = 0;
    }
    return self;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"%ld,%c,%ld",self.qstart,self.letter,self.qend];
}
@end
