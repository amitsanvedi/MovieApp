//
//  MovieViewAllViewController.swift
//  MovieApp
//
//  Created by gopalsara on 31/08/17.
//  Copyright © 2017 gopalsara. All rights reserved.
//

import UIKit
import ObjectMapper

class MovieViewAllViewController: UIViewController , UICollectionViewDataSource , UICollectionViewDelegate , UICollectionViewDelegateFlowLayout {
    
    //MARK: - Outlet.
    @IBOutlet weak var collectionView : UICollectionView!
    //MARK: - Variables.
    var pageCountNowPlaying : Int = 2
    var pageCountPopular    : Int = 2
    var pageCountTopRated   : Int = 2
    var movieTypeTag        : Int!
    var movieData           = [AnyObject]()
    var totalPageCount      : Int!
    
    
    //MARK: - Life cycle methods.
    override func viewDidLoad() {
        super.viewDidLoad()
        self.doInitialConfiguration()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Custom Method
    /**
     doInitialConfiguration is used to initialize the navigation title and calling webApis which is based on movie type tag  */
    func doInitialConfiguration(){
        
        switch self.movieTypeTag {
        case 0:
            self.navigationItem.title = "Top Rated"
            self.loadTopRatedMovie()
            break
        case 1 :
            self.navigationItem.title = "Now Playing"
            self.loadNowPlayingMovie()
            break
        case 2 :
            self.navigationItem.title = "Popular"
            self.loadPopularData()
            break
        default:
            break
        }
    }
    
    /**
     This method is used for filtering an movie array which contain greater then 500 votes.
     */
    func filterTopRatedMovie() {
        
        let movieArray : [MovieResultViewModel] = self.movieData as! [MovieResultViewModel]
        let filterArray = movieArray.filter { $0.vote_count! > 500 }
        let sortedArray = filterArray.sorted { $0.vote_count! > $1.vote_count! }
        self.movieData = sortedArray
        DispatchQueue.main.async() {
            self.collectionView.reloadData()
        }
    }
    
    //MARK: - Webservice releated methods
    
    /**
     To consume the data from the server of currently playing the movies in theatre this method is called. After getting the response from the server the data is populated to array using the parser class which make the model for Movie and feed the data to array which shows in the tableView after reload. .
     */
    func loadNowPlayingMovie() {
        
        WebAPIManager.sharedWebAPIMAnager.doCallWebAPIForGetRequest(pageCount: pageCountNowPlaying, strType: "now_playing", success: { (obj) in
            let movieData :  MovieViewModel = Mapper<MovieViewModel>().map(JSON: obj)!
            self.movieData += movieData.results as [AnyObject]
            DispatchQueue.main.async() {
                self.collectionView.reloadData()
            }
        }) { (error) in
            DispatchQueue.main.async() {
                WebAPIManager.sharedWebAPIMAnager.showTotstOnWindow(strMessage: (error?.localizedDescription)!)
            }
        }
    }
    
    /**
     To consume the data from the server of top rated movies this method is called. After getting the response from the server the data is populated to array using the parser class which make the model for Movie and feed the data to array which shows in the tableView after reload. .
     */
    func loadTopRatedMovie(){
        
        WebAPIManager.sharedWebAPIMAnager.doCallWebAPIForGetRequest(pageCount: pageCountTopRated, strType: "top_rated", success: { (obj) in
            let movieData :  MovieViewModel  = Mapper<MovieViewModel>().map(JSON: obj)!
            self.movieData += movieData.results as [AnyObject]
            self.filterTopRatedMovie()
        }) { (error) in
            DispatchQueue.main.async() {
                WebAPIManager.sharedWebAPIMAnager.showTotstOnWindow(strMessage: (error?.localizedDescription)!)
            }
        }
    }
    
    /**
     To consume the data from the server of popular movies this method is called. After getting the response from the server the data is populated to array using the parser class which make the model for Movie and feed the data to array which shows in the tableView after reload. .
     */
    func loadPopularData() {
        
        WebAPIManager.sharedWebAPIMAnager.doCallWebAPIForGetRequest(pageCount: pageCountPopular, strType: "popular", success: { (obj) in
            let movieData :  MovieViewModel = Mapper<MovieViewModel>().map(JSON: obj)!
            self.movieData += movieData.results as [AnyObject]
            DispatchQueue.main.async() {
                self.collectionView.reloadData()
            }
        }) { (error) in
            
            DispatchQueue.main.async() {
                WebAPIManager.sharedWebAPIMAnager.showTotstOnWindow(strMessage: (error?.localizedDescription)!)
            }
        }
    }
    
    
    
    //MARK: - Collection view delegate and Datasource methods
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int  {
        return self.movieData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! MovieCollectionViewCell
        let movieModelData : MovieResultViewModel = self.movieData[indexPath.row] as! MovieResultViewModel
        cell.doSetupDataOnMovieDetailCell(resultData: movieModelData)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UNIVERSAL_WIDTH/2 - 2 , height: 180 * HEIGHT_FACTOR);
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let view = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionFooter, withReuseIdentifier: "footerView", for: indexPath as IndexPath)
        let activityIndicator = view.viewWithTag(10) as! UIActivityIndicatorView!
        activityIndicator?.startAnimating()
        return view
    }
    
    func  collectionView(_ collectionView: UICollectionView,
                         layout collectionViewLayout: UICollectionViewLayout,
                         referenceSizeForFooterInSection section: Int) -> CGSize
    {
        if (self.totalPageCount == self.pageCountTopRated || self.totalPageCount == self.pageCountPopular || self.totalPageCount == self.pageCountNowPlaying) {
            return CGSize.zero;
        }else {
            return CGSize(width : collectionView.bounds.width, height : 40);
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        
        if offsetY > contentHeight - scrollView.frame.size.height {
            switch self.movieTypeTag {
            case 0:
                if self.pageCountTopRated != self.totalPageCount {
                    self.pageCountTopRated = self.pageCountTopRated + 1
                    self.loadTopRatedMovie()
                }
                break
            case 1 :
                
                if self.pageCountNowPlaying != self.totalPageCount {
                    self.pageCountNowPlaying = self.pageCountNowPlaying + 1
                    self.loadNowPlayingMovie()
                }
                break
            case 2 :
                if self.pageCountPopular != self.totalPageCount {
                    self.pageCountPopular = self.pageCountPopular + 1
                    self.loadPopularData()
                }
                break
            default:
                break
            }
        }
    }
}
