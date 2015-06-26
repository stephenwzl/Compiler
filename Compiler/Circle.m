//
//  Circle.m
//  Compiler
//
//  Created by 王志龙 on 15/6/23.
//  Copyright (c) 2015年 wangzhilong. All rights reserved.
//

#import "Circle.h"

@implementation Circle

- (instancetype)initWithString:(NSString *)str px:(NSInteger)px py:(NSInteger)py {
    self = [super init];
    if (self) {
        self.index = str;
        self.x = px;
        self.y = py;

    }
    return self;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"%@,x:%ld,y:%ld",self.index,self.x,self.y];
}
@end
