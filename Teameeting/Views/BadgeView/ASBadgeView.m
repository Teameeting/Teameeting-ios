//
//  ASBadgeView.m
//  MyASASPD
//
//  Created by work on 15/3/3.
//  Copyright (c) 2015年 work. All rights reserved.
//

#import "ASBadgeView.h"
#import <QuartzCore/QuartzCore.h>

@interface ASBadgeView(){
    BOOL autoSetCornerRadius;
    CATextLayer *_textLayer;
    CAShapeLayer *_borderLayer;
    CAShapeLayer *_backgroundLayer;
    CAShapeLayer *_glossMaskLayer;
    CAGradientLayer *_glossLayer;
}

@end

@implementation ASBadgeView

- (id)init
{
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
        _hidesWhenZero = YES;
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup
{
    //Set the view properties
    self.backgroundColor = [UIColor clearColor];
    self.userInteractionEnabled = NO;
    self.clipsToBounds = NO;
    
    //Set the default
    _textColor = [UIColor whiteColor];
    _textAlignmentShift = CGSizeZero;
    _font = [UIFont systemFontOfSize:16.0];
    _badgeBackgroundColor = [UIColor redColor];
    _showGloss = NO;
    _cornerRadius = self.frame.size.height / 2;
    _horizontalAlignment = ASBadgeViewHorizontalAlignmentRight;
    _verticalAlignment = ASBadgeViewVerticalAlignmentTop;
    _alignmentShift = CGSizeMake(0, 0);
    _animateChanges = YES;
    _animationDuration = 0.2;
    _borderWidth = 0.0;
    _borderColor = [UIColor whiteColor];
    _shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
    _shadowOffset = CGSizeMake(1.0, 1.0);
    _shadowRadius = 1.0;
    _shadowText = NO;
    _shadowBorder = NO;
    _shadowBadge = NO;
    _hidesWhenZero = NO;
    _pixelPerfectText = YES;
    
    //Set the minimum width / height if necessary;
    if (self.frame.size.height == 0 ) {
        CGRect frame = self.frame;
        frame.size.height = 24.0;
        _minimumWidth = 24.0;
        self.frame = frame;
    } else {
        _minimumWidth = self.frame.size.height;
    }
    
    _maximumWidth = CGFLOAT_MAX;
    
    //Create the text layer
    _textLayer = [CATextLayer layer];
    _textLayer.foregroundColor = _textColor.CGColor;
    _textLayer.font = (__bridge CFTypeRef)(_font.fontName);
    _textLayer.fontSize = _font.pointSize;
    _textLayer.alignmentMode = kCAAlignmentCenter;
    _textLayer.truncationMode = kCATruncationEnd;
    _textLayer.wrapped = NO;
    _textLayer.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    _textLayer.contentsScale = [UIScreen mainScreen].scale;
    
    //Create the border layer
    _borderLayer = [CAShapeLayer layer];
    _borderLayer.strokeColor = _borderColor.CGColor;
    _borderLayer.fillColor = [UIColor clearColor].CGColor;
    _borderLayer.lineWidth = _borderWidth;
    _borderLayer.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    _borderLayer.contentsScale = [UIScreen mainScreen].scale;
    
    //Create the background layer
    _backgroundLayer = [CAShapeLayer layer];
    _backgroundLayer.fillColor = _badgeBackgroundColor.CGColor;
    _backgroundLayer.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    _backgroundLayer.contentsScale = [UIScreen mainScreen].scale;
    
    //Create the gloss layer
    _glossLayer = [CAGradientLayer layer];
    _glossLayer.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    _glossLayer.contentsScale = [UIScreen mainScreen].scale;
    _glossLayer.colors = @[(id)[UIColor colorWithWhite:1 alpha:.8].CGColor,(id)[UIColor colorWithWhite:1 alpha:.25].CGColor, (id)[UIColor colorWithWhite:1 alpha:0].CGColor];
    _glossLayer.startPoint = CGPointMake(0, 0);
    _glossLayer.endPoint = CGPointMake(0, .6);
    _glossLayer.locations = @[@0, @0.8, @1];
    _glossLayer.type = kCAGradientLayerAxial;
    
    //Ctreate the mask for the gloss layer
    _glossMaskLayer = [CAShapeLayer layer];
    _glossMaskLayer.fillColor = [UIColor blackColor].CGColor;
    _glossMaskLayer.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    _glossMaskLayer.contentsScale = [UIScreen mainScreen].scale;
    _glossLayer.mask = _glossMaskLayer;
    
    [self.layer addSublayer:_backgroundLayer];
    [self.layer addSublayer:_borderLayer];
    [self.layer addSublayer:_textLayer];
    
    //Setup animations
    CABasicAnimation *frameAnimation = [CABasicAnimation animation];
    frameAnimation.duration = _animationDuration;
    frameAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    NSDictionary *actions = @{@"path": frameAnimation};
    
    //Animate the path changes
    _backgroundLayer.actions = actions;
    _borderLayer.actions = actions;
    _glossMaskLayer.actions = actions;
}

#pragma mark layout

- (void)autoSetBadgeFrame
{
    CGRect frame = self.frame;
    
    //Get the width for the current string
    frame.size.width = [self sizeForString:_text includeBuffer:YES].width;
    if (frame.size.width < _minimumWidth) {
        frame.size.width = _minimumWidth;
    } else if (frame.size.width > _maximumWidth) {
        frame.size.width = _maximumWidth;
    }
    
    //Height doesn't need changing
    
    //Fix horizontal alignment if necessary
    if (_horizontalAlignment == ASBadgeViewHorizontalAlignmentLeft) {
        frame.origin.x = 0 - (frame.size.width / 2) + _alignmentShift.width;
    } else if (_horizontalAlignment == ASBadgeViewHorizontalAlignmentCenter) {
        frame.origin.x = (self.superview.bounds.size.width / 2) - (frame.size.width / 2) + _alignmentShift.width;
    } else if (_horizontalAlignment == ASBadgeViewHorizontalAlignmentRight) {
        frame.origin.x = self.superview.bounds.size.width - (frame.size.width / 2) + _alignmentShift.width;
    }
    
    //Fix vertical alignment if necessary
    if (_verticalAlignment == ASBadgeViewVerticalAlignmentTop) {
        frame.origin.y = 0 - (frame.size.height / 2) + _alignmentShift.height;
    } else if (_verticalAlignment == ASBadgeViewVerticalAlignmentMiddle) {
        frame.origin.y = (self.superview.bounds.size.height / 2) - (frame.size.height / 2.0) + _alignmentShift.height;
    } else if (_verticalAlignment == ASBadgeViewVerticalAlignmentBottom) {
        frame.origin.y = self.superview.bounds.size.height - (frame.size.height / 2.0) + _alignmentShift.height;
    }
    
    //Set the corner radius
    if (autoSetCornerRadius) {
        _cornerRadius = self.frame.size.height / 2;
    }
    
    //If we are pixel perfect, constrain to the pixels.
    if (_pixelPerfectText) {
        CGFloat roundScale = 1 / [UIScreen mainScreen].scale;
        frame = CGRectMake(roundf(frame.origin.x / roundScale) * roundScale,
                           roundf(frame.origin.y / roundScale) * roundScale,
                           roundf(frame.size.width / roundScale) * roundScale,
                           roundf(frame.size.height / roundScale) * roundScale);
    }
    
    //Change the frame
    self.frame = frame;
    CGRect tempFrame = CGRectMake(0, 0, frame.size.width, frame.size.height);
    _backgroundLayer.frame = tempFrame;
    CGRect textFrame;
    if (_pixelPerfectText) {
        CGFloat roundScale = 1 / [UIScreen mainScreen].scale;
        textFrame = CGRectMake(self.textAlignmentShift.width,
                               (roundf(((self.frame.size.height - _font.lineHeight) / 2) / roundScale) * roundScale) + self.textAlignmentShift.height,
                               self.frame.size.width,
                               _font.lineHeight);
    } else {
        textFrame = CGRectMake(self.textAlignmentShift.width, ((self.frame.size.height - _font.lineHeight) / 2) + self.textAlignmentShift.height, self.frame.size.width, _font.lineHeight);
    }
    _textLayer.frame = textFrame;
    _glossLayer.frame = tempFrame;
    _glossMaskLayer.frame = tempFrame;
    _borderLayer.frame = tempFrame;
    //Update the paths of the layers
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:tempFrame cornerRadius:_cornerRadius];
    _backgroundLayer.path = path.CGPath;
    _borderLayer.path = path.CGPath;
    //Inset to not show the gloss over the border
    _glossMaskLayer.path = [UIBezierPath bezierPathWithRoundedRect:CGRectInset(self.bounds, _borderWidth / 2.0, _borderWidth / 2.0) cornerRadius:_cornerRadius].CGPath;
}

- (CGSize)sizeForString:(NSString *)string includeBuffer:(BOOL)include
{
    if (!_font) {
        return CGSizeMake(0, 0);
    }
    //Calculate the width of the text
    CGFloat widthPadding;
    if (_pixelPerfectText) {
        CGFloat roundScale = 1 / [UIScreen mainScreen].scale;
        widthPadding = roundf((_font.pointSize * .375) / roundScale) * roundScale;
    } else {
        widthPadding = _font.pointSize * .375;
    }
    
    
    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:(string ? string : @"") attributes:@{NSFontAttributeName : _font}];
    
    CGSize textSize = [attributedString boundingRectWithSize:(CGSize){CGFLOAT_MAX, CGFLOAT_MAX} options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
    
    if (include) {
        textSize.width += widthPadding * 2;
    }
    //Constrain to integers
    if (_pixelPerfectText) {
        CGFloat roundScale = 1 / [UIScreen mainScreen].scale;
        textSize.width = roundf(textSize.width / roundScale) * roundScale;
        textSize.height = roundf(textSize.height / roundScale) * roundScale;
    }
    
    return textSize;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    //Update the frames of the layers
    CGRect textFrame;
    if (_pixelPerfectText) {
        CGFloat roundScale = 1 / [UIScreen mainScreen].scale;
        textFrame = CGRectMake(self.textAlignmentShift.width,
                               (roundf(((self.frame.size.height - _font.lineHeight) / 2) / roundScale) * roundScale) + self.textAlignmentShift.height,
                               self.frame.size.width,
                               _font.lineHeight);
    } else {
        textFrame = CGRectMake(self.textAlignmentShift.width, ((self.frame.size.height - _font.lineHeight) / 2) + self.textAlignmentShift.height, self.frame.size.width, _font.lineHeight);
    }
    _textLayer.frame = textFrame;
    _backgroundLayer.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
    _glossLayer.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
    _glossMaskLayer.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
    _borderLayer.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);;
    
    //Update the layer's paths
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:_cornerRadius];
    _backgroundLayer.path = path.CGPath;
    _borderLayer.path = path.CGPath;
    _glossMaskLayer.path = [UIBezierPath bezierPathWithRoundedRect:CGRectInset(self.bounds, _borderWidth/2, _borderWidth/2) cornerRadius:_cornerRadius].CGPath;
}

#pragma mark setting

- (void)setText:(NSString *)text
{
    _text = text;
    //If the new text is shorter, display the new text before shrinking
    if ([self sizeForString:_textLayer.string includeBuffer:YES].width >= [self sizeForString:text includeBuffer:YES].width) {
        _textLayer.string = text;
        [self setNeedsDisplay];
    } else {
        //If longer display new text after the animation
        if (_animateChanges) {
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(_animationDuration * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                _textLayer.string = text;
            });
        } else {
            _textLayer.string = text;
        }
    }
    //Update the frame
    [self autoSetBadgeFrame];
    
    //Hide badge if text is zero
    [self hideForZeroIfNeeded];
}

- (void)setTextColor:(UIColor *)textColor
{
    _textColor = textColor;
    _textLayer.foregroundColor = _textColor.CGColor;
}

- (void)setFont:(UIFont *)font
{
    _font = font;
    _textLayer.fontSize = font.pointSize;
    _textLayer.font = (__bridge CFTypeRef)(font.fontName);
    //Frame size needs to be changed to match the new font
    [self autoSetBadgeFrame];
}

- (void)setAnimateChanges:(BOOL)animateChanges
{
    _animateChanges = animateChanges;
    if (_animateChanges) {
        //Setup animations
        CABasicAnimation *frameAnimation = [CABasicAnimation animation];
        frameAnimation.duration = _animationDuration;
        frameAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
        NSDictionary *actions = @{@"path": frameAnimation};
        
        //Animate the path changes
        _backgroundLayer.actions = actions;
        _borderLayer.actions = actions;
        _glossMaskLayer.actions = actions;
    } else {
        _backgroundLayer.actions = nil;
        _borderLayer.actions = nil;
        _glossMaskLayer.actions = nil;
    }
}

- (void)setBadgeBackgroundColor:(UIColor *)badgeBackgroundColor
{
    _badgeBackgroundColor = badgeBackgroundColor;
    _backgroundLayer.fillColor = _badgeBackgroundColor.CGColor;
}

- (void)setShowGloss:(BOOL)showGloss
{
    _showGloss = showGloss;
    if (_showGloss) {
        [self.layer addSublayer:_glossLayer];
    } else {
        [_glossLayer removeFromSuperlayer];
    }
}

- (void)setCornerRadius:(CGFloat)cornerRadius
{
    _cornerRadius = cornerRadius;
    autoSetCornerRadius = NO;
    //Update boackground
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:_cornerRadius];
    _backgroundLayer.path = path.CGPath;
    _glossMaskLayer.path = path.CGPath;
    _borderLayer.path = path.CGPath;
}

- (void)setHorizontalAlignment:(ASBadgeViewHorizontalAlignment)horizontalAlignment
{
    _horizontalAlignment = horizontalAlignment;
    [self autoSetBadgeFrame];
}

- (void)setVerticalAlignment:(ASBadgeViewVerticalAlignment)verticalAlignment
{
    _verticalAlignment = verticalAlignment;
    [self autoSetBadgeFrame];
}

- (void)setAlignmentShift:(CGSize)alignmentShift
{
    _alignmentShift = alignmentShift;
    [self autoSetBadgeFrame];
}

- (void)setMinimumWidth:(CGFloat)minimumWidth
{
    _minimumWidth = minimumWidth;
    [self autoSetBadgeFrame];
}

- (void)setMaximumWidth:(CGFloat)maximumWidth
{
    if (maximumWidth < self.frame.size.height) {
        maximumWidth = self.frame.size.height;
    }
    _maximumWidth = maximumWidth;
    [self autoSetBadgeFrame];
    [self setNeedsDisplay];
}

- (void)setHidesWhenZero:(BOOL)hidesWhenZero{
    _hidesWhenZero = hidesWhenZero;
    [self hideForZeroIfNeeded];
}

- (void)setBorderWidth:(CGFloat)borderWidth
{
    _borderWidth = borderWidth;
    _borderLayer.lineWidth = borderWidth;
    [self setNeedsLayout];
}

- (void)setBorderColor:(UIColor *)borderColor
{
    _borderColor = borderColor;
    _borderLayer.strokeColor = _borderColor.CGColor;
}

- (void)setShadowColor:(UIColor *)shadowColor
{
    _shadowColor = shadowColor;
    self.shadowBadge = _shadowBadge;
    self.shadowText = _shadowText;
    self.shadowBorder = _shadowBorder;
}

- (void)setShadowOffset:(CGSize)shadowOffset
{
    _shadowOffset = shadowOffset;
    self.shadowBadge = _shadowBadge;
    self.shadowText = _shadowText;
    self.shadowBorder = _shadowBorder;
}

- (void)setShadowRadius:(CGFloat)shadowRadius
{
    _shadowRadius = shadowRadius;
    self.shadowBadge = _shadowBadge;
    self.shadowText = _shadowText;
    self.shadowBorder = _shadowBorder;
}

- (void)setShadowText:(BOOL)shadowText
{
    _shadowText = shadowText;
    
    if (_shadowText) {
        _textLayer.shadowColor = _shadowColor.CGColor;
        _textLayer.shadowOffset = _shadowOffset;
        _textLayer.shadowRadius = _shadowRadius;
        _textLayer.shadowOpacity = 1.0;
    } else {
        _textLayer.shadowColor = nil;
        _textLayer.shadowOpacity = 0.0;
    }
}

- (void)setShadowBorder:(BOOL)shadowBorder
{
    _shadowBorder = shadowBorder;
    
    if (_shadowBorder) {
        _borderLayer.shadowColor = _shadowColor.CGColor;
        _borderLayer.shadowOffset = _shadowOffset;
        _borderLayer.shadowRadius = _shadowRadius;
        _borderLayer.shadowOpacity = 1.0;
    } else {
        _borderLayer.shadowColor = nil;
        _borderLayer.shadowOpacity = 0.0;
    }
}

- (void)setShadowBadge:(BOOL)shadowBadge
{
    _shadowBadge = shadowBadge;
    if (_shadowBadge) {
        _backgroundLayer.shadowColor = _shadowColor.CGColor;
        _backgroundLayer.shadowOffset = _shadowOffset;
        _backgroundLayer.shadowRadius = _shadowRadius;
        _backgroundLayer.shadowOpacity = 1.0;
    } else {
        _backgroundLayer.shadowColor = nil;
        _backgroundLayer.shadowOpacity = 0.0;
    }
}

#pragma mark - Private

- (void)hideForZeroIfNeeded{
    self.hidden = ([_text isEqualToString:@"0"] && _hidesWhenZero);
}


@end
