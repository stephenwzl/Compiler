//
//  Line.m
//  Compiler
//
//  Created by 王志龙 on 15/6/23.
//  Copyright (c) 2015年 wangzhilong. All rights reserved.
//

#import "Line.h"

@implementation Line

- (instancetype)initWithString:(NSString *)str start:(NSInteger)s end:(NSInteger)e type:(NSInteger)t {
    self = [super init];
    if (self) {
        self.content = str;
        self.start = s;
        self.end = e;
        self.type = t;
    }
    return self;
}

typedef NS_ENUM(NSInteger, LineType){
    LINE = 1,
    CIRCLE = 2,
    OVAL = 3
};

- (NSString *)description {
    return [NSString stringWithFormat:@"%@,%ld,%ld,%ld",self.content,(long)self.start,(long)self.end,(long)self.type];
}
@end
