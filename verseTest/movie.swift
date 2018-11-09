//
//  movie.swift
//  verseTest
//
//  Created by Christian Ernesto Chavarría Méndez on 08/11/18.
//  Copyright © 2018 Christian Ernesto Chavarría Méndez. All rights reserved.
//

import Foundation
import UIKit

class movie: NSObject{
    
    private var poster: String
    private var title: String
    private var fullReview: String
    private var voteAverage: Double
    private var loaded: Int!
    private var index: Int!
    private var image: UIImage!
    
    init(poster:String, title: String, review: String, vote: Double) {
        self.poster = poster != "" ? (vrImgURL + poster):""
        self.title = title
        self.fullReview = review
        self.voteAverage = vote
        self.loaded = 0
    }
    
    func setPoster(poster: String){
        self.poster = poster
    }
    
    func setTitle(title: String){
        self.title = title
    }
    
    func setFullReview(review: String){
        self.fullReview = review
    }
    
    func setVoteAverage(vote: Double){
        self.voteAverage = vote
    }
    
    func setLoaded(loaded: Int){
        self.loaded = loaded
    }
    
    func setIndex(index: Int){
        self.index = index
    }
    
    func setData(image: UIImage){
        self.image = image
    }
    
    func getPoster()-> String{
        return self.poster
    }
    
    func getTitle()-> String{
        return self.title
    }
    
    func getFullReview()-> String{
        return self.fullReview
    }
    
    func getVoteAverage()-> Double{
        return self.voteAverage
    }
    
    func getLoaded()-> Int{
        return self.loaded
    }
    
    func getIndex()-> Int{
        return self.index
    }
    
    func getImage()-> UIImage{
        return self.image
    }
    
}
