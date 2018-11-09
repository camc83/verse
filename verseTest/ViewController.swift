//
//  ViewController.swift
//  verseTest
//
//  Created by Christian Ernesto Chavarría Méndez on 08/11/18.
//  Copyright © 2018 Christian Ernesto Chavarría Méndez. All rights reserved.
//

import UIKit
import SwiftyJSON

class ViewController: UIViewController {

    var array:[JSON]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.getData(url: "terror")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getData(url:String){
        
        restApiManager.sharedInstance.getData(option: url){ (json: JSON) in
            if json != JSON.null {
                self.array = json["results"].array
                let pages = json["total_pages"].stringValue
                
                print(self.array)
                print(pages)
                /*self.person = json["person"]
                self.location = self.person?["location"].stringValue
                self.aspirations = json["aspirations"].array
                self.recomendation = json["recomendation"]
                self.awards = json["ahievements"]
                self.jobs = json["jobs"].array
                self.education = json["education"].array
                self.opportunities = json["opportunities"].array*/
                
                DispatchQueue.main.async(execute: {
                    //self.setUpView()
                })
                
            }
            
        }
    }
}

