//
//  Stack.m
//  Compiler
//
//  Created by 王志龙 on 15/6/25.
//  Copyright (c) 2015年 wangzhilong. All rights reserved.
//

#import "Stack.h"
@interface Stack()
@property (strong, nonatomic) NSMutableArray *stack;
@end
@implementation Stack

- (instancetype)init {
    self = [super init];
    if (self) {
        self.stack = [[NSMutableArray alloc] init];
    }
    
    return self;
}

- (void)push:(NSInteger)obj {
    NSNumber *num = [NSNumber numberWithInteger:obj];
    [self.stack addObject:num];
}

- (NSInteger)pop {
    NSInteger count = self.stack.count;
    NSNumber *num = self.stack[count -1];
    [self.stack removeObjectAtIndex:count - 1];
    return num.integerValue;
}

- (void)pushArray:(NSMutableArray *)obj {
    [self.stack addObject:obj];
}

- (NSMutableArray *)popArray {
    NSInteger count = self.stack.count;
    NSMutableArray *array = self.stack[count - 1];
    [self.stack removeObjectAtIndex:count - 1];
    return array;
}
- (BOOL)isEmpty {
    if (self.stack.count == 0) {
        return YES;
    }
    return NO;
}

- (BOOL)search:(NSInteger)obj {
    NSNumber *num = [NSNumber numberWithInteger:obj];
    if ([self.stack indexOfObject:num] == NSNotFound) {
        return NO;
    }
    return YES;
}

- (BOOL)searchArray:(NSMutableArray *)obj {
    if ([self.stack indexOfObject:obj] == NSNotFound) {
        return NO;
    }
    return YES;
}
@end
