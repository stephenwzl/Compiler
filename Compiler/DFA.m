//
//  DFA.m
//  Compiler
//
//  Created by 王志龙 on 15/6/25.
//  Copyright (c) 2015年 wangzhilong. All rights reserved.
//

#import "DFA.h"
#import "mapExpr.h"
#import "Stack.h"
@interface DFA()
@property (strong, nonatomic) NSMutableArray *NFAmp;
@property (strong, nonatomic) NSMutableArray *DFAmp;
@property (strong, nonatomic) NSMutableArray *v;
@property (assign, nonatomic) NSInteger end;

@end

@implementation DFA

- (instancetype)initDFAWithString:(NSString *)input {
    self = [super initWithString:input];
    self.NFAmp = [super getResult];
    NSMutableArray *n = [super getMapEnd];
    NSNumber *obj = n[0];
    self.end = obj.integerValue;
    NSMutableArray *v0 = [[NSMutableArray alloc] init];
    [v0 addObject:[NSNumber numberWithInteger:0]];
    
    self.v = [self closure:v0];
    self.v = [self create:self.v];
    
    return self;
}


- (NSMutableArray *)closure:(NSMutableArray *) v {
    NSMutableArray *set = [[NSMutableArray alloc] init];
    Stack *s = [[Stack alloc] init];
    for (NSNumber *num in v) {
        [set addObject:num];
        [s push:num.integerValue];
    }
    
    while (![s isEmpty]) {
        NSInteger q = [s pop];
        NSMutableArray * vNext = [self nextState:q letter:'^'];
        for (int i = 0; i < vNext.count; ++i) {
            NSNumber *obj = vNext[i];
            if ([set indexOfObject:obj] == NSNotFound) {
                [set addObject:obj];
                [s push:obj.integerValue];
            }
        }
    }
    return set;
}


- (NSMutableArray *)create:(NSMutableArray *)v {
    NSMutableArray *set = [[NSMutableArray alloc] init];
    Stack *s = [[Stack alloc] init];
    [set addObject:v];
    [s pushArray:v];
    while (![s isEmpty]) {
        NSMutableArray *vs = [s popArray];
        for (int i = 0; i < 26; i++) {
            char c = 'a' +i;
            NSMutableArray *ve = [self closure:[self move:vs letter:c]];
            if (ve.count > 0) {
                if (![self contain:set V2:ve]) {
                    [set addObject:ve];
                    if (![self equal:ve V2:vs] && [s searchArray:ve] == NO) {
                        [s pushArray:ve];
                    }
                }
            }
        }
    }
    return set;
}


- (BOOL)contain:(NSMutableArray *)v1 V2:(NSMutableArray *)v2 {
    for (NSMutableArray *obj in v1) {
        if ([self equal:obj V2:v2]) {
            return YES;
        }
    }
    return NO;
}


- (BOOL)equal:(NSMutableArray *)v1 V2:(NSMutableArray *)v2 {
    if (v1.count != v2.count) {
        return NO;
    }
    for (int i = 0;i < v1.count; ++i) {
        NSNumber *obj1 = v1[i];
        NSNumber *obj2 = v2[i];
        if (obj2.integerValue != obj1.integerValue) {
            return NO;
        }
    }
    return YES;
}

- (NSMutableArray *)move:(NSMutableArray *)vStart letter:(char)ch {
    NSMutableArray *vEnd = [[NSMutableArray alloc] init];
    for (int i = 0; i < vStart.count; ++i) {
        NSNumber *qnum = vStart[i];
        NSMutableArray *v = [self nextState:qnum.integerValue letter:ch];
        for (NSNumber *obj in v) {
            if ([vEnd indexOfObject:obj] == NSNotFound) {
                [vEnd addObject:obj];
            }
        }
    }
    return vEnd;
}


- (NSInteger)stateNum {
    return self.v.count;
}

- (NSMutableArray *)nextState:(NSInteger) start letter:(char) ch {
    NSMutableArray *vector = [[NSMutableArray alloc] init];
    for (int i = 0; i < self.NFAmp.count; ++i ) {
        mapExpr *obj = self.NFAmp[i];
        if (obj.qstart == start) {
            if (obj.letter == ch) {
                [vector addObject:[NSNumber numberWithInteger:obj.qend]];
            }
        }
    }
    return vector;
}

- (NSInteger)getMapStart {
    return 0;
}


- (NSMutableArray *)getMapEnd {
    NSMutableArray *result = [[NSMutableArray alloc] init];
    NSNumber *e = [NSNumber numberWithInteger:self.end];
    for (int i = 0; i < self.v.count; ++i) {
        NSMutableArray *array = self.v[i];
        if ([array indexOfObject:e] != NSNotFound) {
            [result addObject:[NSNumber numberWithInteger:i]];
        }
    }
    return result;
}

- (NSMutableArray *)getResult {
    NSMutableArray *v = [self getmp];
    return v;
}

- (NSMutableArray *)getmp {
    mapExpr *mp;
    NSMutableArray *result = [[NSMutableArray alloc] init];
    for (int i = 0; i < self.v.count; i++) {
        NSMutableArray *vs = self.v[i];
        for (int j = 0; j < 26; j++) {
            char c = 'a' +i;
            NSMutableArray *ve = [self closure:[self move:vs letter:c]];
            if (ve.count > 0) {
                NSInteger e = [self getIndex:self.v V2:ve];
                mp = [mapExpr new];
                mp.qstart = i;
                mp.qend = e;
                mp.letter = 'a' +j;
                [result addObject:mp];
            }
        }
    }
    return result;
}


- (NSInteger)getIndex:(NSMutableArray *)v V2:(NSMutableArray *)v2 {
    for (int i = 0; i < self.v.count; i++) {
        NSMutableArray *t = self.v[i];
        if ([self equal:t V2:v2]) {
            return i;
        }
    }
    return -1;
}
@end
