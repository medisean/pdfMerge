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
    
    private var dragDropType = NSPasteboard.PasteboardType(rawValue: "private.table-row")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.registerForDraggedTypes([dragDropType])
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
    
    private func getName(_ fileURL: URL) -> String? {
        guard let fileName = fileURL.absoluteString.split(separator: "/").last else {
            return ""
        }
        return String(fileName).removingPercentEncoding
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
        cell.textField?.stringValue = getName(fileURLs[row]) ?? ""
        cell.deleteAction = { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.fileURLs.remove(at: row)
            strongSelf.tableView.reloadData()
        }
        return cell
    }
    
    // drag to sort
    
    func tableView(_ tableView: NSTableView, pasteboardWriterForRow row: Int) -> NSPasteboardWriting? {
        
        let item = NSPasteboardItem()
        item.setString(String(row), forType: self.dragDropType)
        return item
    }
    
    func tableView(_ tableView: NSTableView, validateDrop info: NSDraggingInfo, proposedRow row: Int, proposedDropOperation dropOperation: NSTableView.DropOperation) -> NSDragOperation {
        
        if dropOperation == .above {
            return .move
        }
        return []
    }
    
    func tableView(_ tableView: NSTableView, acceptDrop info: NSDraggingInfo, row: Int, dropOperation: NSTableView.DropOperation) -> Bool {
        
        var oldIndexes = [Int]()
        info.enumerateDraggingItems(options: [], for: tableView, classes: [NSPasteboardItem.self], searchOptions: [:]) { dragItem, _, _ in
            if let str = (dragItem.item as! NSPasteboardItem).string(forType: self.dragDropType), let index = Int(str) {
                oldIndexes.append(index)
            }
        }
        
        var oldIndexOffset = 0
        var newIndexOffset = 0
        
        // For simplicity, the code below uses `tableView.moveRowAtIndex` to move rows around directly.
        // You may want to move rows in your content array and then call `tableView.reloadData()` instead.
        tableView.beginUpdates()
        for oldIndex in oldIndexes {
            if oldIndex < row {
                tableView.moveRow(at: oldIndex + oldIndexOffset, to: row - 1)
                oldIndexOffset -= 1
                let url = fileURLs[oldIndex]
                fileURLs.remove(at: oldIndex)
                fileURLs.insert(url, at: row - 1)
                print("from:", oldIndex, "to: ", row - 1)
            } else {
                tableView.moveRow(at: oldIndex, to: row + newIndexOffset)
                newIndexOffset += 1
                let url = fileURLs[oldIndex]
                fileURLs.remove(at: oldIndex)
                fileURLs.insert(url, at: row)
                print("from:", oldIndex, "to: ", row)

            }
        }
        tableView.endUpdates()
        
        return true
    }
}
