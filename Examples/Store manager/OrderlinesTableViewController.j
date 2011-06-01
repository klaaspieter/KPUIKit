@import <KPUIKit/KPViewController.j>

@implementation OrderlinesTableViewController : KPViewController
{
    @outlet CPTableView                     _orderlinesTableView @accessors(property=orderlinesTableView, readonly);
    CPArrayController                       _orderlinesArrayController @accessors(property=orderlinesArrayController, readonly);
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    var ordersArrayController = [[self windowController] ordersArrayController];
    [[self orderlinesArrayController] bind:@"content" toObject:ordersArrayController withKeyPath:@"selection.lines" options:nil];

    [[self orderlinesTableView] bind:@"content" toObject:[self orderlinesArrayController] withKeyPath:@"arrangedObjects" options:nil];

    var quantityColumn = [[self orderlinesTableView] tableColumnWithIdentifier:@"quantity"];
    [quantityColumn bind:@"value" toObject:[self orderlinesArrayController] withKeyPath:@"arrangedObjects.quantity" options:nil];

    var nameColumn = [[self orderlinesTableView] tableColumnWithIdentifier:@"name"];
    [nameColumn bind:@"value" toObject:[self orderlinesArrayController] withKeyPath:@"arrangedObjects.name" options:nil];

    var brandColumn = [[self orderlinesTableView] tableColumnWithIdentifier:@"brand"];
    [brandColumn bind:@"value" toObject:[self orderlinesArrayController] withKeyPath:@"arrangedObjects.brand" options:nil];

    var priceColumn = [[self orderlinesTableView] tableColumnWithIdentifier:@"price"];
    [priceColumn bind:@"value" toObject:[self orderlinesArrayController] withKeyPath:@"arrangedObjects.price" options:nil];
}

- (CPString)cibName
{
    return @"OrderlinesTableView"
}

- (CPArrayController)orderlinesArrayController
{
    if (!_orderlinesArrayController)
        _orderlinesArrayController = [[CPArrayController alloc] initWithContent:[]];

    return _orderlinesArrayController;
}

@end