/*
 * AppController.j
 * order-management
 *
 * Created by You on May 31, 2011.
 * Copyright 2011, Your Company All rights reserved.
 */

@import <Foundation/CPObject.j>

@import "MainWindowController.j"

@implementation AppController : CPObject
{
    MainWindowController                            mMainWindowController;
}

- (void)applicationDidFinishLaunching:(CPNotification)aNotification
{
    mMainWindowController = [[MainWindowController alloc] initWithWindowCibName:@"MainWindow"];
    [mMainWindowController showWindow:self];
}

- (void)setValue:(id)theValue forUndefinedKey:(CPString)theKey
{
    debugger;
}

@end
