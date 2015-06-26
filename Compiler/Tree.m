//
//  Tree.m
//  Compiler
//
//  Created by 王志龙 on 15/6/23.
//  Copyright (c) 2015年 wangzhilong. All rights reserved.
//

#import "Tree.h"
#import "TreeNode.h"
#import "Circle.h"
#import "Line.h"
@implementation Tree

- (instancetype)initWithMap:(NSMutableArray *)mp {
    self = [super init];
    if (self) {
        self.treeNode = [[NSMutableArray alloc] initWithCapacity:mp.count];
        for (int i = 0; i < mp.count; ++i) {
            TreeNode *t = [[TreeNode alloc] init];
            mapExpr *map = mp[i];
            t.s = map.qstart;
            t.ch = map.letter;
            t.e = map.qend;
//            [self.treeNode replaceObjectAtIndex:i withObject:t];
//            if (self.treeNode.count == 0) {
//                [self.treeNode addObject:t];
//            }else
            [self.treeNode addObject:t];
        }
        NSLog(@"%@",self.treeNode);
        self.vdraw = [[NSMutableArray alloc] init];
        [self settree];
    }
    return self;
}

- (void)settree {
    [self createCircle];
    [self createLine];
}

- (void)createCircle {
    int x = 0;
    int y = 100;
    NSMutableArray *start;
    NSMutableArray *v = [[NSMutableArray alloc] init];
    Circle *c;
    start = [[NSMutableArray alloc] initWithCapacity:1];
//    [set replaceObjectAtIndex:0 withObject:[NSNumber numberWithInteger:-1]];
    [start addObject:[NSNumber numberWithInteger:-1]];
    NSInteger cn = [self circleCount];
    while (v.count != cn) {
        start = [self getalls:start];
        x += 100;
        for (int i = 0; i < start.count; ++ i) {
            NSNumber *obj = start[i];
            c = [[Circle alloc] initWithString:[obj stringValue] px:x py:y];
            [v addObject:c];
            [self.vdraw addObject:obj];
            y += 100;
        }
        y = 100;
    }
    self.cs = [NSMutableArray arrayWithArray:v];
    
}


- (void)createLine {
    Line *l;
    NSString *content;
    int type;
    NSMutableArray *v = [[NSMutableArray alloc] init];
    for (int i = 0; i < self.cs.count; ++i) {
        NSLog(@"%@",self.cs[i]);
        for (int j = 0; j < self.cs.count; ++j) {
            Circle *c1 = self.cs[i];
            Circle *c2 = self.cs[j];
            content = [self getcode:c1 Circle2:c2];
            if (![content isEqualToString:@""]) {
                if (i == j) {
                    type = 3;
                }else if (![[self getcode:c2 Circle2:c1] isEqualToString:@""] || (c1.x == c2.x)){
                    type = 2;
                }else{
                    type = 1;
                }
                l = [[Line alloc] initWithString:content start:i end:j type:type];
                [v addObject:l];
            }
        }
    }
    self.ls = [NSMutableArray arrayWithArray:v];
}


- (NSString *)getcode:(Circle *)c1 Circle2:(Circle *)c2 {
    NSMutableString *sb = [[NSMutableString alloc] init];
    for (int i = 0; i < self.treeNode.count; ++i) {
        TreeNode *node = self.treeNode[i];
//        NSLog(@"%d,%d,%d",i,[c1.index intValue],[c2.index intValue]);
        if (node.s == [c1.index intValue] && node.e == [c2.index intValue]) {
            [sb appendString:[NSString stringWithFormat:@"%c",node.ch]];
        }
    }
    return [NSString stringWithString:sb];
}

- (NSInteger)circleCount {
    NSMutableArray *v = [[NSMutableArray alloc] init];
    for (int i = 0; i < self.treeNode.count; ++i) {
        TreeNode *node = self.treeNode[i];
        if (![self contain:v num:node.e]) {
            [v addObject:[NSNumber numberWithInteger:node.e]];
        }
        if (![self contain:v num:node.s]) {
            [v addObject:[NSNumber numberWithInteger:node.s]];
        }
    }
    NSLog(@"%ld",v.count);
    return v.count;
}

- (BOOL)contain:(NSMutableArray *)v num:(NSInteger) num {
    for (int i = 0; i < v.count; ++ i) {
        NSNumber *value = v[i];
        if (value.intValue == num) {
            return YES;
        }
    }
    return NO;
}


- (NSMutableArray *)getalls:(NSMutableArray *)set {
    NSMutableArray *v = [[NSMutableArray alloc] init];
    NSMutableArray *t;
    NSNumber *num;
    NSNumber *s = set[0];
    if (s.integerValue == -1) {
        t = [[NSMutableArray alloc] initWithCapacity:1];
//        [t replaceObjectAtIndex:0 withObject:[NSNumber numberWithInteger:0]];
        [t addObject:[NSNumber numberWithInteger:0]];
        return t;
    }
    for (int i = 0; i < set.count; ++ i) {
        NSNumber *obj = set[i];
        t = [self getall:obj.integerValue];
        obj = t[0];
        if (obj.integerValue != -1) {
            for (int j = 0; j < t.count; ++j) {
                obj = t[j];
                if (![self contain:v num:obj.integerValue] && ![self contain:self.vdraw num:obj.integerValue]) {
                    num = t[j];
                    [v addObject:num];
                }
            }
        }
    }
    if (v.count != 0) {
        t = [NSMutableArray arrayWithArray:v];
    }else{
        t = [[NSMutableArray alloc] init];
//        [t replaceObjectAtIndex:0 withObject:[NSNumber numberWithInteger:-1]];
        [t addObject:[NSNumber numberWithInteger:-1]];
    }
    return t;
}


- (NSMutableArray *)getall:(NSInteger)num {
    NSMutableArray *ts;
    NSMutableArray *te;
    NSMutableArray *t;
    NSMutableArray *v = [[NSMutableArray alloc] init];
    ts = [self gets:num];
    te = [self gete:num];
    NSNumber *obj = ts[0];
    if (obj.integerValue != -1) {
        for (int i = 0; i < ts.count; ++i) {
            NSNumber *nodei = ts[i];
            TreeNode *node = self.treeNode[nodei.integerValue];
            NSInteger n = node.e;
            if (! [self contain:v num:n]) {
                [v addObject:[NSNumber numberWithInteger:n]];
            }
        }
    }
    obj = te[0];
    if (obj.integerValue != -1) {
        for (int i = 0; i < te.count; ++i) {
            NSNumber *nodei = te[i];
            TreeNode *node = self.treeNode[nodei.integerValue];
            NSInteger n = node.e;
            if (! [self contain:v num:n]) {
                [v addObject:[NSNumber numberWithInteger:n]];
            }
        }
    }
    if (v.count != 0) {
        t = [NSMutableArray arrayWithArray:v];
    }else{
        t = [[NSMutableArray alloc] initWithCapacity:1];
//        [t replaceObjectAtIndex:0 withObject:[NSNumber numberWithInteger:-1]];
        [t addObject:[NSNumber numberWithInteger:-1]];
    }
    return t;
}



- (NSMutableArray *)gets:(NSInteger)first {
    NSMutableArray *v = [[NSMutableArray alloc] init];
    NSMutableArray *t;
    for (int i = 0; i < self.treeNode.count; ++i) {
        TreeNode *node = self.treeNode[i];
        if (node.s == first) {
            [v addObject:[NSNumber numberWithInteger:i]];
        }
    }
    if (v.count != 0) {
        t = [NSMutableArray arrayWithArray:v];
    }else{
        t = [[NSMutableArray alloc] initWithCapacity:1];
//        [t replaceObjectAtIndex:0 withObject:[NSNumber numberWithInteger:-1]];
        [t addObject:[NSNumber numberWithInteger:-1]];
    }
    return t;
}

- (NSMutableArray *)gete:(NSInteger) last {
    NSMutableArray *v = [[NSMutableArray alloc] init];
    NSMutableArray *t;
    for (int i = 0; i< self.treeNode.count; ++i) {
        TreeNode *node = self.treeNode[i];
        if (node.e == last) {
            [v addObject:[NSNumber numberWithInteger:i]];
        }
    }
    if (v.count != 0) {
        t = [NSMutableArray arrayWithArray:v];
    }else{
        t = [[NSMutableArray alloc] initWithCapacity:1];
//        [t replaceObjectAtIndex:0 withObject:[NSNumber numberWithInteger:-1]];
        [t addObject:[NSNumber numberWithInteger:-1]];
    }
    return t;
}
@end
