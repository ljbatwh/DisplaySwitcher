//
//  Preference.m
//  DisplaySwitcher
//
//  Created by ljb on 5/12/17.
//  Copyright © 2017 ljb. All rights reserved.
//

#import "PreferencesWindow.h"
#import "GeneralPreferencesViewController.h"
#import "AboutPreferenceViewController.h"
#import "MASPreferencesWindowController.h"

@implementation PreferencesWindow


- (NSWindowController *)preferencesWindowController
{
    if (_preferencesWindowController == nil)
    {
        NSViewController *generalViewController = [[GeneralPreferencesViewController alloc] init];
        
        NSViewController *aboutViewController = [[AboutPreferencesViewController alloc] init];
        NSArray *controllers = [[NSArray alloc] initWithObjects:generalViewController,  [NSNull null],aboutViewController, nil];
        
        // To add a flexible space between General and Advanced preference panes insert [NSNull null]:
        //NSArray *controllers = [[NSArray alloc] initWithObjects:generalViewController, [NSNull null], advancedViewController, nil];
        
        NSString *title = NSLocalizedString(@"Preferences", @"Common title for Preferences window");
        _preferencesWindowController = [[MASPreferencesWindowController alloc] initWithViewControllers:controllers title:title];
    }
    return _preferencesWindowController;
}


- (void) openPreferencesWindow
{
    [self.preferencesWindowController showWindow:nil];
    [NSApp activateIgnoringOtherApps:YES];
}

@end
