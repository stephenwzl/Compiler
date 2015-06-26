//
//  NFA.m
//  Compiler
//
//  Created by 王志龙 on 15/6/24.
//  Copyright (c) 2015年 wangzhilong. All rights reserved.
//

#import "NFA.h"
#import "mapExpr.h"
#import "Node.h"
#import "List.h"
@interface NFA()

@property (strong, nonatomic) NSMutableArray *mapExpr;
@property (strong, nonatomic) NSMutableArray *v;
@property (strong, nonatomic) NSMutableArray *v2;
@property (strong, nonatomic) NSMutableArray *v3;
@property (strong, nonatomic) List *Total;
@property (strong, nonatomic) NSString *input;
@property (assign, nonatomic) char currentToken;
@property (assign, nonatomic) NSInteger num;


@end

@implementation NFA

- (instancetype)initWithString:(NSString *)in {
    self = [super init];
    if(in.length > 100){
        [self error:7];
    }
    if(self){
        self.num = 0;
        self.input = [NSString stringWithFormat:@"%@%c",in,'$'];
                for(int i = 0; i < in.length; ++ i){
            if(![self isChar:[in characterAtIndex:i]] && ![self isControl:[in characterAtIndex:i]]){
                [self error:1];
            }
        }
        [self advance];
        self.Total = [[List alloc] init];
        self.Total = [self expr:self.Total];
        if(self.currentToken != '$'){[self error:2];}
        self.Total.end.accept = YES;
    }
    return self;
}

- (void)advance {
    self.currentToken = [self.input characterAtIndex:self.num++];
}

- (List *)expr:(List *)l {
    Node *p;
    List *l2 = [List new];
    l = [self catexpr:l];
    while ([self match:'|']) {
        [self advance];
        l2.start = nil;
        l2.end = nil;
        l2 = [self catexpr:l2];
        if(l2.start == nil){ [self error:3];}

        if(l.start == nil){ [self error:4];}
        
        p = [Node new];
        p.next = l.start;
        p.next2 = l2.start;
        l.start = p;
        
        p = [Node new];
        l.end.next = p;
        l2.end.next = p;
        l.end = p;
    }
    if(l.start == nil) {[self error:5];}
    return l;

}

- (List *)catexpr:(List *)l {
    List *l2 = [List new];
    if ([self firstincat:self.currentToken]) {
        l = [self factor:l];
    }
    while ([self firstincat:self.currentToken])
    {
        //list l2 = new list();
        
        l2 = [self factor:l2];
        [self mcopy:l.end node2:l2.start];
        
        l.end = l2.end;
        l2.start = nil;
        l2.end = nil;
    }
    return l;
}

- (void)mcopy:(Node *)n1 node2:(Node *)n2 {
    n1.edge = n2.edge ;
    n1.accept = n2.accept ;
    n1.next = n2.next;
    n1.next2 = n2.next2 ;

}

- (BOOL) firstincat:(char)token {
    switch (token) {
        case ')':
            case '|':
            case '$':
            return NO;
        case '*':[self error:6];
            return NO;
            
        default:
            break;
    }
    return true;
}


- (List *)factor:(List *)l {
    Node *start;
    Node *end;
    l = [self term:l];
    if ([self match:'*']) {
        start = [Node new];
        end = [Node new];
        start.next = l.start;
        l.end.next = end;
        start.next2 = end;
        l.end.next2 = l.start;
        l.start = start;
        l.end = end;
        [self advance];
    }
    return l;
}




- (List *)term:(List *)l {
    Node *start;
    if ([self match:'('] ) {
        [self advance];
        [self expr:l];
        if ([self match:')']) {
            [self advance];
        }else {
            [self error:0];
        }
    }else {
        start = [Node new];
        start.next = [Node new];
        
        l.start = start;
        l.end = start.next;
        start.edge = self.currentToken;
        [self advance];
    }
    return l;
}

- (BOOL)match:(char)token {
    if (self.currentToken == token) {
        return YES;
    }
    return NO;
}
- (NSInteger)getMapStart {
    return 0;
}

- (NSMutableArray *)getMapEnd {
    
    NSInteger n =  [self.v indexOfObject:self.Total.end];
    NSMutableArray *result = [[NSMutableArray alloc] init];
    [result addObject:[NSNumber numberWithInteger:n]];
    return result;
}

- (NSMutableArray *)getResult {
    self.v = [[NSMutableArray alloc] init];
    self.v2 = [[NSMutableArray alloc] init];
    self.v3 = [[NSMutableArray alloc] init];
    [self travel:self.Total.start];
    self.mapExpr = [NSMutableArray arrayWithArray:self.v3];
    return self.mapExpr;
}

- (void)travel:(Node *)p {
    if (p != nil && [self.v2 indexOfObject:p] == NSNotFound) {
        [self visit:p];
        [self travel:p.next];
        [self travel:p.next2];
    }
}

- (void)visit:(Node *)p {
    NSInteger begincode,endcode;
    mapExpr *mp;
    if ([self.v indexOfObject:p] == NSNotFound) {
        [self.v addObject:p];
    }
    begincode = [self.v indexOfObject:p];
    if (p.next != nil) {
        if ([self.v indexOfObject:p.next] == NSNotFound) {
            [self.v addObject:p.next];
        }
        endcode = [self.v indexOfObject:p.next];
        mp = [[mapExpr alloc] init];
        mp.qstart = begincode;
        mp.letter = p.edge;
        mp.qend = endcode;
        [self.v3 addObject:mp];
    }
    if (p.next2 != nil) {
        if ([self.v indexOfObject:p.next2] == NSNotFound) {
            [self.v addObject:p.next2];
        }
        endcode = [self.v indexOfObject:p.next2];
        mp = [[mapExpr alloc] init];
        mp.qstart = begincode;
        mp.letter = p.edge;
        mp.qend = endcode;
        [self.v3 addObject:mp];
    }
    [self.v2 addObject:p];
}
- (void)error:(NSInteger)num {
    NSLog(@"throw a error: %ld",(long)num);
}

- (BOOL)isChar:(char)ch {
    if ((ch >= 'a' && ch <= 'z') ||(ch >= 'A' && ch <= 'Z')) {
        return YES;
    }
    return NO;
}

- (BOOL)isControl:(char)ch {
    if (ch == '$' || ch == '*' || ch == '(' || ch == ')') {
        return YES;
    }
    return NO;
}
@end
