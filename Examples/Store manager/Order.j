@import <Foundation/CPObject.j>

@import "Product.j"

OrderStateOpen = @"OrderStateOpen";
OrderStateClosed = @"OrderStateClosed";

@implementation Order : CPObject
{
    CPString                            _reference @accessors(property=reference);
    CPString                            _customerName @accessors(property=customerName);

    CPArray                             _lines @accessors(property=lines);

    OrderState                          _state @accessors(property=state);
}

+ (id)orderWithReference:(CPString)theReference customerName:(CPString)theName
{
    return [[self alloc] initWithReference:theReference customerName:theName];
}

- (id)initWithReference:(CPString)theReference customerName:(CPString)theName
{
    if (self = [super init])
    {
        _reference = theReference;
        _customerName = theName;
        _state = OrderStateOpen;
    }

    return self;
}

- (CPArray)lines
{
    if (!_lines) {
        _lines = [
            [_Orderline lineWithName:@"Hercules" brand:@"Li Kea" price:[CPDecimalNumber decimalNumberWithString:@"750"] quantity:1],
            [_Orderline lineWithName:@"Fiddy" brand:@"EgoWatch" price:[CPDecimalNumber decimalNumberWithString:@"99"] quantity:1],
            [_Orderline lineWithName:@"HDJ2000" brand:@"HDJ" price:[CPDecimalNumber decimalNumberWithString:@"29.08"] quantity:1],
            [_Orderline lineWithName:@"Malibu" brand:@"Gosjie" price:[CPDecimalNumber decimalNumberWithString:@"89.99"] quantity:1]
        ]
    }

    return _lines;
}

@end

@implementation _Orderline : Product
{
    int                 _quantity @accessors(property=quantity);
}

+ (id)lineWithName:(CPString)theName brand:(CPString)theBrand price:(CPDecimalNumber)thePrice quantity:(int)theQuantity
{
    return [[self alloc] initWithName:theName brand:theBrand price:thePrice quantity:theQuantity];
}

- (id)initWithName:(CPString)theName brand:(CPString)theBrand price:(CPDecimalNumber)thePrice quantity:theQuantity
{
    if (self = [super initWithName:theName brand:theBrand price:thePrice])
    {
        _quantity = theQuantity;
    }

    return self;
}

@end