//
//  ViewController.swift
//  TV News
//
//  Created by Praveen on 21/03/20.
//  Copyright © 2020 Praveen. All rights reserved.
//

import UIKit

class ViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    var apiKey = "b6409c48-bdb8-4db1-9497-d41038407a47"
    var fullURL: String!
    var articles = [JSON]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let text = title else {
            return
        }
        fullURL = "https://content.guardianapis.com/\(text.lowercased())?api-key=\(apiKey)&show-fields=thumbnail,headline,standfirst,body"
        DispatchQueue.global(qos: .userInteractive).async {
            self.fetchWith(url: URL(string: self.fullURL)!)
        }
    }

    func fetchWith(url: URL) {
        //attempt to download the contents of this URL
        if let data = try? Data(contentsOf: url) {
            print(JSON(data))
            //convert that JSON and pull out the array we care about
            articles = JSON(data)["response"]["results"].arrayValue
            
            //Reload the collection view in main thread
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        } else {
            print("Something went wrong !!")
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(articles.count)
        return articles.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as? NewsCell else { fatalError() }
        let newsItem = articles[indexPath.row]
        let title = newsItem["fields"]["headline"].stringValue
        let thumbnail = newsItem["fields"]["thumbnail"].stringValue
        
        cell.textLabel.text = title
        if let url = URL(string: thumbnail) {
            cell.imageView.load(url)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 375.0, height: 375.0)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let reader = storyboard?.instantiateViewController(withIdentifier: "Reader") as? ReaderViewController else { return }
        reader.article = articles[indexPath.row]
        present(reader, animated: true, completion: nil)
    }
    
}

extension ViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return }
        if text.isEmpty {
            articles = [JSON]()
            collectionView?.reloadData()
        } else {
            guard let url = URL(string: "https://content.guardianapis.com/search?api-key=\(apiKey)&q=\(text)&show-fields=thumbnail,headline,standfirst,body") else { return }
            DispatchQueue.global(qos: .userInteractive).async {
                self.fetchWith(url: url)
            }
        }
    }
    
    
    
}
