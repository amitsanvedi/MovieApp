//
//  ViewController.swift
//  MovieApp
//
//  Created by gopalsara on 30/08/17.
//  Copyright © 2017 gopalsara. All rights reserved.
//

import UIKit
import ObjectMapper
import ACProgressHUD_Swift

class ViewController: UIViewController , UITableViewDelegate , UITableViewDataSource , UICollectionViewDelegate , UICollectionViewDataSource {
    
    //MARK: - Outlet.
    @IBOutlet weak var tblMovie : UITableView!
    
    //MARK: - Variables.
    var movieData  = [AnyObject](){
        didSet{
            DispatchQueue.main.async() {
                self.tblMovie.reloadData()
                ACProgressHUD.shared.hideHUD()
            }
        }
    }
    var movieType  = [String]()
    
    //MARK: - Life cycle methods.
    override func viewDidLoad() {
        super.viewDidLoad()
        self.doInitialConfiguration()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Custom Method
    
    /**
     doInitialConfiguration is used to initialize the variable or the controls required properties like setting the tableView fotter and navigation title . If it is required to populate the movie type array with some initial value then that can also be done.
     */
    func doInitialConfiguration(){
        let progressView = ACProgressHUD.shared
        progressView.progressText = TITLE_PLEASE_WAIT
        progressView.showHUD()
        self.navigationItem.title = MOVIE
        self.tblMovie.tableFooterView = UIView()
        self.movieType = [TOP_RATED,NOW_PLAYING , POPULAR]
        self.loadTopRatedMovie()
        self.loadNowPlayingMovie()
        self.loadPopularData()
    }
    
    /**
     This method is used for going to detail movie list and sending section tag for differentiating movie type .
     */
    func goToViewAll (sender : UIButton){
        let controller = self.storyboard?.instantiateViewController(withIdentifier: ID_MOVIE_VIEW_ALL) as! MovieViewAllViewController
        controller.movieTypeTag = sender.tag
        let movieModelData : MovieViewModel = self.movieData[sender.tag] as! MovieViewModel
        controller.movieData.removeAll()
        controller.totalPageCount = movieModelData.total_pages
        controller.movieData = movieModelData.results as [AnyObject]
        guard let _ = self.navigationController?.pushViewController(controller, animated: true) else {
            return
        }
    }
    
    //MARK: - Webservice releated methods
    
    /**
     To consume the data from the server of currently playing the movies in theatre this method is called. After getting the response from the server the data is populated to array using the parser class which make the model for Movie and feed the data to array which shows in the tableView after reload. .
     */
    func loadNowPlayingMovie() {
        
        WebAPIManager.sharedWebAPIMAnager.doCallWebAPIForGetRequest(pageCount: PAGE_COUNTER, strType: WS_NOW_PLAYING, success: { (obj) in
            let movieData = Mapper<MovieViewModel>().map(JSON: obj)
            self.movieData.append(movieData!)
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
        
        WebAPIManager.sharedWebAPIMAnager.doCallWebAPIForGetRequest(pageCount: PAGE_COUNTER, strType: WS_TOP_RATED, success: { (obj) in
            let movieData = Mapper<MovieViewModel>().map(JSON: obj)
            self.movieData.append(movieData!)
        }) { (error) in
            DispatchQueue.main.async() {
                ACProgressHUD.shared.hideHUD()
                WebAPIManager.sharedWebAPIMAnager.showTotstOnWindow(strMessage: (error?.localizedDescription)!)
            }
        }
    }
    
    /**
     To consume the data from the server of popular movies this method is called. After getting the response from the server the data is populated to array using the parser class which make the model for Movie and feed the data to array which shows in the tableView after reload. .
     */
    func loadPopularData() {
        
        WebAPIManager.sharedWebAPIMAnager.doCallWebAPIForGetRequest(pageCount: PAGE_COUNTER, strType: WS_POPULAR, success: { (obj) in
            let movieData = Mapper<MovieViewModel>().map(JSON: obj)
            self.movieData.append(movieData!)
        }) { (error) in
            DispatchQueue.main.async() {
                WebAPIManager.sharedWebAPIMAnager.showTotstOnWindow(strMessage: (error?.localizedDescription)!)
            }
        }
    }
    
    
    //MARK: - Table view delegate and Datasource methods
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.movieData.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: ID_CELL, for: indexPath) as! MovieTableViewCell
        cell.doSetupDataOnCell (strTitle : self.movieType[indexPath.row] , delegate : self , indexPath : indexPath)
        cell.btnViewAll.addTarget(self, action: #selector(self.goToViewAll) , for: .touchUpInside)
        return cell
    }
    
    //MARK: - Collection view delegate and Datasource methods
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int  {
        let movieModelData : MovieViewModel = self.movieData[collectionView.tag] as! MovieViewModel
        return movieModelData.results.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ID_CELL, for: indexPath) as! MovieCollectionViewCell
        let movieModelData : MovieViewModel = self.movieData[collectionView.tag] as! MovieViewModel
        cell.doSetupDataOnCell(resultData: movieModelData.results[indexPath.row])
        return cell
    }
}

