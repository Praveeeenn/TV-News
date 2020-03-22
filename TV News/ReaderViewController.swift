//
//  ReaderViewController.swift
//  TV News
//
//  Created by Praveen on 22/03/20.
//  Copyright © 2020 Praveen. All rights reserved.
//

import UIKit

class ReaderViewController: UIViewController {
    @IBOutlet weak var headlineLabel: UILabel!
    @IBOutlet weak var imageView: RemoteImageView!
    @IBOutlet weak var textView: UITextView!
    
    var article: JSON?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let article = self.article else { return }
        
        textView.panGestureRecognizer.allowedTouchTypes = [UITouch.TouchType.indirect.rawValue] as [NSNumber]
        textView.isSelectable = true
        
        if let url = article["fields"]["thumbnail"].url {
            imageView.load(url)
            imageView.layer.borderColor = UIColor.darkGray.cgColor
            imageView.layer.borderWidth = 2
            imageView.layer.cornerRadius = 20
        }
        
        headlineLabel.text = article["fields"]["headline"].stringValue
        textView.linkTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        
        let articleBody = article["fields"]["body"].stringValue
        let formatedArticleBody = formartHTML(articleBody)
        
        if let bodyData = formatedArticleBody.data(using: .utf8) {
            if let bodyText = try? NSAttributedString(data: bodyData, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil) {
                textView.attributedText = bodyText
            }
        }
    }
    
    func formartHTML(_ html: String) -> String {
        guard let wrapperURL = Bundle.main.url(forResource: "wrapper", withExtension: "html") else { return html }
        guard let wrapper = try? String(contentsOf: wrapperURL) else { return html }
        return wrapper.replacingOccurrences(of: "%@", with: html)
    }

}
