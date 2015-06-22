#import "MyCustomValue.h"

#if CGFLOAT_IS_DOUBLE
#define POW(X, Y) pow(X, Y)
#else
#define POW(X, Y) powf(X, Y)
#endif

@interface MyCustomValue ()

@property (nonatomic, copy, readonly) NSValue *underlyingValue;

@end

@implementation MyCustomValue

- (instancetype)initWithCGRect:(CGRect)rect controlPoint1:(CGPoint)controlPoint1 controlPoint2:(CGPoint)controlPoint2
{
    self = [super init];
    if (self == nil) {
        return nil;
    }

    _underlyingValue = [NSValue valueWithCGRect:rect];

    _controlPoint1 = controlPoint1;
    _controlPoint2 = controlPoint2;

    return self;
}

- (NSValue *)interpolateTo:(NSValue *)toValue withProgress:(CGFloat)progress
{
    CGRect rect = [self interpolateCGRectFrom:[self CGRectValue] to:[toValue CGRectValue] withProgress:progress];
    return [NSValue valueWithCGRect:rect];
}

- (CGRect)interpolateCGRectFrom:(CGRect)fromValue to:(CGRect)toValue withProgress:(CGFloat)progress
{
    CGPoint origin = [self interpolateCGPointFrom:fromValue.origin to:toValue.origin withProgress:progress];
    CGSize size = [self.class interpolateCGSizeFrom:fromValue.size to:toValue.size withProgress:progress];
    return (CGRect){
        .origin = { .x = origin.x, .y = origin.y },
        .size = { .width = size.width, .height = size.height }
    };
}

- (CGPoint)interpolateCGPointFrom:(CGPoint)fromValue to:(CGPoint)toValue withProgress:(CGFloat)progress
{
    // B(t) = (1 - t) ^ 3 * s + 3 * (1 - t) ^ 2 * t * cp1 + 3 * (1 - t) * t ^ 2 * cp2 + t ^ 3 * e
    CGFloat x =     POW(1 - progress, 3)                    * fromValue.x
              + 3 * POW(1 - progress, 2) *     progress     * self.controlPoint1.x
              + 3 *    (1 - progress)    * POW(progress, 2) * self.controlPoint2.x
              +                            POW(progress, 3) * toValue.x;
    CGFloat y =     POW(1 - progress, 3)                    * fromValue.y
              + 3 * POW(1 - progress, 2) *     progress     * self.controlPoint1.y
              + 3 *    (1 - progress)    * POW(progress, 2) * self.controlPoint2.y
              +                            POW(progress, 3) * toValue.y;
    return (CGPoint){ .x = x, .y = y };
}

- (void)getValue:(void *)value
{
    [self.underlyingValue getValue:value];
}

@end
