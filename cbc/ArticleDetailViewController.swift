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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let id = id {
            getNewsInfo(of: id)
        }
        
       
        
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
                let data = body.data(using: String.Encoding.unicode)!
                let attrStr = try? NSAttributedString(data: data, options: [NSAttributedString.DocumentReadingOptionKey.documentType : NSAttributedString.DocumentType.html], documentAttributes: nil)
                
                self.storyTextView.attributedText = attrStr
            }
            
        }.resume()
        session.finishTasksAndInvalidate()
        
        
        
        
        
        
    }
    
    
    
}
