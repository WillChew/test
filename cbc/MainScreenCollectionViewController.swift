//
//  MainScreenCollectionViewController.swift
//  cbc
//
//  Created by Will Chew on 2019-11-14.
//  Copyright © 2019 Will Chew. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class MainScreenCollectionViewController: UICollectionViewController {
    
    var articleArray = [NewsArticle]()
    
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        networkcall()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Register cell classes
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        // Do any additional setup after loading the view.
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using [segue destinationViewController].
     // Pass the selected object to the new view controller.
     }
     */
    
    // MARK: UICollectionViewDataSource
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if articleArray.count == 0 {
            return 1
        } else {
            return articleArray.count
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "StoryCell", for: indexPath) as! StoryCollectionViewCell
        
        if articleArray.count == 0 {
            cell.headlineLabel.text = "Loading articles"
        } else  {
            cell.headlineLabel.text = articleArray[indexPath.row].title
            cell.articleImageView.image = articleArray[indexPath.row].headlineImage
        }
        
        
        return cell
    }
    
    // MARK: UICollectionViewDelegate
    
    /*
     // Uncomment this method to specify if the specified item should be highlighted during tracking
     override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
     return true
     }
     */
    
    /*
     // Uncomment this method to specify if the specified item should be selected
     override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
     return true
     }
     */
    
    /*
     // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
     override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
     return false
     }
     
     override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
     return false
     }
     
     override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
     
     }
     */
    
}

extension MainScreenCollectionViewController {
    
    
    //    struct NewsArticle: Codable {
    //        let contentitems: [Contentitem]
    //    }
    //
    //    struct Contentitem: Codable {
    //        let pubdate: String
    //        let type: TypeEnum
    //        let url: String
    //        let headlineimage: String
    //        let id: String
    //        let contentitemJSON: String
    //        let title, flag, contentitemDescription, deck: String
    //
    //        enum CodingKeys: String, CodingKey {
    //            case pubdate, type, url, headlineimage, id
    //            case contentitemJSON = "json"
    //            case title, flag
    //            case contentitemDescription = "description"
    //            case deck
    //        }
    //    }
    //
    //    enum TypeEnum: String, Codable {
    //        case story = "story"
    //    }
    

    
    func networkcall() {
        
        guard let url = URL(string: "https://www.cbc.ca/m/config/news/samples/cbcnews.json") else {
            fatalError("Error getting URL")
        }
        
        
        let session = URLSession.shared
        session.dataTask(with: url) { [weak self] (data, response, error) in
            
            guard let data = data, let jsonDict = try! JSONSerialization.jsonObject(with: data, options: []) as? Dictionary<String,Any?>, let jsonDict2 = jsonDict["contentitems"] as? Array<Dictionary<String,Any?>> else { return }
            
            for article in jsonDict2 {
                guard let articleTitle = article["title"] as? String,
                    let articleURL = article["url"] as? String,
                    let id = article["id"] as? String,
                    let pubDate = article["pubdate"] as? String,
                    let headlineImage = article["headlineimage"] as? String
                    else { return }
                    
                
                let pictureURL = URL(string: headlineImage)!
                let imageData = try? Data(contentsOf: pictureURL)
                
                
                let newsArticle = NewsArticle(title: articleTitle, url: articleURL, id: id, pubDate: pubDate, headlineImage: UIImage(data: imageData!)!)
                self?.articleArray.append(newsArticle)
            }
            
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
                
            }
            
        }.resume()
        session.finishTasksAndInvalidate()
    }

}
