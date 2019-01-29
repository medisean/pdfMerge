//
//  ViewController.swift
//  pdfMerge
//
//  Created by bruce on 2019/1/10.
//  Copyright © 2019 ZLM. All rights reserved.
//

import Cocoa

class PDFViewController: NSViewController {
    
    var fileURLs: [URL] = []
    @IBOutlet weak var tableView: NSTableView!
    @IBOutlet weak var mergeButton: NSButton!
    @IBOutlet weak var tipTextField: NSTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    deinit {
        print("deinit")
    }
    
    @IBAction func clickMenuItem(_ sender: Any) {
        
    }
    
    @IBAction func addButtonPressed(_ sender: Any) {
        let openPanel = NSOpenPanel()
        openPanel.prompt = "打开"
        openPanel.allowedFileTypes = ["pdf"]
        openPanel.directoryURL = nil
        openPanel.allowsMultipleSelection = true
        openPanel.beginSheetModal(for: self.view.window!) { (returnCode) in
            if returnCode.rawValue == 1 { // success
                self.fileURLs.append(contentsOf: openPanel.urls)
                self.tableView.reloadData()
            }
        }
    }
    
    @IBAction func mergeButtonPressed(_ sender: Any) {
        guard fileURLs.count >= 2 else {
            self.showTips(true, message: "请选择至少两个 PDF 文档")
            return
        }
        let savePanel = NSSavePanel()
        savePanel.message = "请选择要保存的位置"
        savePanel.allowedFileTypes = ["pdf"]
        savePanel.allowsOtherFileTypes = false
        savePanel.isExtensionHidden = false
        savePanel.canCreateDirectories = true
        savePanel.beginSheetModal(for: self.view.window!) { (returnCode) in
            if returnCode.rawValue == 1 { // success
                guard let destination = savePanel.url else {
                    return
                }
                self.showTips(false, message: "正在合并，请稍候...")
                self.mergeButton.isEnabled = false
                PdfMergeUtil.shared.mergeFiles(with: self.fileURLs, destination: destination)
                self.showTips(false, message: "合并成功")
                self.mergeButton.isEnabled = true
                self.fileURLs.removeAll()
                self.tableView.reloadData()
            }
        }
    }
    
    private func showTips(_ isError: Bool, message: String) {
        self.tipTextField.textColor = isError ? NSColor.red : NSColor.green
        self.tipTextField.stringValue = message
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2.0, execute: {
            self.tipTextField.stringValue = ""
        })
    }
    
    override var representedObject: Any? {
        didSet {
            // Update the view, if already loaded.
        }
    }
    
    private func getName(_ fileURL: URL) -> String {
        guard let fileName = fileURL.absoluteString.split(separator: "/").last else {
            return ""
        }
        return String(fileName)
    }
}

extension PDFViewController: NSTableViewDataSource, NSTableViewDelegate {
    func numberOfRows(in tableView: NSTableView) -> Int {
        return fileURLs.count
    }
    
    func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "PDFViewCell"), owner: nil) as! PDFViewCell
        cell.textField?.stringValue = getName(fileURLs[row])
        cell.deleteAction = { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.fileURLs.remove(at: row)
            strongSelf.tableView.reloadData()
        }
        return cell
    }
}
