//
//  NewsArticle.swift
//  cbc
//
//  Created by Will Chew on 2019-11-15.
//  Copyright © 2019 Will Chew. All rights reserved.
//

import UIKit

class NewsArticle {
    var title: String
    var url: String
    var id: String
    var pubDate: String
    var headlineImage: UIImage
    
    init(title: String, url: String, id: String, pubDate: String, headlineImage: UIImage) {
        self.title = title
        self.url = url
        self.id = id
        self.pubDate = pubDate
        self.headlineImage = headlineImage
    }
}
