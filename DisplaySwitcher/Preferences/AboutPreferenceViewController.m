//
//  AboutPreferenceViewController.m
//  DisplaySwitcher
//
//  Created by ljb on 5/12/17.
//  Copyright © 2017 ljb. All rights reserved.
//

#import "AboutPreferenceViewController.h"
@implementation AboutPreferencesViewController

- (id)init
{
    return [super initWithNibName:@"AboutPreferenceView" bundle:nil];
}

#pragma mark - MASPreferencesViewController

- (NSString *)viewIdentifier
{
    return @"AboutPreferences";
}

- (NSImage *)toolbarItemImage
{
    return [NSImage imageNamed:NSImageNameInfo];
}

- (NSString *)toolbarItemLabel
{
    return NSLocalizedString(@"About", @"Toolbar item name for the About preference pane");
}

@end
