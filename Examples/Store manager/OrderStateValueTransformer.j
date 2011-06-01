@import <Foundation/CPValueTransformer.j>

@import "Order.j"

OrderStateValueTransformerName = @"OrderStateValueTransformer";

@implementation OrderStateValueTransformer : CPValueTransformer
{
}

+ (BOOL)allowsReverseTransformation
{
    return NO;
}

+ (Class)transformedValueClass
{
    return [CPString class];
}

- (id)transformedValue:(id)theValue
{
    if (theValue === OrderStateOpen)
        return @"Open";

    return @"Closed";
}

@end