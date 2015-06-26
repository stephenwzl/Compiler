//
//  Stack.h
//  Compiler
//
//  Created by 王志龙 on 15/6/25.
//  Copyright (c) 2015年 wangzhilong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Stack : NSObject

- (void)push:(NSInteger) obj;
- (NSInteger)pop;
- (void)pushArray:(NSMutableArray *) obj;
- (NSMutableArray *) popArray;
- (BOOL)isEmpty;
- (BOOL)search:(NSInteger) obj;
- (BOOL)searchArray:(NSMutableArray *) obj;
@end
