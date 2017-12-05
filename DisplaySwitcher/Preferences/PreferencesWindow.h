//
//  Preference.h
//  DisplaySwitcher
//
//  Created by ljb on 5/12/17.
//  Copyright © 2017 ljb. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AppKit/AppKit.h>

@interface PreferencesWindow : NSObject{
    NSWindowController *_preferencesWindowController;
}
@property (nonatomic, readonly) NSWindowController *preferencesWindowController;
- (void) openPreferencesWindow;
@end
