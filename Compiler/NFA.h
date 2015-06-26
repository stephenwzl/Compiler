//
//  NFA.h
//  Compiler
//
//  Created by 王志龙 on 15/6/24.
//  Copyright (c) 2015年 wangzhilong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NFA : NSObject

- (instancetype)initWithString:(NSString *)in;
- (void)error:(NSInteger) num;

- (NSMutableArray *)getResult;
- (NSInteger)getMapStart;
- (NSMutableArray *)getMapEnd;
@end
