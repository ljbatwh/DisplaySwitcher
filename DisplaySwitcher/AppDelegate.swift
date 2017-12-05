//
//  AppDelegate.swift
//  DisplaySwitcher
//
//  Created by ljb on 4/12/17.
//  Copyright © 2017 ljb. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    let statusItem = NSStatusBar.system.statusItem(withLength:NSStatusItem.squareLength)
    let preferencesWindow = PreferencesWindow()
    let preferencesStore = PreferencesStore()
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        if let button = statusItem.button {
            button.title = "\u{1F5A5}"  //            🖥
        }

        constructMenu()
        
        preferencesStore.registerMoveCursorToNextDisplayShortcut(action:{ ()->Void in
            self.moveCursorToNextDisplay()
        } )
        preferencesStore.registerPreferencesOfMoveCursorToNextDisplayShortcut { () in
            self.changeMenuKeyEquivalent()
        }
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
        preferencesStore.breakMoveCursorToNextDisplayShortcut()
        preferencesStore.unregisterPreferencesCallbackOfMoveCursorToNextDisplayShortcut()
    }
    func moveCursorToNextDisplay(){
        do {
            let infos:[DisplayInfo] = try getDisplayInfoList(ids: getActiveDisplayIdList())
            let currentIndex = infos.index(where: { (info) -> Bool in
                info.containsCursor
            })
            var nextIndex = infos.index(after: currentIndex!)
            nextIndex = nextIndex >= infos.count ? 0 : nextIndex
            WrapCursorToDisplayCenter(displayID: infos[nextIndex].id)
        } catch let error as NSError {
            print("Error: \(error)")
        }
    }
    @objc func moveCursorToNextDisplay(_ sender: NSMenuItem) {
        moveCursorToNextDisplay()
    }

    @objc func moveCursorToDisplay(_ sender: NSMenuItem) {
        WrapCursorToDisplayCenter(displayID: UInt32(sender.tag))
    }
    @objc func showOptionDialog(_ sender: Any?) {
        preferencesWindow.open()
    }
    func changeMenuKeyEquivalent(){
        let item = statusItem.menu?.item(withTitle: kDSPreferencesMoveToNextDisplayTitle)
        let shortcut = preferencesStore.getShortcutForMoveToNextDisplay()

        if(shortcut != nil){
            item?.keyEquivalent = shortcut!.keyCodeStringForKeyEquivalent
            item?.keyEquivalentModifierMask = NSEvent.ModifierFlags(rawValue: shortcut!.modifierFlags)
        }else{
            item?.keyEquivalent = ""
            item?.keyEquivalentModifierMask = NSEvent.ModifierFlags(rawValue: 0)
        }
    }
    func constructMenu() {
        let menu = NSMenu()
        
        menu.addItem(NSMenuItem(title: "Option", action: #selector(AppDelegate.showOptionDialog(_:)), keyEquivalent: "o"))
        menu.addItem(NSMenuItem.separator())

        menu.addItem(NSMenuItem(title: kDSPreferencesMoveToNextDisplayTitle, action:#selector(AppDelegate.moveCursorToNextDisplay(_:)), keyEquivalent:"" ))
        menu.addItem(NSMenuItem.separator())

        do {
            let infos:[DisplayInfo] = try getDisplayInfoList(ids: getActiveDisplayIdList())
            for info in infos {
                menu.addItem(NSMenuItem(title: info.name, action: nil,keyEquivalent:""))
            }
        } catch let error as NSError {
            print("Error: \(error)")
        }

        menu.addItem(NSMenuItem.separator())
        menu.addItem(NSMenuItem(title: "Quit", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q"))
        
        statusItem.menu = menu
        changeMenuKeyEquivalent()

    }
}

