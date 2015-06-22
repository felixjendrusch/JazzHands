#import <Foundation/Foundation.h>
#import <JazzHands/IFTTTJazzHands.h>

@interface MyCustomValue : NSValue <IFTTTInterpolatable>

@property (nonatomic, assign, readonly) CGPoint controlPoint1;
@property (nonatomic, assign, readonly) CGPoint controlPoint2;

- (instancetype)initWithCGRect:(CGRect)rect controlPoint1:(CGPoint)controlPoint1 controlPoint2:(CGPoint)controlPoint2;

- (CGRect)interpolateCGRectFrom:(CGRect)fromValue to:(CGRect)toValue withProgress:(CGFloat)progress;
- (CGPoint)interpolateCGPointFrom:(CGPoint)fromValue to:(CGPoint)toValue withProgress:(CGFloat)progress;

@end
