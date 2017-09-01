//
//  MovieDateViewModel.swift
//  MovieApp
//
//  Created by gopalsara on 30/08/17.
//  Copyright © 2017 gopalsara. All rights reserved.
//

import UIKit
import ObjectMapper

class MovieDateViewModel: Mappable {
    
    //MARK: - Model class veriabel
    var maximum          : String?
    var minimum          : String?
    
    required init?(map: Map) {
        mapping(map: map)
    }
    
    func mapping(map: Map) {
        maximum <- map["maximum"]
        minimum <- map["minimum"]
    }
}
