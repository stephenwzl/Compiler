//
//  Line.h
//  Compiler
//
//  Created by 王志龙 on 15/6/23.
//  Copyright (c) 2015年 wangzhilong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Line : NSObject

@property (strong, nonatomic) NSString *content;
@property (assign, nonatomic) NSInteger start;
@property (assign, nonatomic) NSInteger end;
@property (assign, nonatomic) NSInteger type;

- (instancetype)initWithString:(NSString *)str start:(NSInteger) s end:(NSInteger) e type:(NSInteger) type;

@end
