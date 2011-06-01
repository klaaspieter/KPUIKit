@import <KPUIKit/KPWindowController.j>

@import "OrdersViewController.j"

@implementation MainWindowController : KPWindowController
{
    CPArrayController                   _ordersArrayController @accessors(property=ordersArrayController, readonly);

    CPView                              _contentView @accessors(property=contentView, readonly);
    OrdersViewController                _ordersViewController @accessors(property=ordersViewController, readonly);

    @outlet CPButton                    _ordersButton @accessors(property=ordersButton, readonly);
}

- (void)windowDidLoad
{
    [super windowDidLoad];

    [self placeViewController:[self ordersViewController] inView:[self contentView]];

    // For now we hardcode these
    [[self ordersButton] setBackgroundColor:[CPColor colorWithRed:95.0 / 255.0 green:131.0 / 255.0 blue:185.0 / 255.0 alpha:1.0]];
    [[self ordersButton] setValue:[CPColor whiteColor] forThemeAttribute:@"text-color"];

    [[self window] setFullPlatformWindow:YES];
}

- (CPArrayController)ordersArrayController
{
    if (!_ordersArrayController)
    {
        var orders = [
            [Order orderWithReference:@"TEST1" customerName:@"Klaas Pieter Annema"],
            [Order orderWithReference:@"TEST2" customerName:@"Francisco Tolmasky"],
            [Order orderWithReference:@"WHAT1" customerName:@"Jorn van Dijk"],
            [Order orderWithReference:@"MEHS5" customerName:@"Koen Bok"]
        ];

        _ordersArrayController = [[CPArrayController alloc] initWithContent:orders];
        [_ordersArrayController setSelectionIndex:0];
        [_ordersArrayController setAvoidsEmptySelection:YES];
    }

    return _ordersArrayController;
}

- (OrdersViewController)ordersViewController
{
    if (!_ordersViewController)
        _ordersViewController = [OrdersViewController viewControllerWithWindowController:self];

    return _ordersViewController;
}

@end