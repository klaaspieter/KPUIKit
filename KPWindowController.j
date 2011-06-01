// KPWindowController.j
// View Controllers
//
// Created by Klaas Pieter Annema on 19/02/2010.
// Inspired by KTUIKit created by Cathy Shive and Jonathan Dann
//
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

@import <AppKit/CPWindowController.j>

@import "KPViewController.j"
@import "KPViewPositioningManager.j"

/*!
    The KPWindowController class is a subclass of <a href="http://cappuccino.org/learn/documentation/interface_c_p_window_controller.html">CPWindowController</a>. KPWindowController provides a unified method for creating a view controller hierarchy which is placed in the responder chain directly after the window controller.
*/
@implementation KPWindowController : CPWindowController
{
    CPArray                     _viewControllers @accessors(property=viewControllers);
}

#pragma mark -
#pragma mark Initialiation
/*!
    @ignore
*/
- (id)initWithWindow:(CPWindow)theWindow
{
    if (self = [super initWithWindow:theWindow])
    {
        _viewControllers = [];
    }

    return self;
}

#pragma mark -
#pragma mark View positioning
/*!
    Can be overriden in subclasses to return a different view positioning manager class to initialize
    @return The view positioning manager class the receiver should use
*/
- (Class)viewPositioningManagerClass
{
    return [KPViewPositioningManager class];
}

/*!
    Add the viewcontroller as a subcontroller of the receiver and place the viewcontroller's view
    in the container view. If the view already contains a subcontroller of the receiver the subcontroller is removed.
    Internally uses an instance of KPViewPositioningManager to place the subcontroller's view into the container view.
    Override +viewPositioningManagerClass to override the class the receiver should use.
    @param theViewController The view controller to add as a subcontroller of the receiver
    @param theView The view the subcontroller's view is added to
*/
- (void)placeViewController:(KPViewController)theViewController inView:(CPView)theView;
{
    var previousViewController = [self _viewControllerInView:theView];

    [previousViewController viewWillDisappear];
    [[previousViewController view] removeFromSuperview];
    [previousViewController viewDidDisappear];

    if (![[self viewControllers] containsObject:theViewController])
        [self addViewController:theViewController];

    var subview = [theViewController view];
    [theViewController viewWillAppear];
    [[[self viewPositioningManagerClass] defaultManager] placeView:subview inView:theView];
    [theViewController viewDidAppear];
}

/*!
    @ignore
*/
- (void)showWindow:(id)theSender
{
    var viewControllers = [self viewControllers];
    for (var i = 0; i < [viewControllers count]; i++)
        [[viewControllers objectAtIndex:i] viewWillAppear];

    [super showWindow:theSender];

    var viewControllers = [self viewControllers];
    for (var i = 0; i < [viewControllers count]; i++)
        [[viewControllers objectAtIndex:i] viewDidAppear];
}

/*!
    @ignore
*/
- (void)close
{
    var viewControllers = [self viewControllers];
    for (var i = 0; i < [viewControllers count]; i++)
        [[viewControllers objectAtIndex:i] viewWillDisappear];

    [super close];

    var viewControllers = [self viewControllers];
    for (var i = 0; i < [viewControllers count]; i++)
        [[viewControllers objectAtIndex:i] viewDidDisappear];
}

#pragma mark -
#pragma mark Viewcontrollers
/*!
    Adds a viewcontroller to the receiver's viewcontrollers.
    @param theViewController The viewcontroller to add as the receiver's viewcontrollers
*/
- (void)addViewController:(KPViewController)theViewController
{
    [_viewControllers addObject:theViewController];
    [self patchResponderChain];
}

/*!
    Removes a viewcontroller from the receiver's viewcontrollers.
    @param theViewController The viewcontroller to remove as the receiver's viewcontrollers
*/
- (void)removeViewController:(KPViewController)theViewController
{
    [_viewControllers removeObject:theViewController];
    [self patchResponderChain];
}

/*!
    Removes all viewcontrollers from the receiver
*/
- (void)removeAllViewControllers
{
    [_viewControllers removeAllObjects];
}

/*!
    @ignore
*/
- (KPViewController)_viewControllerInView:(CPView)theView
{
    var subcontrollerIndex = [[self viewControllers] count];

    while (subcontrollerIndex--)
    {
        var subcontroller = [[self viewControllers] objectAtIndex:subcontrollerIndex];
        if ([[subcontroller view] superview] === theView)
            return subcontroller;
    }

    return nil;
}

/*!
    Places all the receiver's viewcontrollers and their descendants in the responder chain after the receiver.
*/
- (void)patchResponderChain
{
    var flatViewControllerList = [];

    for (var i = 0; i < [_viewControllers count]; i++)
    {
        var viewController = [_viewControllers objectAtIndex:i];

        [flatViewControllerList addObject:viewController];
        [flatViewControllerList addObjectsFromArray:[viewController descendants]];
    }

    if ([flatViewControllerList count] > 0)
    {
        [self setNextResponder:[flatViewControllerList objectAtIndex:0]]

        for (var i = 0; i < [flatViewControllerList count] - 1; i++)
            [[flatViewControllerList objectAtIndex:i] setNextResponder:[flatViewControllerList objectAtIndex:i + 1]];

        [[flatViewControllerList lastObject] setNextResponder:nil];
    }
}

@end