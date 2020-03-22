//
//  RemoteImageView.swift
//  TV News
//
//  Created by Praveen on 22/03/20.
//  Copyright © 2020 Praveen. All rights reserved.
//

import UIKit

class RemoteImageView: UIImageView {

    var url: URL?
    
    func getCacheDirectory() -> URL {
        let paths = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func load(_ url: URL) {
        self.url = url
        
        //creating a safe version of this URL that will be our file name
        guard let filename = url.absoluteString.addingPercentEncoding(withAllowedCharacters: CharacterSet.alphanumerics) else { return }
        
        //append that to the cache directory to get complete path
        let fullPath = getCacheDirectory().appendingPathComponent(filename)
        
        //check if cached image exist already
        if FileManager.default.fileExists(atPath: fullPath.path) {
            //use it and return
            image = UIImage(contentsOfFile: fullPath.path)
            return
        }
        
        //add work to background thread
        DispatchQueue.global(qos: .userInitiated).async {
            //download the image data
            guard let imageData = try? Data(contentsOf: url) else { return }
            
            //write to the cache files
            try? imageData.write(to: fullPath)
            
            //now the image has downloaded, check the if the same URL is we want or same image
            if self.url == url {
                //Push work back to the main thread
                DispatchQueue.main.async {
                    self.image = UIImage(data: imageData)
                }
            }
        }
        
    }
}
