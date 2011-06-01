@import <KPUIKit/KPViewController.j>

@import "Order.j"

@implementation OrderTableViewController : KPViewController
{
    @outlet CPTableView                         _ordersTableView @accessors(property=ordersTableView, readonly);

    @outlet CPMenu                              _contextMenu @accessors(property=contextMenu, readonly);
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // The tableview is somehow disabled so, for now, we manually set it to enabled
    [[self ordersTableView] setEnabled:YES];

    var ordersArrayController = [[self windowController] ordersArrayController];
    [[self ordersTableView] bind:@"content" toObject:ordersArrayController withKeyPath:@"arrangedObjects" options:nil];

    var referenceColumn = [[self ordersTableView] tableColumnWithIdentifier:@"reference"];
    [referenceColumn bind:@"value" toObject:ordersArrayController withKeyPath:@"arrangedObjects.reference" options:nil];

    var customerColumn = [[self ordersTableView] tableColumnWithIdentifier:@"customer"];
    [customerColumn bind:@"value" toObject:ordersArrayController withKeyPath:@"arrangedObjects.customerName" options:nil];
}

#pragma mark -
#pragma mark CPTableViewDelegate
- (CPMenu)tableView:(CPTableView)theTableView menuForTableColumn:(CPTableColumn)theTableColumn row:(int)theRow
{
    if (theRow === -1)
        return nil;

    [theTableView selectRowIndexes:[CPIndexSet indexSetWithIndex:theRow] byExtendingSelection:NO];

    return [self contextMenu];
}

#pragma mark -
#pragma mark Accessors
- (CPString)cibName
{
    return @"OrderTableView";
}

@end