@import <Foundation/CPObject.j>

@implementation Product : CPObject
{
    CPString                        _name @accessors(property=name);
    CPString                        _brand @accessors(property=brand);

    CPDecimalNumber                 _price @accessors(property=price);
}

+ (id)productWithName:(CPString)theName brand:(CPString)theBrand price:(CPDecimalNumber)thePrice
{
    return [[self alloc] initWithName:theName brand:theBrand price:thePrice];
}

- (id)initWithName:(CPString)theName brand:(CPString)theBrand price:(CPDecimalNumber)thePrice
{
    if (self = [super init])
    {
        _name = theName;
        _brand = theBrand;
        _price = thePrice;
    }

    return self;
}

@end