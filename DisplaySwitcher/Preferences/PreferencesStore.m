//
//  PreferenceStore.m
//  DisplaySwitcher
//
//  Created by ljb on 6/12/17.
//  Copyright © 2017 ljb. All rights reserved.
//

#import "PreferencesStore.h"
NSString *const kDSPreferencesMoveToNextDisplayShortcut = @"MoveToNextDisplayShortcut";
NSString *const kDSPreferencesMoveToNextDisplayTitle = @"Move Cursor To Next Display Center";

static NSUInteger kDefaultMoveToNextDisplayShortcutKeyCode = kVK_ANSI_N;
static NSUInteger kDefaultMoveToNextDisplayShortcutModifierFlags = NSCommandKeyMask|NSAlternateKeyMask;

@interface PreferencesStore(){
    void * _kGlobalShortcutContext;
    ShortchutPerferenceChangeCallback    _cbPerferenceChange;
    NSString *_observableKeyPath;
}
@property  MASDictionaryTransformer *transformer;
@property MASShortcut* defaultShortcut;
@end

@implementation PreferencesStore
+ (PreferencesStore*)instance {
    static PreferencesStore *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}
+ (NSString*) shortcutTransfermerName{
    return MASDictionaryTransformerName;
}
- (id)init {
    if (self = [super init]) {
        _defaultShortcut = [MASShortcut shortcutWithKeyCode:kDefaultMoveToNextDisplayShortcutKeyCode modifierFlags:kDefaultMoveToNextDisplayShortcutModifierFlags];
        _transformer = (MASDictionaryTransformer*)[NSValueTransformer valueTransformerForName:[PreferencesStore shortcutTransfermerName]];
        [self regisiterDefaultShortcutForMoveToNextDisplay];
        [self initUserDefaultsObserver];
    }
    return self;
}
// Capture the KVO change and do something
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)obj
                        change:(NSDictionary *)change context:(void *)ctx
{
    if (ctx == _kGlobalShortcutContext) {
        NSLog(@"Shortcut has changed");
        if (_cbPerferenceChange != nil){
            _cbPerferenceChange();
        }
        //[[NSUserDefaults standardUserDefaults] synchronize];
    }
    else {
        [super observeValueForKeyPath:keyPath ofObject:obj change:change context:ctx];
    }
}
- (void)registerPreferencesOfMoveCursorToNextDisplayShortcutWithCallback:(ShortchutPerferenceChangeCallback) callback{
    _cbPerferenceChange = callback;
    [[NSUserDefaultsController sharedUserDefaultsController] addObserver:self forKeyPath:_observableKeyPath options:NSKeyValueObservingOptionInitial context:_kGlobalShortcutContext];
}
- (void)unregisterPreferencesCallbackOfMoveCursorToNextDisplayShortcut{
    _cbPerferenceChange = nil;
    [[NSUserDefaultsController sharedUserDefaultsController] removeObserver:self forKeyPath:_observableKeyPath context:_kGlobalShortcutContext];
}
- (void)initUserDefaultsObserver{
    _kGlobalShortcutContext = &_kGlobalShortcutContext;
    _observableKeyPath = [@"values." stringByAppendingString:kDSPreferencesMoveToNextDisplayShortcut];
    _cbPerferenceChange = nil;
}
- (void)regisiterDefaultShortcutForMoveToNextDisplay{
    NSDictionary* defaultShortcutDict = @{kDSPreferencesMoveToNextDisplayShortcut:_defaultShortcut};
    [MASShortcutBinder sharedBinder].bindingOptions = @{NSValueTransformerNameBindingOption:MASDictionaryTransformerName};
    [[MASShortcutBinder sharedBinder] registerDefaultShortcuts:defaultShortcutDict];
}

- (void)setShortcutForMoveToNextDisplay:(MASShortcut*)shortcut{
    // Store the data
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSDictionary* dict = [self.transformer reverseTransformedValue:shortcut];
    
    [defaults setObject:dict forKey:kDSPreferencesMoveToNextDisplayShortcut];

    [defaults synchronize];
}

- ( MASShortcut*)getShortcutForMoveToNextDisplay{
    // get the data
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSDictionary* dict = [defaults objectForKey:kDSPreferencesMoveToNextDisplayShortcut];
    MASShortcut* shortcut = [self.transformer transformedValue:dict];

    return shortcut;
}
- (void)registerMoveCursorToNextDisplayShortcutWithAction:(dispatch_block_t) action{
    [[MASShortcutBinder sharedBinder]  bindShortcutWithDefaultsKey:kDSPreferencesMoveToNextDisplayShortcut
                                                          toAction:action];
}

- (void)breakMoveCursorToNextDisplayShortcut{
    [[MASShortcutBinder sharedBinder]  breakBindingWithDefaultsKey:kDSPreferencesMoveToNextDisplayShortcut];
}

@end
