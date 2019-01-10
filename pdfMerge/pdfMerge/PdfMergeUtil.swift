//
//  PdfMergeUtil.swift
//  pdfMerge
//
//  Created by bruce on 2019/1/10.
//  Copyright © 2019 ZLM. All rights reserved.
//

import Foundation

class PdfMergeUtil {
    func mergeTwoFiles(file1URL: URL, file2URL: URL){
        let pdfDoc1 = CGPDFDocument(file1URL as CFURL)
        let pdfDoc2 = CGPDFDocument(file2URL as CFURL)
        
        guard let pdf1LastName = file1URL.absoluteString.split(separator: "/").last,
            let pdf2LastName = file2URL.absoluteString.split(separator: "/").last else {
            return
        }

        let pdf1Name = pdf1LastName.replacingOccurrences(of: ".pdf", with: "")
        let pdf2Name = pdf2LastName.replacingOccurrences(of: ".pdf", with: "")

        let final = URL(fileURLWithPath: NSHomeDirectory() + "/Downloads/" + pdf1Name + pdf2Name + ".pdf") as NSURL
        
        let numberOfPagesDoc1 = pdfDoc1!.numberOfPages
        let numberOfPagesDoc2 = pdfDoc2!.numberOfPages
        
        let writeContext = CGContext.init(final, mediaBox: nil, nil)
        
        var page: CGPDFPage?
        var mediaBox: CGRect
        for i in 1...numberOfPagesDoc1{
            page = pdfDoc1!.page(at: i)
            mediaBox = page!.getBoxRect(.mediaBox)
            writeContext!.beginPage(mediaBox: &mediaBox)
            writeContext!.drawPDFPage(page!)
            writeContext!.endPage()
        }
        for i in 1...numberOfPagesDoc2{
            page = pdfDoc2!.page(at: i)
            mediaBox = page!.getBoxRect(.mediaBox)
            writeContext!.beginPage(mediaBox: &mediaBox)
            writeContext!.drawPDFPage(page!)
            writeContext!.endPage()
        }
        
        writeContext!.closePDF()
    }
}
