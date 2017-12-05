//
//  PreferencesStore.h
//  DisplaySwitcher
//
//  Created by ljb on 6/12/17.
//  Copyright © 2017 ljb. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MASShortcut/Shortcut.h>
extern NSString *const kDSPreferencesMoveToNextDisplayShortcut;
extern NSString *const kDSPreferencesMoveToNextDisplayTitle;
typedef void(^ShortchutPerferenceChangeCallback)(void);

@interface PreferencesStore : NSObject
+ (PreferencesStore*)instance;
+ (NSString*) shortcutTransfermerName;
- (MASShortcut*)getShortcutForMoveToNextDisplay;
- (void)setShortcutForMoveToNextDisplay:(MASShortcut*)shortcut;

- (void)registerMoveCursorToNextDisplayShortcutWithAction:(dispatch_block_t) action;
- (void)breakMoveCursorToNextDisplayShortcut;

- (void)registerPreferencesOfMoveCursorToNextDisplayShortcutWithCallback:(ShortchutPerferenceChangeCallback) callback;
- (void)unregisterPreferencesCallbackOfMoveCursorToNextDisplayShortcut;

@end
