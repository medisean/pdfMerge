//
//  ViewController.swift
//  pdfMerge
//
//  Created by bruce on 2019/1/10.
//  Copyright © 2019 ZLM. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

    var file1: URL?
    var file2: URL?
    var final: URL?
 
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "pdf 合并"
        // Do any additional setup after loading the view.
    }
    
    @IBAction func file1ButtonPressed(_ sender: Any) {
        let openPanel = NSOpenPanel()
        openPanel.prompt = "打开"
        openPanel.allowedFileTypes = ["pdf"]
        openPanel.directoryURL = nil
        openPanel.beginSheetModal(for: self.view.window!) { (returnCode) in
            if returnCode.rawValue == 1 { // success
                guard let fileURL = openPanel.urls.first else {
                    return
                }
                self.file1 = fileURL
            }
        }
    }
    
    @IBAction func file2ButtonPressed(_ sender: Any) {
        let openPanel = NSOpenPanel()
        openPanel.prompt = "打开"
        openPanel.allowedFileTypes = ["pdf"]
        openPanel.directoryURL = nil
        openPanel.beginSheetModal(for: self.view.window!) { (returnCode) in
            if returnCode.rawValue == 1 { // success
                guard let fileURL = openPanel.urls.first else {
                    return
                }
                self.file2 = fileURL
            }
        }
    }
    
    @IBAction func mergeButtonPressed(_ sender: Any) {
        guard let file1URL = file1, let file2URL = file2 else {
            return
        }

        PdfMergeUtil.init().mergeTwoFiles(file1URL: file1URL, file2URL: file2URL)
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
}

