//
//  PDFViewCell.swift
//  pdfMerge
//
//  Created by bruce on 2019/1/11.
//  Copyright © 2019 ZLM. All rights reserved.
//

import Cocoa

class PDFViewCell: NSTableCellView {
    
    @IBOutlet weak var deleteButton: NSButton!
    
    var deleteAction: (() -> Void)? = nil
    
    @IBAction func deleteButtonPressed(_ sender: Any) {
        deleteAction?()
    }
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
    }
}
