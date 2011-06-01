@import <KPUIKit/KPViewController.j>

@import "OrderlinesTableViewController.j"
@import "OrderStateValueTransformer.j"

@implementation OrderDetailViewController : KPViewController
{
    @outlet CPTextField                     _referenceLabel @accessors(property=referenceLabel, readonly);
    @outlet CPTextField                     _customerLabel @accessors(property=customerLabel, readonly);
    @outlet CPTextField                     _stateLabel @accessors(property=stateLabel, readonly);

    @outlet CPView                          _orderlinesContainer @accessors(property=orderlinesContainer, readonly);
    @outlet OrderlinesTableViewController   _orderlinesTableViewController @accessors(property=orderlinesTableViewController, readonly);

    @outlet CPButton                        _toggleButton @accessors(property=toggleButton);

    @outlet CPButton                        _previousButton @accessors(property=previousButton, readonly);
    @outlet CPButton                        _nextButton @accessors(property=nextButton, readonly);
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    var ordersArrayController = [[self windowController] ordersArrayController];

    [[self referenceLabel] bind:@"value" toObject:ordersArrayController withKeyPath:@"selection.reference" options:nil];
    [[self customerLabel] bind:@"value" toObject:ordersArrayController withKeyPath:@"selection.customerName" options:nil];
    [[self stateLabel] bind:@"value"
                   toObject:ordersArrayController
                withKeyPath:@"selection.state"
                    options:[CPDictionary dictionaryWithObjectsAndKeys:OrderStateValueTransformerName, "CPValueTransformerName"]];

    [[self previousButton] bind:@"enabled" toObject:ordersArrayController withKeyPath:@"canSelectPrevious" options:nil];
    [[self previousButton] setTarget:ordersArrayController];
    [[self previousButton] setAction:@selector(selectPrevious:)];

    [[self nextButton] bind:@"enabled" toObject:ordersArrayController withKeyPath:@"canSelectNext" options:nil];
    [[self nextButton] setTarget:ordersArrayController];
    [[self nextButton] setAction:@selector(selectNext:)];

    [[self toggleButton] bind:@"title" toObject:self withKeyPath:@"toggleButtonTitle" options:nil];

    [self placeViewController:[self orderlinesTableViewController] inView:[self orderlinesContainer]];
}

#pragma mark -
#pragma mark Accessors
+ (CPSet)keyPathsForValuesAffectingToggleButtonTitle
{
    // TODO: Figure out wether the full state key path shouldn't also account for the 
    // partial selection key path
    return [CPSet setWithArray:[@"windowController.ordersArrayController.selection",
                                @"windowController.ordersArrayController.selection.state"]];
}

- (CPString)toggleButtonTitle
{
    var ordersArrayController =  [[self windowController] ordersArrayController],
        selectedOrder = [[ordersArrayController selectedObjects] firstObject];

    if ([selectedOrder state] === OrderStateOpen)
        return @"Close";

    return @"Open";
}

- (CPString)cibName
{
    return @"OrderDetailView"
}

- (OrderlinesTableViewController)orderlinesTableViewController
{
    if (!_orderlinesTableViewController)
        _orderlinesTableViewController = [OrderlinesTableViewController viewControllerWithWindowController:[self windowController]];

    return _orderlinesTableViewController;
}

@end