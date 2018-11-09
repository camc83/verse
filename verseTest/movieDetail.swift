//
//  movieDetail.swift
//  verseTest
//
//  Created by Christian Ernesto Chavarría Méndez on 09/11/18.
//  Copyright © 2018 Christian Ernesto Chavarría Méndez. All rights reserved.
//

import UIKit

class movieDetail: UIViewController{
    @IBOutlet weak var imgPoster: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblVote: UILabel!
    @IBOutlet weak var txtViewOverview: UITextView!
    
    var aMovie: movie!
    
    override var prefersStatusBarHidden: Bool{
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.setUpView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Custom Methods
    func setUpView(){
        self.navigationItem.title = "Movie Detail"
        self.imgPoster.image = aMovie.getImage()
        self.lblTitle.text = aMovie.getTitle()
        self.lblVote.text = String(describing: aMovie.getVoteAverage())
        self.txtViewOverview.text = aMovie.getFullReview()
    }
}
