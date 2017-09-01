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
     */
    func doSetupDataOnCell (strTitle : String){
        self.lblTitle.text = strTitle
    }
}
