//
//  NUIBarButtonItemRenderer.m
//  NUIDemo
//
//  Created by Tom Benner on 11/24/12.
//  Copyright (c) 2012 Tom Benner. All rights reserved.
//

#import "NUIBarButtonItemRenderer.h"

@implementation NUIBarButtonItemRenderer

+ (void)render:(UIBarButtonItem*)item withClass:(NSString*)className
{
    
    if ([NUISettings hasProperty:@"background-image" withClass:className]) {
        [item setBackgroundImage:[NUISettings getImage:@"background-image" withClass:className] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    } else if ([NUISettings hasProperty:@"background-tint-color" withClass:className]) {
        [item setTintColor:[NUISettings getColor:@"background-tint-color" withClass:className]];
    } else if ([NUISettings hasProperty:@"background-color" withClass:className] ||
               [NUISettings hasProperty:@"background-color-top" withClass:className]) {
        CALayer *layer = [CALayer layer];
        [layer setFrame:CGRectMake(0, 0, 30, 26)];
        [layer setMasksToBounds:YES];
        
        if ([NUISettings hasProperty:@"background-color-top" withClass:className]) {
            CAGradientLayer *gradientLayer = [NUIGraphics
                                              gradientLayerWithTop:[NUISettings getColor:@"background-color-top" withClass:className]
                                              bottom:[NUISettings getColor:@"background-color-bottom" withClass:className]
                                              frame:layer.frame];
            int backgroundLayerIndex = 0;
            if (item.nuiIsApplied) {
                [[layer.sublayers objectAtIndex:backgroundLayerIndex] removeFromSuperlayer];
            }
            [layer insertSublayer:gradientLayer atIndex:backgroundLayerIndex];
        }
        
        if ([NUISettings hasProperty:@"background-color" withClass:className]) {
            [layer setBackgroundColor:[[NUISettings getColor:@"background-color" withClass:className] CGColor]];
        }
        
        if ([NUISettings hasProperty:@"border-color" withClass:className]) {
            [layer setBorderColor:[[NUISettings getColor:@"border-color" withClass:className] CGColor]];
        }
        
        if ([NUISettings hasProperty:@"border-width" withClass:className]) {
            [layer setBorderWidth:[NUISettings getFloat:@"border-width" withClass:className]];
        }
        
        float cornerRadius = [NUISettings getFloat:@"corner-radius" withClass:className];
        float insetLength = cornerRadius;
        
        if (cornerRadius < 5) {
            insetLength = 5;
        }
        insetLength += 3;
        
        if ([NUISettings hasProperty:@"corner-radius" withClass:className]) {
            [layer setCornerRadius:[NUISettings getFloat:@"corner-radius" withClass:className]];
        }
        
        UIImage *image = [NUIGraphics caLayerToUIImage:layer];
        image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(0, insetLength, 0, insetLength) resizingMode:UIImageResizingModeStretch];
        
        [item setBackgroundImage:image forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    }
    
    NSDictionary *titleTextAttributes = [NUIUtilities titleTextAttributesForClass:className];
    
    if ([[titleTextAttributes allKeys] count] > 0) {
        [item setTitleTextAttributes:titleTextAttributes forState:UIControlStateNormal];
    }
    
}

@end
