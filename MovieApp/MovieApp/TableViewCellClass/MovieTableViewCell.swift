//
//  MovieTableViewCell.swift
//  MovieApp
//
//  Created by gopalsara on 30/08/17.
//  Copyright © 2017 gopalsara. All rights reserved.
//

import UIKit

class MovieTableViewCell: UITableViewCell {
    
    //MARK: - Outlet.
    @IBOutlet weak var  collectionView : UICollectionView!
    @IBOutlet weak var  lblTitle       : UILabel!
    @IBOutlet weak var  btnViewAll     : UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.btnViewAll.layer.cornerRadius = 10.0
        self.btnViewAll.layer.borderWidth = 1.0
        self.btnViewAll.layer.borderColor = UIColor.gray.cgColor
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    /**
     This method is used to set movie type on table view l.
     @param strTitle is used to get the type of movie.
     @param delegate is used to get view controller object.
     @param indexPath is used to get table view cell indexPath.
     */
    
    func doSetupDataOnCell(strTitle : String , delegate: ViewController , indexPath : IndexPath){
        
        self.lblTitle.text = strTitle
        self.collectionView.tag = indexPath.row
        self.collectionView.dataSource = delegate
        self.collectionView.delegate   = delegate
        self.btnViewAll.tag = indexPath.row
    }
}
