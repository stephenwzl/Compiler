//
//  List.h
//  Compiler
//
//  Created by 王志龙 on 15/6/24.
//  Copyright (c) 2015年 wangzhilong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Node.h"
@interface List : NSObject

@property (strong, nonatomic) Node *start;
@property (strong, nonatomic) Node *end;

@end
