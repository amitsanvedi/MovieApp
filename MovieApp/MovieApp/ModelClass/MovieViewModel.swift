//
//  MovieViewModel.swift
//  MovieApp
//
//  Created by gopalsara on 30/08/17.
//  Copyright © 2017 gopalsara. All rights reserved.
//

import UIKit
import ObjectMapper

class MovieViewModel: Mappable {
    
    //MARK: - Model class veriabel
    var results       : [MovieResultViewModel] = []
    var page          : NSInteger?
    var total_results : NSInteger?
    var dates         : [MovieDateViewModel] = []
    var total_pages   : NSInteger?
    
    required init?(map: Map) {
        mapping(map: map)
    }
    
    func mapping(map: Map) {
        results <- map["results"]
        page <- map["page"]
        total_results <- map["total_results"]
        dates <- map["dates"]
        total_pages <- map["total_pages"]
    }
    
}
