// KPViewController.j
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

@import <AppKit/CPViewController.j>

@import "KPWindowController.j"
@import "KPViewPositioningManager.j"

/*!
    The KPViewController class is a subclass of <a href=http://cappuccino.org/learn/documentation/interface_c_p_view_controller.html>CPViewController</a>. KPViewController provides a unified method (KPViewController::placeViewController:inView:) for creating a view controller hiearchy and adding it to the responder chain.
*/
@implementation KPViewController : CPViewController
{
    KPWindowController          _windowController @accessors(property=windowController);

    CPArray                     _subcontrollers @accessors(property=subcontrollers);
    BOOL                        _isVisible @accessors(property=isVisible, readonly);
}

#pragma mark -
#pragma mark Initialization
/*!
    Convenience method for initWithWindowController:
    @param theWindowController The window controller this receiver belongs to
    @return An initialized instance of the receiver
    @see initWithWindowController:
*/
+ (id)viewControllerWithWindowController:(KPWindowController)theWindowController
{
    return [[self alloc] initWithWindowController:theWindowController];
}

/*!
    Initialize the receiver associating it with the window controller. The receiver
    will automatically be made part of the window controller's responder chain.
    This is the designated initializer.
    @param theWindowController The window controller this receiver belongs to
    @return An initialized instance of the receiver
    @see KPWindowController::patchResponderChain
*/
- (id)initWithWindowController:(KPWindowController)theWindowController
{
    return [self initWithCibName:[self cibName] bundle:[self cibBundle] windowController:theWindowController];
}

/*!
    @ignore
*/
- (id)initWithCibName:(CPString)theCibName bundle:(CPBundle)theBundle windowController:(KPWindowController)theWindowController
{
    if (self = [super initWithCibName:theCibName bundle:theBundle])
    {
        _windowController = theWindowController;
        _subcontrollers = [];

        _isVisible = NO;
    }
    return self;
}

/*!
    @ignore
*/
- (id)initWithCibName:(CPString)theCibName bundle:(CPBundle)theBundle
{
    [CPException raise:@"KPViewControllerException"
                reason:@"An instance of an KPViewController concrete subclass was initialized using the CPViewController method -initWithNibName:bundle: all view controllers in the enusing tree will have no reference to an KPWindowController object and cannot be automatically added to the responder chain"];

    return nil;
}

#pragma mark -
#pragma mark View lifetime
/*!
    @ignore
*/
- (void)_makeSubcontrollersPerformVisibilitySelector:(SEL)theSelector isVisible:(BOOL)shouldBeVisible
{
    var subcontrollers = [self subcontrollers];

    for (var i = 0; i < [[self subcontrollers] count]; i++)
    {
        var subcontroller = [subcontrollers objectAtIndex:i];

        if ([subcontroller isVisible] === shouldBeVisible)
            [subcontroller performSelector:theSelector];
    }
}

/*!
    Called after the receiver's view is loaded into memory.
*/
- (void)viewDidLoad
{
    // Overriden by subclasses
}

/*!
    Notifies the receiver that its view is about to become visible.
    Subclasses must always call super or the message might not propogate to subcontrollers.
*/
- (void)viewWillAppear
{
    [self _makeSubcontrollersPerformVisibilitySelector:_cmd isVisible:NO];
}

/*!
    Notifies the receiver that its view became visible.
    Subclasses must always call super or the message might not propogate to subcontrollers.
*/
- (void)viewDidAppear
{
    [self _makeSubcontrollersPerformVisibilitySelector:_cmd isVisible:NO];
    [self _setVisible:YES];
}

/*!
    Notifies the receiver that its view is about to become invisible.
    Subclasses must always call super or the message might not propogate to subcontrollers.
*/
- (void)viewWillDisappear
{
    [self _makeSubcontrollersPerformVisibilitySelector:_cmd isVisible:YES];
}

/*!
    Notifies the receiver that its view became invisible.
    Subclasses must always call super or the message might not propogate to subcontrollers.
*/
- (void)viewDidDisappear
{
    [self _makeSubcontrollersPerformVisibilitySelector:_cmd isVisible:YES];
    [self _setVisible:NO];
}

#pragma mark -
#pragma mark View placement
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
    if (!theView)
        [CPException raise:CPInternalInconsistencyException reason:@"KPViewController placeViewController:inView: view must not be nil"];

    var previousViewController = [self _controllerInView:theView];

    [previousViewController viewWillDisappear];
    [[previousViewController view] removeFromSuperview];
    [previousViewController viewDidDisappear];

    [self removeSubcontroller:previousViewController];

    if (!theViewController)
        return;

    if (![[self subcontrollers] containsObject:theViewController])
        [self addSubcontroller:theViewController];

    var subview = [theViewController view];
    [theViewController viewWillAppear];
    [[[self viewPositioningManagerClass] defaultManager] placeView:subview inView:theView];
    [theViewController viewDidAppear];
}

/*!
    @ignore
*/
- (KPViewController)_controllerInView:(CPView)theView
{
    var subcontrollerIndex = [[self subcontrollers] count];

    while (subcontrollerIndex--)
    {
        var subcontroller = [[self subcontrollers] objectAtIndex:subcontrollerIndex];
        if ([[subcontroller view] superview] === theView)
            return subcontroller;
    }

    return nil;
}

/*!
    @ignore
*/
- (void)_setVisible:(BOOL)isVisible
{
    _isVisible = !!isVisible;
}

// =============
// = Accessors =
// =============
/*!
    Simply returns a boolean value indicating wheter the receiver's view is loaded into memory.
    @returns YES if the receiver's view is loaded, otherwise NO
*/
- (BOOL)isViewLoaded
{
    // Use the instance variable here because [self view] will load the view if it isn't loaded
    return !!_view;
}

- (void)setWindowController:(KPWindowController)theWindowController
{
    if (_windowController === theWindowController)
        return;

    _windowController = theWindowController
    [[self subcontrollers] makeObjectsPerformSelector:@selector(setWindowController:) withObject:theWindowController];
    [[self windowController] patchResponderChain];
}

#pragma mark - 
#pragma mark Subcontrollers
/*!
    Sets the receiver's subcontrollers to the specified subcontrollers.
    @param theSubcontrollers An array of subcontrollers
*/
- (void)setSubcontrollers:(CPArray)theSubcontrollers
{
    if (_subcontrollers === theSubcontrollers)
        return;

    _subcontrollers = theSubcontrollers;
    [[self windowController] patchResponderChain];
}

/*!
    Adds a viewcontroller to the receiver's subcontrollers.
    @param theViewController The viewcontroller to add as the receiver's subcontroller
*/
- (void)addSubcontroller:(KPViewController)theViewController
{
    [_subcontrollers addObject:theViewController];
    [[self windowController] patchResponderChain];
}

/*!
    Removes a viewcontroller from the receiver's subcontrollers.
    @param theViewController The viewcontroller to remove as the receiver's subcontroller
*/
- (void)removeSubcontroller:(KPViewController)theViewController
{
    [_subcontrollers removeObject:theViewController];
    [[self windowController] patchResponderChain];
}

/*!
    Returns an array of the descendant viewcontrollers of the receiver.
    @return an array of descdendants
*/
- (CPArray)descendants
{
    var descendantsList = [];

    for (var i = 0; i < [[self subcontrollers] count]; i++)
    {
        var subViewController = [[self subcontrollers] objectAtIndex:i];

        [descendantsList addObject:subViewController];
        if ([[subViewController subcontrollers] count] > 0)
            [descendantsList addObjectsFromArray:[subViewController descendants]];
    }

    return descendantsList;
}

@end
