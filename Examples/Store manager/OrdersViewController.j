@import <KPUIKit/KPViewController.j>

@import "OrderTableViewController.j"
@import "OrderDetailViewController.j"

@import "Order.j"

@implementation OrdersViewController : KPViewController
{
    @outlet CPView                      _orderTableViewContainer @accessors(property=orderTableViewContainer, readonly);
    OrderTableViewController            _orderTableViewController @accessors(property=orderTableViewController, readonly);

    @outlet CPView                      _orderDetailViewContainer @accessors(property=orderDetailViewContainer, readonly);
    OrderDetailViewController           _orderDetailViewController @accessors(property=orderDetailViewController, readonly);
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self placeViewController:[self orderTableViewController] inView:[self orderTableViewContainer]];
    [self placeViewController:[self orderDetailViewController] inView:[self orderDetailViewContainer]];
}

#pragma mark -
#pragma mark CPMenuValidation
- (void)validateMenuItem:(CPMenuItem)theMenuItem
{
    if ([theMenuItem action] === @selector(toggleSelectedOrderState:))
    {
        var selectedOrder = [[[[self windowController] ordersArrayController] selectedObjects] firstObject];

        if (!selectedOrder)
            return NO;

        if ([selectedOrder state] === OrderStateOpen)
            [theMenuItem setTitle:@"Close"];
        else
            [theMenuItem setTitle:@"Open"];
    }

    return YES;
}

#pragma mark -
#pragma mark Actions
- (@action)toggleSelectedOrderState:(id)theSender
{
    var selectedOrder = [[[[self windowController] ordersArrayController] selectedObjects] firstObject];
    [selectedOrder setState:[selectedOrder state] === OrderStateOpen ? OrderStateClosed : OrderStateOpen];
}

#pragma mark -
#pragma mark Accessors
- (CPString)cibName
{
    return @"OrdersView";
}

- (OrderTableViewController)orderTableViewController
{
    if (!_orderTableViewController)
        _orderTableViewController = [OrderTableViewController viewControllerWithWindowController:[self windowController]];

    return _orderTableViewController;
}

- (OrderDetailViewController)orderDetailViewController
{
    if (!_orderDetailViewController)
        _orderDetailViewController = [OrderDetailViewController viewControllerWithWindowController:[self windowController]];

    return _orderDetailViewController;
}

@end