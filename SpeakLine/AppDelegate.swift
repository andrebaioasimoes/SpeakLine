//
//  AppDelegate.swift
//  SpeakLine
//
//  Created by André Simões on 17/01/16.
//  Copyright © 2016 Andre Simoes. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    var mainWindowController: MainWindowController?
    
    func applicationDidFinishLaunching(notification: NSNotification) {
        
        let mainWindowController = MainWindowController()
        
        mainWindowController.showWindow(self)
        
        self.mainWindowController = mainWindowController
        
    }

}

