//
//  TreeCanvas.m
//  Compiler
//
//  Created by 王志龙 on 15/6/24.
//  Copyright (c) 2015年 wangzhilong. All rights reserved.
//

#import "TreeCanvas.h"
#import "Tree.h"
@implementation TreeCanvas

- (instancetype)init {
    self = [super init];
    if (self) {
        self.update = NO;
    }
    return self;
}

- (instancetype)initWithnewTree:(NSMutableArray *)mapExpr Interger:(NSMutableArray *)n {
    self = [super init];
    if (self) {
        self.update = NO;
        [self newTree:mapExpr Integer:n];
    }
    return self;
}

- (void)clear {
    self.update = NO;
//    [self repaint];
}

- (void)newTree:(NSMutableArray *)mapExpr Integer:(NSMutableArray *)n {
    Tree *t = [[Tree alloc] initWithMap:mapExpr];
    self.cs = t.cs;
    self.ls = t.ls;
    NSLog(@"%@",t.ls);
    for(int i = 0;i < self.cs.count; i++ )
    {
        for(int j = 0;j < n.count; j++){
            Circle *obj = self.cs[i];
            NSNumber *obj2 = n[j];
            if (obj2.integerValue == [obj.index integerValue]) {
                obj.end = YES;
                [self.cs replaceObjectAtIndex:i withObject:obj];
            }
        }
    }
    self.update = true;
}

- (void)drawRect:(CGRect)rect {
    [self drawLine];
    [self drawcircle];
}

- (void) drawcircle{
    int r = 26;
    
    for(int i= 0; i< self.cs.count;i++)
    {
        Circle *c = self.cs[i];
        int x = (int)(c.x - r/2);
        int y = (int)(c.y - r/2);
        [self drawCircleAtX:x Y:y R:r];
        if(c.end){ [self drawCircleAtX:x  Y:y R:(r-4)];}
        if(c.index.length ==1){
            [self drawTextAtX:x-4 Y:y-8 text:c.index];
        }
        if(c.index.length ==2){
            [self drawTextAtX:x + 8 Y:y + 15 text:c.index];
        }
    }
}



- (void)drawLine{
    NSInteger x,y,x1,y1;
    for (int i = 0; i < self.ls.count; i++) {
        Line *l = self.ls[i];
        Circle *c = self.cs[l.start];
        x = c.x;
        y = c.y;
        c = self.cs[l.end];
        x1 = c.x;
        y1 = c.y;
        if (l.type == 1) {
            [self drawBezier:x Y1:y X2:x1 Y2:y1];
            [self drawTextAtX:(x + x1)/2 Y:(y + y1)/2 text:l.content];
        }
        if (l.type == 2) {
            [self drawArcLine:x Y1:y-20 X2:x1 Y2:y1-20];
            if (x > x1) {
                [self drawTextAtX:(x + x1)/2 Y:(y + y1)/2 text:l.content];
            }else{
            [self drawTextAtX:(x + x1)/2 Y:(y + y1)/2 - 50 text:l.content];
            }
        }
    }
}


- (void)drawarc:(CGContextRef)ctx x1:(CGFloat)x1 y1:(CGFloat)y1 x2:(CGFloat)x2 y2:(CGFloat)y2 {
    CGPoint p1 = CGPointMake(x1, y1);
    CGPoint p2 = CGPointMake(x2, y2);
    CGPoint p3 = [self getp3:x1 y1:y1 x2:x2 y2:y2];
    [self arc:ctx Point1:p1 Point2:p2 Point3:p3];
}


- (void)arc:(CGContextRef)ctx Point1:(CGPoint)p1 Point2:(CGPoint)p2 Point3:(CGPoint)p3 {
    int x0,y0;
    int angle1,angle2;
    int arcAngle,startAngle;
    int r;
    int x,y;
    CGPoint p = [self clinePoint:p1 p2:p2 p3:p3];
    x0 = p.x;
    y0 = p.y;
    r = [self clineR:p1 p2:p2 p3:p3];
    x = x0 - r;
    y = y0 - r;
    angle1 = [self getAngle:x0 y:y0 p:p1];
    angle2 = [self getAngle:x0 y:y0 p:p2];
    arcAngle = abs(angle1 - angle2);
    startAngle = MIN(angle1, angle2);
    if (arcAngle > 180) {
        arcAngle = 360 -arcAngle;
        startAngle = MAX(angle1, angle2);
    }
    [self drawARC:x Y:y radius:r startAngle:startAngle endAngle:arcAngle ctx:ctx];
}

- (void)drawARC:(int)x Y:(int)y radius:(int)r startAngle:(int)startAngle endAngle:(int)arcAngle ctx:(CGContextRef) ctx{
    CGContextSetFillColorWithColor(ctx, [UIColor greenColor].CGColor);
    CGContextDrawPath(ctx, kCGPathStroke);
    CGContextAddArc(ctx, x, y, r, startAngle, arcAngle, 1);
//    CGContextFillPath(ctx);
}
- (int)getAngle:(int) x y:(int) y p:(CGPoint) p{
    int dx,dy;
    double a1;
    int a;
    dx = (int)fabs(p.x - x);
    dy = (int)fabs(p.y - y);
    if (dx == 0){
        if(y - p.y >= 0){
            return  90;
        }else{
            return 270;
        }
    }
    a1 = atan((double)dy/dx);
    a = (int)(a1*180/M_PI);
    if(p.x - x>0){
        if(y - p.y>=0) {return a;}
        else {return 360 - a;}
    }else if(y - p.y>= 0) {
        return 180 - a;
    }else {
        return 180 + a;
    }
}


- (int)clineR:(CGPoint)p1 p2:(CGPoint)p2 p3:(CGPoint)p3 {
    int x0,y0;
    int r;
    CGPoint p = [self clinePoint:p1 p2:p2 p3:p3];
    x0 = p.x;
    y0 = p.y;
    r =(int) sqrt((p1.x - x0)*(p1.x-x0)
                       +(p1.y - y0)*(p1.y-y0));
    return r;
}

- (CGPoint)clinePoint:(CGPoint)p1 p2:(CGPoint)p2 p3:(CGPoint)p3 {
    int x0,y0;
    float t1;
    t1 =(float)((float) (p3.y-p2.y)/(float)(p2.x-p3.x)
                -(float)(p1.y-p3.y)/(float)(p3.x-p1.x) );
    y0 =(int)(( (float)(p3.y*p3.y-p1.y*p1.y)/(float)(2*p3.x-2*p1.x)
               - (float)(p2.y*p2.y-p3.y*p3.y)/(float)(2*p2.x-2*p3.x)
               + (float)(p1.x-p2.x)/2 ) /t1);
    
    x0 = (int)( (float)(p1.x+p3.x)/2+(float)(p1.y-p3.y)*y0/(float)(p3.x-p1.x)
               +(float)(p3.y*p3.y-p1.y*p1.y)/(float)(2*p3.x-2*p1.x) );
    return CGPointMake(x0, y0);
}


- (CGPoint)getp3:(CGFloat)x1 y1:(CGFloat)y1 x2:(CGFloat)x2 y2:(CGFloat)y2 {
    CGPoint p3;
    int  a = 5 ;
    int k,x0,y0,d;
    int x,y;
    x0 = (x1 + x2)/2;
    y0 = (y1 + y2)/2;
    d = ((x1 - x2)*(x1 - x2) + (y1 - y2)*(y1 - y2))/a/a;
    if (y1 == y2) {
        p3 = CGPointMake(x0, (x2 - x1)/a);
    }else if (x1 == x2){
        p3 = CGPointMake(x1+(y2-y1)/a, y0);
    }else {
        k = (x1 - x2)/(y2 - y1);
        int da = (int) sqrt(d/(1+k*k));
        if (y1 < y2) {
            x = x0 - da;
        }else{
            x = x0 + da;
        }
        y = y0 + k*(x -x0);
        p3 = CGPointMake(x, y);
    }
    return p3;
}

- (void)drawCircleAtX:(float)x Y:(float)y R:(float)r{
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(ctx, [UIColor cyanColor].CGColor);
    if(r < 26){
        CGContextSetFillColorWithColor(ctx, [UIColor brownColor].CGColor);
    }
    /**
     *  @brief 在当前路径添加圆弧 参数按顺序说明
     *
     *  @param c           当前图形
     *  @param x           圆弧的中心点坐标x
     *  @param y           曲线控制点的y坐标
     *  @param radius      指定点的x坐标值
     *  @param startAngle  弧的起点与正X轴的夹角，
     *  @param endAngle    弧的终点与正X轴的夹角
     *  @param clockwise   指定1创建一个顺时针的圆弧，或是指定0创建一个逆时针圆弧
     *
     */
    CGContextAddArc(ctx, x, y, r, 0, 2 * M_PI, 1);
    
    //绘制当前路径区域
    CGContextFillPath(ctx);
}

- (void)drawTextAtX:(float)x Y:(float)y text:(NSString *)text {
    CGContextRef context=UIGraphicsGetCurrentContext();
    CGContextSetTextDrawingMode (context,kCGTextFillStroke);//设置绘制方式
    CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);//填充色设置成蓝色，即文字颜色
    
    CGContextSetLineWidth(context,0);//我们采用的是FillStroke的方式，所以要把边线去掉，否则文字会很粗
    //绘制文字，注意，此方法从7.0开始逐渐废弃，慎用！！
    [text drawAtPoint:CGPointMake(x,y) withAttributes:nil];
    
}

- (void)drawBezier:(CGFloat)x1 Y1:(CGFloat)y1 X2:(CGFloat)x2 Y2:(CGFloat)y2 {
    
    UIBezierPath* bezierPath = UIBezierPath.bezierPath;
    [bezierPath moveToPoint: CGPointMake(x1, y1)];
    [bezierPath addLineToPoint: CGPointMake(x2, y2)];
    [UIColor.blackColor setStroke];
    bezierPath.lineWidth = 1;
    [bezierPath stroke];
}

- (void)drawArcLine:(CGFloat)x1 Y1:(CGFloat)y1 X2:(CGFloat)x2 Y2:(CGFloat)y2 {
    UIBezierPath* bezierPath = UIBezierPath.bezierPath;
    if (x1 < x2) {
        [bezierPath moveToPoint: CGPointMake(x1, y1)];
        [bezierPath addCurveToPoint: CGPointMake((x1+x2)/2, y1-15) controlPoint1: CGPointMake(x1, y1) controlPoint2: CGPointMake(x1+10, y1-15)];
        [bezierPath addCurveToPoint: CGPointMake(x2, y2) controlPoint1: CGPointMake(x2-10, y2-15) controlPoint2: CGPointMake(x2, y2)];
        [UIColor.blackColor setStroke];
    }
    if (x1 > x2) {
        [bezierPath moveToPoint: CGPointMake(x1, y1)];
        [bezierPath addCurveToPoint: CGPointMake((x1+x2)/2, y1+15) controlPoint1: CGPointMake(x1, y1) controlPoint2: CGPointMake(x1-10, y1+15)];
        [bezierPath addCurveToPoint: CGPointMake(x2, y2) controlPoint1: CGPointMake(x2+10, y2+15) controlPoint2: CGPointMake(x2, y2)];
        [UIColor.blackColor setStroke];
    }
    bezierPath.lineWidth = 1;
    [bezierPath stroke];
}
@end
