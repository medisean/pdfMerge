//
//  PdfMergeUtil.swift
//  pdfMerge
//
//  Created by bruce on 2019/1/10.
//  Copyright © 2019 ZLM. All rights reserved.
//

import Foundation

class PdfMergeUtil {
    static var shared = PdfMergeUtil()
    private init() { }
    
    func mergeFiles(with fileURLs: [URL], destination: URL){
        guard fileURLs.count >= 2 else { return }
        
        let final = destination as NSURL
        let writeContext = CGContext.init(final, mediaBox: nil, nil)
        
        for fileURL in fileURLs {
            let pdfDoc = CGPDFDocument(fileURL as CFURL)
            let numberOfPagesDoc = pdfDoc!.numberOfPages
            var page: CGPDFPage?
            var mediaBox: CGRect
            
            for i in 1...numberOfPagesDoc {
                page = pdfDoc!.page(at: i)
                mediaBox = page!.getBoxRect(.mediaBox)
                writeContext!.beginPage(mediaBox: &mediaBox)
                writeContext!.drawPDFPage(page!)
                writeContext!.endPage()
            }
        }
        writeContext!.closePDF()
    }
}
