// KPViewPositioningManager.j
// View Controllers
//
// Created by Klaas Pieter Annema on 19/02/2010.
// Copyright (c) 2010 Klaas Pieter Annema
//
// Permission is hereby granted, free of charge, to any person
// obtaining a copy of this software and associated documentation
// files (the "Software"), to deal in the Software without
// restriction, including without limitation the rights to use,
// copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the
// Software is furnished to do so, subject to the following
// conditions:
//
// The above copyright notice and this permission notice shall be
// included in all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
// EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
// OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
// NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
// HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
// WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
// FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
// OTHER DEALINGS IN THE SOFTWARE.

@import <Foundation/CPObject.j>

var KPViewPositioningManagerInstance = nil;

/*!
    KPViewPositioningManager is a helper class providing often used view placement code.
*/
@implementation KPViewPositioningManager : CPObject
{
}

/*!
    Returns the singleton instance of the positioning manager.
    @return The default positioning manager.
*/
+ (id)defaultManager
{
    if (!KPViewPositioningManagerInstance)
        KPViewPositioningManagerInstance = [[self alloc] init];

    return KPViewPositioningManagerInstance;
}

/*!
    Places a view inside another view with no inset.
    @param theSubview the view to be placed inside theSuperview
    @param theSuperview the view theSubview will be added to
    @see placeView:inView:inset:
*/
- (void)placeView:(CPView)theSubview inView:(CPView)theSuperview
{
    [self placeView:theSubview inView:theSuperview inset:CGInsetMakeZero()];
}

/*!
    Places a view inside another view with the specified inset. Will throw an exception if any of the views are nil or
    if the views are equal.
    @param theSubview the view to be placed inside theSuperview, theSubview may not be nil.
    @param theSuperview the view theSubview is added to, theSuperview may not be nil.
    @param theInset the inset of theSubview relative to theSuperview's bounds
*/
- (void)placeView:(CPView)theSubview inView:(CPView)theSuperview inset:(CGInset)theInset
{
    if (!theSuperview)
        [CPException raise:CPInternalInconsistencyException reason:@"KPViewPositioningManager placeView:inView: superview must not be nil"];

    if (!theSubview)
        [CPException raise:CPInternalInconsistencyException reason:@"KPViewPositioningManager placeView:inView: subview must not be nil"];

    if (theSubview === theSuperview)
        [CPException raise:CPInternalInconsistencyException reason:@"KPViewPositioningManager placeView:inView: subview must not be equal to superview"];

    var bounds = [theSuperview bounds];

    bounds.origin.x += theInset.left;
    bounds.origin.y += theInset.top;
    bounds.size.width -= theInset.left + theInset.right;
    bounds.size.height -= theInset.top + theInset.bottom;

    [theSubview setFrame:bounds];
    [theSuperview addSubview:theSubview];
}

/*!
    Places a view in the center of another view.
    @param theSubview the view to be placed in the center
    @param theSuperview the view theSubview is added to
*/
- (void)placeView:(CPView)theSubview inCenterOfView:(CPView)theSuperview
{
    var bounds = [theSuperview bounds],
        frame = [theSubview frame];

    frame.origin.x = CGRectGetMidX(bounds) - (CGRectGetWidth(frame) / 2.0);
    frame.origin.y = CGRectGetMidY(bounds) - (CGRectGetHeight(frame) / 2.0);

    [theSubview setFrame:frame];
    [theSuperview addSubview:theSubview];
}

/*!
    Places a view left of another view with no offset.
    @param theLeftView The view that is placed relative to theRightView
    @param theRightView The view theLeftView is placed relative to
    @see placeView:leftOfView:offset:
*/
- (void)placeView:(CPView)theLeftView leftOfView:(CPView)theRightView
{
    [self placeView:theLeftView leftOfView:theRightView offset:CGPointMakeZero()];
}

/*!
    Places a view left of another view at the specified offset.
    @param theLeftView The view that is placed relative to theRightView
    @param theRightView The view theLeftView is placed relative to
    @param theOffset The offset of theLeftView relative to theRightView
*/
- (void)placeView:(CPView)theLeftView leftOfView:(CPView)theRightView offset:(CGPoint)theOffset
{
    if ([theRightView superview] && [theLeftView superview] && [theLeftView superview] !== [theRightView superview])
        CPLog.warn(@"%@ the views do not have the same superview", CPStringFromSelector(_cmd));

    var leftFrame = [theLeftView frame],
        rightFrame = [theRightView frame];

    leftFrame.origin.x = CGRectGetMinX(rightFrame) - CGRectGetWidth(leftFrame) + theOffset.x;
    leftFrame.origin.y = CGRectGetMinY(rightFrame) + theOffset.y;
    [theLeftView setFrame:leftFrame];
}

/*!
    Places a view right of another view with no offset.
    @param theRightView The view that is placed relative to theLeftView
    @param theLeftView The view theRightView is placed relative to
    @see placeView:rightOfView:offset:
*/
- (void)placeView:(CPView)theRightView rightOfView:(CPView)theLeftView
{
    [self placeView:theRightView rightOfView:theLeftView offset:CPPointMakeZero()];
}

/*!
    Places a view right of another view at the specified offset.
    @param theRightView The view that is placed relative to theLeftView
    @param theLeftView The view theRightView is placed relative to
    @param theOffset The offset of theRightView relative to theLeftView
*/
- (void)placeView:(CPView)theRightView rightOfView:(CPView)theLeftView offset:(CPPoint)theOffset
{
    if ([theRightView superview] && [theLeftView superview] && [theLeftView superview] !== [theRightView superview])
        CPLog.warn(@"%@ the views do not have the same superview", CPStringFromSelector(_cmd));

    var leftFrame = [theLeftView frame],
        rightFrame = [theRightView frame];

    rightFrame.origin.x = CPRectGetMaxX(leftFrame) + theOffset.x;
    rightFrame.origin.y = CPRectGetMinY(leftFrame) + theOffset.y;
    [theRightView setFrame:rightFrame];
}

/*!
    Places a view below another view with no offset.
    @param theBelowView The view that is placed relative to theAboveView
    @param theAboveView The view theBelowView is placed relative to
    @param theOffset The offset of theBelowView relative to theAboveView
*/
- (void)placeView:(CPView)theBelowView belowView:(CPView)theAboveView
{
    [self placeView:theBelowView belowView:theAboveView offset:CPPointMakeZero()];
}

/*!
    Places a view below another view at the specified offset.
    @param theBelowView The view to place below the other view
    @param theAboveView The view to place the below view relative of
    @param theOffset The offset of the below relative to the above view
*/
- (void)placeView:(CPView)theBelowView belowView:(CPView)theAboveView offset:(CPPoint)theOffset
{
    if ([theBelowView superview] && [theAboveView superview] && [theBelowView superview] !== [theAboveView superview])
        CPLog.warn(@"%@ the views do not have the same superview", CPStringFromSelector(_cmd));

    var aboveFrame = [theAboveView frame],
        belowFrame = [theBelowView frame];

    belowFrame.origin.x = CPRectGetMinX(aboveFrame) + theOffset.x;
    belowFrame.origin.y = CPRectGetMaxY(aboveFrame) + theOffset.y;
    [theBelowView setFrame:belowFrame];
}


@end
