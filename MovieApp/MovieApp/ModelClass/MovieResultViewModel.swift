//
//  MovieResultViewModel.swift
//  MovieApp
//
//  Created by gopalsara on 30/08/17.
//  Copyright © 2017 gopalsara. All rights reserved.
//



import UIKit
import ObjectMapper

class MovieResultViewModel: Mappable {
    
    //MARK: - Model class veriabel
    var vote_count        : NSInteger?
    var id                : NSInteger?
    var video             : Bool?
    var vote_average      : Float?
    var total_pages       : Int?
    var title             : String?
    var popularity        : Float?
    var poster_path       : String?
    var original_language : String?
    var original_title    : String?
    var backdrop_path     : String?
    var adult             : Bool?
    var overview          : String?
    var release_date      : String?
    var genre_ids         : [String] = []
    
    required init?(map: Map) {
        mapping(map: map)
    }
    
    func mapping(map: Map) {
        vote_count <- map["vote_count"]
        id <- map["id"]
        video <- map["video"]
        vote_average <- map["vote_average"]
        total_pages <- map["total_pages"]
        title <- map["title"]
        popularity <- map["popularity"]
        poster_path <- map["poster_path"]
        original_language <- map["original_language"]
        original_title <- map["original_title"]
        backdrop_path <- map["backdrop_path"]
        adult <- map["adult"]
        overview <- map["overview"]
        release_date <- map["release_date"]
        genre_ids <- map["genre_ids"]
    }
}
