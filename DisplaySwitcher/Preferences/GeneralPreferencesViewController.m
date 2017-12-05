
#import "GeneralPreferencesViewController.h"
#import "PreferencesStore.h"

@implementation GeneralPreferencesViewController


- (id)init
{
    return [super initWithNibName:@"GeneralPreferencesView" bundle:nil];
}

- (void)viewDidLoad{
    [self.shortcutView setAssociatedUserDefaultsKey:kDSPreferencesMoveToNextDisplayShortcut withTransformerName:[PreferencesStore shortcutTransfermerName ]];
    [self.textMoveCurorToNextDisplay setStringValue:kDSPreferencesMoveToNextDisplayTitle];
}
#pragma mark - MASPreferencesViewController

- (NSString *)viewIdentifier
{
    return @"GeneralPreferences";
}

- (NSImage *)toolbarItemImage
{
    return [NSImage imageNamed:NSImageNamePreferencesGeneral];
}

- (NSString *)toolbarItemLabel
{
    return NSLocalizedString(@"General", @"Toolbar item name for the General preference pane");
}

@end
