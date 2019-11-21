//
//  ArticleDetailViewController.swift
//  cbc
//
//  Created by Will Chew on 2019-11-15.
//  Copyright © 2019 Will Chew. All rights reserved.
//

import UIKit

class ArticleDetailViewController: UIViewController {
    
    @IBOutlet weak var storyTextView: UITextView!
    var bodyText: String?
    var id: String?
    var passedImage: UIImage?
    var passedArticle: NewsArticle?
    var passedTitle: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let id = id {
            getNewsInfo(of: id)
        }
        
        storyTextView.isEditable = false
        storyTextView.backgroundColor = .white
       
        
        // Do any additional setup after loading the view.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}

extension ArticleDetailViewController {
    
    func getNewsInfo(of id: String) {
        
        guard let url = URL(string: "https://www.cbc.ca/m/config/news/samples/\(id).json") else {
            fatalError("no id found for URL")
        }
        let session = URLSession.shared
        session.dataTask(with: url) { (data, response, error) in
            guard let data = data, let json = try! JSONSerialization.jsonObject(with: data, options: []) as? Dictionary<String,Any?> else {
                fatalError("Error parsing JSON")
            }
            guard let body = json["body"] as? String else { return }
            
            DispatchQueue.main.async {
                
                var attributedString: NSMutableAttributedString!
                 let textAttachment = NSTextAttachment()
                 textAttachment.image = self.passedImage
                let attrStrWithImage = NSAttributedString(attachment: textAttachment)
                attributedString = NSMutableAttributedString()
                

                let oldWidth = textAttachment.image!.size.width
                let scale = oldWidth / (self.storyTextView.frame.size.width - 10)
                textAttachment.image = UIImage(cgImage: textAttachment.image!.cgImage!, scale: scale, orientation: .up)
                textAttachment.bounds = CGRect.init(x: 0, y: 0, width: textAttachment.image!.size.width, height: textAttachment.image!.size.height)
                
                let data = body.data(using: String.Encoding.unicode)!
                
                guard let attrBodyStr = try? NSAttributedString(data: data, options: [NSAttributedString.DocumentReadingOptionKey.documentType : NSAttributedString.DocumentType.html], documentAttributes: nil) else { return }
                
                
                guard let titleStr = self.passedTitle else { return }
                let fontAttribute = [NSAttributedString.Key.font: UIFont(name: "Kailasa", size: 25.0)! ]
                let titleAttrStr = NSAttributedString(string: "\(titleStr) \n", attributes: fontAttribute)
                
                attributedString.append(titleAttrStr)
                attributedString.append(attrStrWithImage)
                attributedString.append(attrBodyStr)
                
                
                
                self.storyTextView.attributedText = attributedString
                
                
                
                
//                self.storyTextView.attributedText = attrStr
            }
            
        }.resume()
        session.finishTasksAndInvalidate()
        
        
        
        
        
        
    }
    
    
    
}
