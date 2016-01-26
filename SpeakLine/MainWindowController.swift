//
//  MainWindowController.swift
//  SpeakLine
//
//  Created by André Simões on 17/01/16.
//  Copyright © 2016 Andre Simoes. All rights reserved.
//

import Cocoa

class MainWindowController: NSWindowController, NSSpeechSynthesizerDelegate, NSWindowDelegate, NSTableViewDataSource, NSTableViewDelegate {
    
    @IBOutlet weak var textField: NSTextField!
    @IBOutlet weak var speakButton: NSButton!
    @IBOutlet weak var stopButton: NSButton!
    @IBOutlet weak var tableView: NSTableView!

    
    
    let speechSynth = NSSpeechSynthesizer()
    
    let voices = NSSpeechSynthesizer.availableVoices()
    
    var isStarted: Bool = false {
        didSet {
            updateButtons()
        }
    }
    
    override var windowNibName: String {
        return "MainWindowController"
    }

    override func windowDidLoad() {
        super.windowDidLoad()
        updateButtons()
        speechSynth.delegate = self
        for voice in voices {
            print(voiceNameForIdentifier(voice)!)
        }
        
        let defaultVoice = NSSpeechSynthesizer.defaultVoice()
        
        if let defaultRow = voices.indexOf(defaultVoice){
            let indices = NSIndexSet(index: defaultRow)
            tableView.selectRowIndexes(indices, byExtendingSelection: false)
            tableView.scrollRowToVisible(defaultRow)
        }
    }
    
    
    func voiceNameForIdentifier(identifier: String) -> String? {
        let attributes = NSSpeechSynthesizer.attributesForVoice(identifier)
        return attributes[NSVoiceName] as? String
    }
    
    // Mark: - NSWindowDelegate
    
    func windowShouldClose(sender: AnyObject) -> Bool {
        return !isStarted
    }
    
   /* func windowWillResize(sender: NSWindow, toSize frameSize: NSSize) -> NSSize {
        
        let heightAdjusted = NSSize(width: (frameSize.height), height: frameSize.height)
        
        let widthAdjusted = NSSize(width: frameSize.width, height: frameSize.width)
        
        return sender.frame.height != frameSize.height ? heightAdjusted : widthAdjusted
    }*/
    
    
    // Mark: - NSTableViewDelegate
    
    func tableViewSelectionDidChange(notification: NSNotification) {
        let row = tableView.selectedRow
        if row == -1 {
            speechSynth.setVoice(nil)
            return
        }
        let voice = voices[row]
        speechSynth.setVoice(voice)
    }
    
    // Mark: - NSTableViewDataSource
    
    func numberOfRowsInTableView(tableView: NSTableView) -> Int {
        return voices.count
    }
    
    func tableView(tableView: NSTableView, objectValueForTableColumn tableColumn: NSTableColumn?, row: Int) -> AnyObject? {
        let voice = voices[row]
        let voiceName = voiceNameForIdentifier(voice)
        return voiceName
    }
    
    // MARK: - NSSpeechSynthetizerDelegate
    
    func speechSynthesizer(sender: NSSpeechSynthesizer, didFinishSpeaking finishedSpeaking: Bool) {
        isStarted = false
        print("finishedSpeaking = \(finishedSpeaking)")
    }
    
    // MARK: - Action methods
    
    @IBAction func speakIt(sender: NSButton) {
        
        let string = textField.stringValue
        
        if string.isEmpty {
            print("string from \(textField) is empty")
        }
        else {
            speechSynth.startSpeakingString(textField.stringValue)
            isStarted = true
            updateButtons()
        }
    }
    
    @IBAction func stopIt(sender: NSButton){
        print("stop button clicked")
        speechSynth.stopSpeaking()
        //isStarted = false
        updateButtons()
    }
    
    func updateButtons() {
        if isStarted {
            speakButton.enabled = false
            stopButton.enabled = true
        }
        else {
            stopButton.enabled = false
            speakButton.enabled = true
        }
    
    }
    
}
