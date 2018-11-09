//
//  movieView.swift
//  verseTest
//
//  Created by Christian Ernesto Chavarría Méndez on 08/11/18.
//  Copyright © 2018 Christian Ernesto Chavarría Méndez. All rights reserved.
//

import UIKit

class movieView : UICollectionViewCell{
    
    @IBOutlet weak var imgPoster: UIImageView!
    @IBOutlet weak var lblTest: UILabel!
    @IBOutlet weak var actIndViewLoading: UIActivityIndicatorView!
    
    var imgURL : String!
    let imageCache = NSCache<NSString, UIImage>()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.actIndViewLoading.startAnimating()
    }
    
    
    
    //MARK: Custom methods
    func setUpView(){
        
    }
    
    func makeImageFromURL(){
        let catPictureURL = URL(string:imgURL)!
        let session = URLSession(configuration: .default)
        
        print(imgURL)
        let downloadPicTask = session.dataTask(with: catPictureURL) { (data, response, error) in
            // The download has finished.
            if let e = error {
                print("Error downloading cat picture: \(e)")
            } else {
                // No errors found.
                // It would be weird if we didn't have a response, so check for that too.
                if let res = response as? HTTPURLResponse {
                    print("Downloaded cat picture with response code \(res.statusCode)")
                    if let imageData = data {
                        // Finally convert that Data into an image and do what you wish with it.
                        self.imgPoster.image = UIImage(data: imageData)
                        self.actIndViewLoading.stopAnimating()
                        // Do something with your image.
                    } else {
                        print("Couldn't get image: Image is nil")
                    }
                } else {
                    print("Couldn't get response code for some reason")
                }
            }
        }
        
        downloadPicTask.resume()
        
    }
    
}
