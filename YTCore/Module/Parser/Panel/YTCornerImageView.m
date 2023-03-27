//
//  YTCornerImageView.m
//  YTCore
//
//  Created by kaoji on 3/14/23.
//

#import "YTCornerImageView.h"

@implementation YTCornerImageView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.masksToBounds = YES;
    }
    return self;
}

- (void)setCornerRadius:(CGFloat)cornerRadius {
    _cornerRadius = cornerRadius;
    [self setNeedsLayout];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (_cornerRadius > 0) {
        CGRect maskBounds = self.bounds;
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:maskBounds cornerRadius:_cornerRadius];
        CAShapeLayer *maskLayer = [CAShapeLayer layer];
        maskLayer.frame = maskBounds;
        maskLayer.path = maskPath.CGPath;
        self.layer.mask = maskLayer;
    }
}

@end
