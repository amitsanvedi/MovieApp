
import Foundation
import UIKit

//////////////////////// Base url and image prefix url path and api key ////////////////////////////////////

let BASE_URL        = "https://api.themoviedb.org/3/movie/"
let API_KEY         = "8c521a84c9841d3c4ea85d4011ea60b3"
let POSTER_IMAGE_PREFIX   = "https://image.tmdb.org/t/p/w500"

//////////////////   Device width factor and height factor   /////////////////////////////////////////

let UNIVERSAL_WIDTH = UIScreen.main.bounds.size.width
let UNIVERSAL_HEIGHT = UIScreen.main.bounds.size.height
let WIDTH_FACTOR: CGFloat = UNIVERSAL_WIDTH/320.0
let HEIGHT_FACTOR : CGFloat = UNIVERSAL_HEIGHT/568.0

///////////////////////////////////////Collection view cell height //////////////////////

let CELL_HEIGHT : CGFloat = 180
let CELL_FOOTER_HEIGHT : CGFloat = 40
let CELL_MARGIN : CGFloat = 2



///////////////////////////////// Loader view title /////////////////////////////////////

let TITLE_PLEASE_WAIT = "Please wait..."


//////////////////////////////// Navigation title ////////////////////////////////////////

let NOW_PLAYING = "Now Playing"
let TOP_RATED   = "Top Rated"
let POPULAR     = "Popular"
let MOVIE       = "Movie"

////////////////////////////// Webservice methods name //////////////////////////////////

let WS_TOP_RATED      = "top_rated"
let WS_NOW_PLAYING    = "now_playing"
let WS_POPULAR        = "popular"

/////////////////////////// Collection view and table view cell identifier ////////////////////////////

let ID_CELL = "cell"
let ID_FOOTER = "footerView"

///////////////////////// Controller identifier //////////////////////////////////////////////////

let ID_MOVIE_VIEW_ALL = "MovieViewAllViewController"


/////////////////////// Images name /////////////////////////////////////////////////////////////

let PLACEHOLDER  = "placeHolder.png"

/////////////////////////////// Page counter ////////////////////////////////////////////////////

let PAGE_COUNTER = 1

/////////////////////////////// minimum vote count //////////////////////////////////////////////

let MIN_VOTE_COUNT = 500


