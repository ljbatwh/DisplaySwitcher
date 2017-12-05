//
//  DisplayUtilts.m
//  DisplaySwitcher
//
//  Created by ljb on 5/12/17.
//  Copyright © 2017 ljb. All rights reserved.
//

#include <stdlib.h>
#include <stdlib.h>
#include <limits.h>

#include <Foundation/Foundation.h>
#include <IOKit/graphics/IOGraphicsLib.h>

char* getDisplayName(CGDirectDisplayID displayID, NSError** error)
{
    io_iterator_t it;
    io_service_t service;
    CFDictionaryRef info;
    
    if (IOServiceGetMatchingServices(kIOMasterPortDefault,
                                     IOServiceMatching("IODisplayConnect"),
                                     &it) != 0)
    {
        // This may happen if a desktop Mac is running headless
        return NULL;
    }
    
    while ((service = IOIteratorNext(it)) != 0)
    {
        info = IODisplayCreateInfoDictionary(service,
                                             kIODisplayOnlyPreferredName);
        
        CFNumberRef vendorIDRef =
        CFDictionaryGetValue(info, CFSTR(kDisplayVendorID));
        CFNumberRef productIDRef =
        CFDictionaryGetValue(info, CFSTR(kDisplayProductID));
        if (!vendorIDRef || !productIDRef)
        {
            CFRelease(info);
            continue;
        }
        
        unsigned int vendorID, productID;
        CFNumberGetValue(vendorIDRef, kCFNumberIntType, &vendorID);
        CFNumberGetValue(productIDRef, kCFNumberIntType, &productID);
        
        if (CGDisplayVendorNumber(displayID) == vendorID &&
            CGDisplayModelNumber(displayID) == productID)
        {
            // Info dictionary is used and freed below
            break;
        }
        
        CFRelease(info);
    }
    
    IOObjectRelease(it);
    
    if (!service)
    {
        *error  = [NSError errorWithDomain:@"com.ljb.DisplaySwitcher.DisplayManager"
                                      code:service
                                  userInfo:@{
                                             NSLocalizedDescriptionKey:@"Cocoa: Failed to find service port for display"
                                             }];
        return NULL;
    }
    
    CFDictionaryRef names =
    CFDictionaryGetValue(info, CFSTR(kDisplayProductName));
    
    CFStringRef nameRef;
    
    if (!names || !CFDictionaryGetValueIfPresent(names, CFSTR("en_US"),
                                                 (const void**) &nameRef))
    {
        // This may happen if a desktop Mac is running headless
        CFRelease(info);
        return NULL;
    }
    
    const CFIndex size =
    CFStringGetMaximumSizeForEncoding(CFStringGetLength(nameRef),
                                      kCFStringEncodingUTF8);
    char* name = calloc(size + 1, 1);
    CFStringGetCString(nameRef, name, size, kCFStringEncodingUTF8);
    
    CFRelease(info);
    return name;
}
