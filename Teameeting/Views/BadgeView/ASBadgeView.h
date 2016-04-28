//
//  ASBadgeView.h
//  MyASASPD
//
//  Created by work on 15/3/3.
//  Copyright (c) 2015年 work. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    ASBadgeViewHorizontalAlignmentNone,
    ASBadgeViewHorizontalAlignmentLeft,
    ASBadgeViewHorizontalAlignmentCenter,
    ASBadgeViewHorizontalAlignmentRight
} ASBadgeViewHorizontalAlignment;

typedef enum {
    ASBadgeViewVerticalAlignmentNone,
    ASBadgeViewVerticalAlignmentTop,
    ASBadgeViewVerticalAlignmentMiddle,
    ASBadgeViewVerticalAlignmentBottom
} ASBadgeViewVerticalAlignment;

@interface ASBadgeView : UIView

/**@name Text*/
/**The text to display in the badge.*/
@property (nonatomic, retain) NSString *text;
/**The color of the text.*/
@property (nonatomic, retain) UIColor *textColor;
/**The font of the text.*/
@property (nonatomic, retain) UIFont *font;
/**The distance to shift the text by when the horizontal/vertical alignment is set. This is for fine tune adjustments.*/
@property (nonatomic, assign) CGSize textAlignmentShift;
/**Wether or not to align the text so that it is pixel perfect. Default is YES.
 @note If the text is aligned, it will be centered, and the position rounded to the nearest perfect pixel.*/
@property (nonatomic, assign) BOOL pixelPerfectText;

/**@name Badge*/
/**The background color of the badge.*/
@property (nonatomic, retain) UIColor *badgeBackgroundColor;
/**Wether or not the badge has a glossy overlay.*/
@property (nonatomic, assign) BOOL showGloss;
/**The corner radius of the badge.
 @note This will be set automatically unless manually set.*/
@property (nonatomic, assign) CGFloat cornerRadius;
/**The horizontal alignment of the badge.
 @note If set to none, one can set the origin.x value arbitrarily, otherwise it will be set automatically.*/
@property (nonatomic, assign) ASBadgeViewHorizontalAlignment horizontalAlignment;
/**The vertical alignment of the badge.
 @note If set to none, one can set the origin.y value arbitrarily, otherwise it will be set automatically.*/
@property (nonatomic, assign) ASBadgeViewVerticalAlignment verticalAlignment;
/**The distance to shift the badge by when the horizontal/vertical alignment is set. This is for fine tune adjustments.*/
@property (nonatomic, assign) CGSize alignmentShift;
/**Wether or not changes in frame size are animated.*/
@property (nonatomic, assign) BOOL animateChanges;
/**The duration of animations.*/
@property (nonatomic, assign) CGFloat animationDuration;
/**The minimum width of the badge.
 @note This setting only has an effect if it is larger than the height of the badge. The minimum shape will otherwise always be a circle.*/
@property (nonatomic, assign) CGFloat minimumWidth;
/**The maximum width of the badge.
 @note This setting only has an effect if it is larger than the height of the badge. If the size of the badge exceeds this size, the text will be truncated and "..." will be tacked onto the end of the string.*/
@property (nonatomic, assign) CGFloat maximumWidth;
/**The badge will be hidden if the text's value is equal to 0.*/
@property (nonatomic, assign) BOOL hidesWhenZero;

/**@name Border*/
/**The width of the border. If set to zero, no border will be shown.*/
@property (nonatomic, assign) CGFloat borderWidth;
/**The color of the border if shown.*/
@property (nonatomic, retain) UIColor *borderColor;

/**@name Shadow*/
/**The color of the shadow.*/
@property (nonatomic, retain) UIColor *shadowColor;
/**The offset of the shadow.*/
@property (nonatomic, assign) CGSize shadowOffset;
/**The radius of the shadow.*/
@property (nonatomic, assign) CGFloat shadowRadius;
/**Wether or not the text has a shadow.*/
@property (nonatomic, assign) BOOL shadowText;
/**Wether or not the border has a shadow.*/
@property (nonatomic, assign) BOOL shadowBorder;
/**Wether or not the badge has a shadow.*/
@property (nonatomic, assign) BOOL shadowBadge;

@end
