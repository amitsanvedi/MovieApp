//
//  WebAPIManager.swift
//  inDJ
//
//  Created by gopalsara on 27/07/17.
//  Copyright © 2017 padio. All rights reserved.
//

import UIKit
import Toast

class WebAPIManager: NSObject {
    
    //MARK :- Shared Instance
    class var  sharedWebAPIMAnager: WebAPIManager {
        struct Static {
            static var instance : WebAPIManager? = nil
        }
        if !(Static.instance != nil) {
            Static.instance = WebAPIManager()
        }
        return Static.instance!
    }
    
    /**
     This method is used to call webservice for Movie list.
     
     - parameter success: parameter is used to return success block.
     - parameter failure: parameter is used to return failure block.
     - Parameter pageCount is used to get current page response from server.
     - Parameter strType is used to pass Top Rated , Popular and Now Release types.
     -
     */
    func doCallWebAPIForGetRequest(pageCount : Int , strType : String , success: @escaping (_ obj : [String: Any]) -> Void , failure: @escaping (_ error: NSError?) -> Void) {
        
        let url = URL(string: "\(BASE_URL)\(strType)?page=\(pageCount)&language=en-US&api_key=\(API_KEY)")
        
        let task = URLSession.shared.dataTask(with: url!) { data, response, error in
            guard error == nil else {
                print(error!)
                failure(error as NSError?)
                return
            }
            guard let data = data else {
                return
            }
            do {
                if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]{
                    success(json)
                }
            } catch {
                failure(error as NSError?)
            }
        }
        task.resume()
    }

    /**
     This method is used to show a toast on the screen with some message.
     
     @param strMessage is the message to show.
     */
     func showTotstOnWindow(strMessage: String) {
        
        DispatchQueue.main.async() {
            let window :UIWindow = ((UIApplication.shared.delegate?.window)!)!
            window.makeToast(strMessage)
        }
    }
}




