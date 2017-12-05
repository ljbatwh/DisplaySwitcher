//
//  DisplayManager.swift
//  DisplaySwitcher
//
//  Created by ljb on 4/12/17.
//  Copyright © 2017 ljb. All rights reserved.
//

import Foundation
import CoreGraphics
let DisplayManagerErrorDomain = "com.ljb.DisplaySwitcher.DisplayManager"

struct DisplayInfo {
    let id: CGDirectDisplayID
    var name: String
    let containsCursor : Bool
    let isBuildin    : Bool
    let isMain      :Bool
    init(display:CGDirectDisplayID) {
        self.id = display
        do {
            self.name = try getNameForDisplay(displayID: display)
            self.containsCursor = try displayContiansMouse(id: display)
        } catch {
            self.name = "Unknown"
            self.containsCursor = false
        }
        self.isBuildin = Bool(CGDisplayIsBuiltin(display) != 0);
        self.isMain = Bool(CGDisplayIsMain(display) != 0 );
    }
}

/**
 Get active display count. Active display means drawable.
 NB: a mirror display can not drawable
 
 - returns: the number of active display
 */
func getActiveDisplayCount() throws -> UInt32 {
    var countVar:UInt32 = 0
    let error = CGGetActiveDisplayList(0, nil, &countVar)
    guard error == CGError.success else {
        throw NSError(domain: DisplayManagerErrorDomain, code: Int(error.rawValue), userInfo: [NSLocalizedDescriptionKey: "Get Display Count Error."])
    }

    return countVar
}
func getDisplayCountWithPoint(point:CGPoint) throws -> UInt32 {
    var countVar:UInt32 = 0
    let error = CGGetDisplaysWithPoint(point,0, nil, &countVar)
    guard error == CGError.success else {
        throw NSError(domain: DisplayManagerErrorDomain, code: Int(error.rawValue), userInfo: [NSLocalizedDescriptionKey: "Get Display Count Error."])
    }
    
    return countVar
}
func getNameForDisplay(displayID:CGDirectDisplayID) throws -> String {
    var error : NSError?
    let name:UnsafeMutablePointer<Int8> = getDisplayName(displayID,&error)
    if let theError = error {
        throw theError
    }
    return String(cString: name)

}

func getActiveDisplayIdList() throws -> [CGDirectDisplayID] {
    let displayCount = try getActiveDisplayCount()
    let initalArray:UnsafeMutablePointer<CGDirectDisplayID>  = UnsafeMutablePointer<CGDirectDisplayID>.allocate(capacity:  Int(displayCount))
    let error = CGGetActiveDisplayList(displayCount, initalArray, nil)
    guard error == CGError.success else {
        throw NSError(domain: DisplayManagerErrorDomain, code: Int(error.rawValue), userInfo: [NSLocalizedDescriptionKey: "Get Display Count Error."])
    }
    let array = Array<CGDirectDisplayID>(UnsafeBufferPointer(start: initalArray, count:Int(displayCount)))
    initalArray.deallocate(capacity: Int(displayCount))
    return array
}

func getMouseDisplayLocation() -> CGPoint {
    let event:CGEvent =  CGEvent(source: nil)!
    return event.location
}
func getDisplayIdListWithPoint(point:CGPoint) throws -> [CGDirectDisplayID] {
    let displayCount = try getDisplayCountWithPoint(point: point)
    let initalArray:UnsafeMutablePointer<CGDirectDisplayID>  = UnsafeMutablePointer<CGDirectDisplayID>.allocate(capacity:  Int(displayCount))
    let error = CGGetDisplaysWithPoint(point,displayCount, initalArray, nil)
    guard error == CGError.success else {
        throw NSError(domain: DisplayManagerErrorDomain, code: Int(error.rawValue), userInfo: [NSLocalizedDescriptionKey: "Get Display Count Error."])
    }
    let array = Array<CGDirectDisplayID>(UnsafeBufferPointer(start: initalArray, count:Int(displayCount)))
    initalArray.deallocate(capacity: Int(displayCount))
    return array
}
func displayContiansMouse(id:CGDirectDisplayID) throws-> Bool{
    let cursorLocation = getMouseDisplayLocation()
    let displayList = try getDisplayIdListWithPoint(point: cursorLocation)
    return displayList.contains(id)
}

func getDisplayNameList() throws -> [String] {
    let idList = try getActiveDisplayIdList()
    var names:[String] = []
    for id in idList {
        names.append(try getNameForDisplay(displayID: id))
    }
    return names
}

func getDisplayInfoList(ids:[CGDirectDisplayID]) ->[DisplayInfo]{
    var infos:[DisplayInfo] = []
    for did in ids{
        infos.append(DisplayInfo(display:did))
    }
    return infos
}

func MoveCursorToDisplayCenter(displayID:CGDirectDisplayID){
    let rect = CGDisplayBounds(displayID)
    let center = CGPoint(x:NSMidX(rect),y:NSMidY(rect))
    CGDisplayMoveCursorToPoint(displayID,center)
    print("Move Cursor To Display \(displayID) Point: \(center)")

}
func WrapCursorToDisplayCenter(displayID:CGDirectDisplayID){
    let rect = CGDisplayBounds(displayID)
    let center = CGPoint(x:NSMidX(rect),y:NSMidY(rect))
    print("Wrap Cursor To Display \(displayID) Point: \(center)")
    CGWarpMouseCursorPosition(center)
}
