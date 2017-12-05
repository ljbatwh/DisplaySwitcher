//
// This is a sample General preference pane
//

#import <MASPreferences/MASPreferences.h>
#import <MASShortcut/Shortcut.h>

@interface GeneralPreferencesViewController : NSViewController <MASPreferencesViewController>
@property (weak) IBOutlet NSTextField *textMoveCurorToNextDisplay;
@property (weak) IBOutlet MASShortcutView *shortcutView;
@end
