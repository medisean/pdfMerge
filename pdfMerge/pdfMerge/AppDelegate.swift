//
//  AppDelegate.swift
//  pdfMerge
//
//  Created by bruce on 2019/1/11.
//  Copyright © 2019 ZLM. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    func applicationShouldHandleReopen(_ sender: NSApplication, hasVisibleWindows flag: Bool) -> Bool {
        sender.windows.first?.makeKeyAndOrderFront(self)
        return true
    }
    
    @IBAction func splitButtonPressed(_ sender: Any) {
        
    }
}

