//
//  Node.h
//  Compiler
//
//  Created by 王志龙 on 15/6/24.
//  Copyright (c) 2015年 wangzhilong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Node : NSObject

@property (assign, nonatomic) char edge;
@property (assign, nonatomic) BOOL accept;
@property (strong, nonatomic) Node *next;
@property (strong, nonatomic) Node *next2;
@end
