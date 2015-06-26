//
//  DFA.h
//  Compiler
//
//  Created by 王志龙 on 15/6/25.
//  Copyright (c) 2015年 wangzhilong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NFA.h"

@interface DFA : NFA

- (NSInteger)stateNum;

- (instancetype)initDFAWithString:(NSString *) input;
//- (NSMutableArray *)getmpEnd;
@end
