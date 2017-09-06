//
//  MovieCollectionViewCell.swift
//  MovieApp
//
//  Created by gopalsara on 30/08/17.
//  Copyright © 2017 gopalsara. All rights reserved.
//

import UIKit
import Kingfisher

class MovieCollectionViewCell: UICollectionViewCell {
    
    //MARK: - Outlet.
    @IBOutlet weak var lblMovieType : UILabel!
    @IBOutlet weak var lblMovieName : UILabel!
    @IBOutlet weak var imgBanner    : UIImageView!
    @IBOutlet weak var lblVoteCount : UILabel!
    @IBOutlet weak var lblReleaseDate  : UILabel!
    
    /**
     This method is used to render movie data on collection view cell.
     @param resultData is used to get movie reult data.
     */
    func doSetupDataOnCell (resultData : MovieResultViewModel){
        
        self.lblMovieType.text = resultData.title
        self.lblMovieName.text = resultData.original_title
        
        guard let posterSufix = resultData.poster_path else {
            self.imgBanner.image = UIImage(named : PLACEHOLDER)
            return
        }
        let posterPath = "\(POSTER_IMAGE_PREFIX)\(posterSufix)"
        let resource = ImageResource(downloadURL: URL(string: posterPath)!, cacheKey:posterPath)
        self.imgBanner.kf.setImage(with: resource, placeholder: #imageLiteral(resourceName: "placeHolder") , options: nil, progressBlock: nil, completionHandler: nil)
                
    }
    
    /**
     This method is used to render movie data on moive all view cell.
     @param resultData is used to get movie reult data.
     */
    func doSetupDataOnMovieDetailCell (resultData : MovieResultViewModel){
        
        self.lblMovieType.text = resultData.title
        
        guard let posterSufix = resultData.poster_path else {
            self.imgBanner.image = UIImage(named : PLACEHOLDER)
            return
        }
        let posterPath = "\(POSTER_IMAGE_PREFIX)\(posterSufix)"
        let resource = ImageResource(downloadURL: URL(string: posterPath)!, cacheKey:posterPath)
        self.imgBanner.kf.setImage(with: resource, placeholder: #imageLiteral(resourceName: "placeHolder") , options: nil, progressBlock: nil, completionHandler: nil)
        
        let strVoteCount =  String(describing: resultData.vote_count!)
        self.lblVoteCount.text = "Vote: \(strVoteCount  as String)"
        self.lblReleaseDate.text = resultData.release_date
    }
}
