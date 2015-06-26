//
//  Circle.h
//  Compiler
//
//  Created by 王志龙 on 15/6/23.
//  Copyright (c) 2015年 wangzhilong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Circle : NSObject

@property (strong, nonatomic) NSString *index;
@property (assign, nonatomic) NSInteger x;
@property (assign, nonatomic) NSInteger y;
@property (assign, nonatomic) BOOL end;

- (instancetype)initWithString:(NSString *)str px:(NSInteger) px py:(NSInteger) py;

@end
