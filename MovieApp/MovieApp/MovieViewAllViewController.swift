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
    var pageCount           : Int = 2
    var movieTypeTag        : Int!
    var movieData           = [AnyObject]() {
        didSet{
            DispatchQueue.main.async() {
                guard let collectionView = self.collectionView else {
                    return
                }
                collectionView.reloadData()
            }
        }
    }
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
            self.navigationItem.title = TOP_RATED
            self.loadTopRatedMovie()
            break
        case 1 :
            self.navigationItem.title = NOW_PLAYING
            self.loadNowPlayingMovie()
            break
        case 2 :
            self.navigationItem.title = POPULAR
            self.loadPopularData()
            break
        default:
            break
        }
    }
    
    /**
     This method is used for filtering an movie array which contain greater then 500 votes.
     */
    func filterTopRatedMovie(resultData : [AnyObject]) {
        
        let movieArray : [MovieResultViewModel] = resultData as! [MovieResultViewModel]
        let filterArray = movieArray.filter { $0.vote_count! > MIN_VOTE_COUNT }
        
        DispatchQueue.global(qos: .background).async {
            self.movieData += filterArray as [AnyObject]
        }
    }
    
    //MARK: - Webservice releated methods
    
    /**
     To consume the data from the server of currently playing the movies in theatre this method is called. After getting the response from the server the data is populated to array using the parser class which make the model for Movie and feed the data to array which shows in the tableView after reload. .
     */
    func loadNowPlayingMovie() {
        
        WebAPIManager.sharedWebAPIMAnager.doCallWebAPIForGetRequest(pageCount: self.pageCount, strType: WS_NOW_PLAYING, success: { (obj) in
            let movieData :  MovieViewModel = Mapper<MovieViewModel>().map(JSON: obj)!
            self.movieData += movieData.results as [AnyObject]

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
        
        WebAPIManager.sharedWebAPIMAnager.doCallWebAPIForGetRequest(pageCount: self.pageCount, strType: WS_TOP_RATED, success: { (obj) in
            let movieData :  MovieViewModel  = Mapper<MovieViewModel>().map(JSON: obj)!
           // self.movieData += movieData.results as [AnyObject]
            self.filterTopRatedMovie(resultData : movieData.results as [AnyObject])
        }) { (error) in
            DispatchQueue.main.async() {
                WebAPIManager.sharedWebAPIMAnager.showTotstOnWindow(strMessage: (error?.localizedDescription)!)
            }
        }
    }
    
    /**
     To consume the data from the server of popular movies this method is called. After getting the response from the server the data is populated to array using the parser class which make the model for Movie and feed the data to array which shows in the tableView after reload .
     */
    func loadPopularData() {
        
        WebAPIManager.sharedWebAPIMAnager.doCallWebAPIForGetRequest(pageCount: self.pageCount, strType: WS_POPULAR, success: { (obj) in
            let movieData :  MovieViewModel = Mapper<MovieViewModel>().map(JSON: obj)!
            self.movieData += movieData.results as [AnyObject]
        }) { (error) in
            
            DispatchQueue.main.async() {
                WebAPIManager.sharedWebAPIMAnager.showTotstOnWindow(strMessage: (error?.localizedDescription)!)
            }
        }
    }
   
    /**
     This method will be used to Increase page count and decide load more method should be called or not.
     */
    
    func isLoadMore () -> Bool{
        
        if self.pageCount != self.totalPageCount {
            self.pageCount +=  1
            return true
        }
        else{
            return false
        }
    }

    
    //MARK: - Collection view delegate and Datasource methods
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int  {
        
        return self.movieData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ID_CELL, for: indexPath) as! MovieCollectionViewCell
        if let movieModelData : MovieResultViewModel = self.movieData[indexPath.row] as? MovieResultViewModel {
            cell.doSetupDataOnMovieDetailCell(resultData: movieModelData)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UNIVERSAL_WIDTH/CELL_MARGIN - CELL_MARGIN , height: CELL_HEIGHT * HEIGHT_FACTOR);
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let view = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionFooter, withReuseIdentifier: ID_FOOTER, for: indexPath as IndexPath)
        let activityIndicator = view.viewWithTag(10) as! UIActivityIndicatorView!
        activityIndicator?.startAnimating()
        return view
    }
    
    func  collectionView(_ collectionView: UICollectionView,
                         layout collectionViewLayout: UICollectionViewLayout,
                         referenceSizeForFooterInSection section: Int) -> CGSize
    {
        if (self.totalPageCount != self.pageCount) {
            return CGSize(width : collectionView.bounds.width, height : CELL_FOOTER_HEIGHT);
        }else {
            return CGSize.zero;
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == (self.movieData.count-1) {
            switch self.movieTypeTag {
            case 0:
                if (self.isLoadMore()) {
                    self.loadTopRatedMovie()
                }
                break
            case 1 :
                if (self.isLoadMore()) {
                    self.loadNowPlayingMovie()
                }
                break
            case 2 :
                if (self.isLoadMore()) {
                    self.loadPopularData()
                }
                break
            default:
                break
            }
        }
    }
    
    
    
}
