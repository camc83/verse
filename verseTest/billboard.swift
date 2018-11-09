//
//  billboard.swift
//  verseTest
//
//  Created by Christian Ernesto Chavarría Méndez on 08/11/18.
//  Copyright © 2018 Christian Ernesto Chavarría Méndez. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

private let kLoadScreenSize = UIScreen.main.bounds.width
private let kLoadCellImageViewTag = 1
private let kLoadSpan: CGFloat = 0.1
private let kLoadAspectRatio: CGFloat = 1.5 // width / height aspect ratio for non square cells.
private let kLoadColumnsPerRow: CGFloat = 2.0 // number of columns for every row.

class billboard: UICollectionViewController, UICollectionViewDelegateFlowLayout, UISearchBarDelegate{
    
    var data : [JSON]!
    var movies : [movie]!
    var cellSize = CGSize.zero
    var query:String!
    var pages: Int!
    var page: Int!
    var loading: Int!
    //var searchController: UISearchController!
    let searchController = UISearchController(searchResultsController: nil)
    let customCellIdentifier = "movieView"
    
    override var prefersStatusBarHidden: Bool{
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.setView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Search Delegate
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar){
        self.query = searchController.searchBar.text!
        self.getData(url: query + "&page=" + String(self.page))
        //print("entre")
    }
    
    //MARK: CollectionView Methods
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let customCell = collectionView.dequeueReusableCell(withReuseIdentifier: customCellIdentifier, for: indexPath) as! movieView
        
        if (self.movies[(indexPath as NSIndexPath).row].getLoaded() != 0 ){
            //print("CACHE HIT: \(indexPath)")
            customCell.imgPoster.image = self.movies[(indexPath as NSIndexPath).row].getImage()
        } else {
            //print("CACHE MISS: \(indexPath)")
            if(movies[indexPath.row].getPoster() != ""){
                let imgUrl = URL(string: movies[indexPath.row].getPoster())
                let request: URLRequest = URLRequest(url: imgUrl!)
                let session = URLSession(configuration: .default)
                
                let dataTask = session.dataTask(with: request, completionHandler: { (data, response, error) -> Void in
                    if(data != nil) {
                        //print("IMAGE DOWNLOADED")
                        let image = UIImage(data: data!)
                        
                        self.movies[(indexPath as NSIndexPath).row].setData(image: image!)
                        self.movies[(indexPath as NSIndexPath).row].setLoaded(loaded: 1)
                        self.movies[(indexPath as NSIndexPath).row].setIndex(index: (indexPath as NSIndexPath).row)
                        
                        DispatchQueue.main.async(execute: { [weak collectionView] in
                            customCell.imgPoster.image = image
                            customCell.actIndViewLoading.stopAnimating()
                            collectionView?.reloadData()
                        })
                    } 
                }) 
                dataTask.resume()
            }else{
                self.movies[(indexPath as NSIndexPath).row].setData(image: UIImage(named: "noImage")!)
                self.movies[(indexPath as NSIndexPath).row].setLoaded(loaded: 1)
                self.movies[(indexPath as NSIndexPath).row].setIndex(index: (indexPath as NSIndexPath).row)
                customCell.imgPoster.image = UIImage(named: "noImage")
                customCell.actIndViewLoading.stopAnimating()
                collectionView.reloadData()
            }
        }
        
        return customCell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var aMovieDetail: movieDetail
        
        aMovieDetail = movieDetail(nibName: "movieDetail", bundle: nil)
        aMovieDetail.aMovie = movies[(indexPath as NSIndexPath).row]
        self.navigationController?.pushViewController(aMovieDetail, animated: true)
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return self.cellSize
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
    
    
    //MARK: Custom methods
    func setView(){
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        let width = UIScreen.main.bounds.width
        
        searchController.searchBar.sizeToFit()
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
        navigationItem.titleView = searchController.searchBar
        definesPresentationContext = true
        
        self.calculateCellWidth()
        
        layout.sectionInset = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        layout.itemSize = CGSize(width: width / 2, height: width / 2)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        
        self.collectionView?.collectionViewLayout = layout
        self.collectionView?.backgroundColor = UIColor.white
        
        let nibCell = UINib(nibName: customCellIdentifier, bundle: nil)
        collectionView?.register(nibCell, forCellWithReuseIdentifier: customCellIdentifier)
        
        self.page = 1
        self.loading = 0
        self.movies = [movie]()
    }
    
    func calculateCellWidth() {
        let width = (kLoadScreenSize - (CGFloat(kLoadColumnsPerRow + 1.0) * kLoadSpan)) / CGFloat(kLoadColumnsPerRow) - 1
        let height = width * kLoadAspectRatio // square factor: 1
        self.cellSize = CGSize(width: width, height: height)
    }
    
    func getData(url: String){
        self.loading = 1
        restApiManager.sharedInstance.getData(option: url){ (json: JSON) in
            if json != JSON.null {
                self.data = json["results"].array
                self.pages = Int(json["total_pages"].stringValue)
                
                DispatchQueue.main.async(execute: {
                    self.toMovie()
                    self.collectionView?.reloadData()
                    self.loading = 0
                })
            }
        }
    }
    
    func toMovie(){
        
        for mov in data{
            var aMovie:movie
            
            aMovie = movie(poster: mov["poster_path"].stringValue,
                           title: mov["title"].stringValue,
                           review: mov["overview"].stringValue,
                           vote: Double(mov["vote_average"].stringValue)!)
            movies.append(aMovie)
        }
        
    }
    
    //MARK: - Scroll
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if(scrollView.contentSize.height > 0.0){
            if((scrollView.contentSize.height - scrollView.contentOffset.y) <= UIScreen.main.bounds.height){
                if(self.loading! == 0){
                    print("cargando...")
                    self.page = self.page + 1
                    self.getData(url: query + "&page=" + String(self.page))
                }
            }
        }
        
    }
}

/*extension billboard: UISearchResultsUpdating {
    // MARK: - UISearchResultsUpdating Delegate
    func updateSearchResults(for searchController: UISearchController) {
        // TODO
    }
}*/


