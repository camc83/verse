//
//  restApiManager.swift
//  verseTest
//
//  Created by Christian Ernesto Chavarría Méndez on 08/11/18.
//  Copyright © 2018 Christian Ernesto Chavarría Méndez. All rights reserved.
//

import Foundation
import SwiftyJSON

typealias ServiceResponse = (JSON) -> Void

class restApiManager: NSObject{
    static let sharedInstance = restApiManager()
    let baseURL = vrURL
    let transform = ""
    var isTransform = false
    
    func getData(option: String, onCompletion: @escaping (JSON) -> Void) {
        let route = baseURL + option
        makeHTTPGetRequest(path: route, onCompletion: { json in
            onCompletion(json as JSON)
        })
    }
    
    func setData(option: String, query: [String: AnyObject], method: String, onCompletion: @escaping (JSON) -> Void){
        let route = baseURL + option
        makeHTTPPostRequest(path: route, body: query, method: method, onCompletion: { json in
            onCompletion(json as JSON)            //return results from request
        })
    }
    
    // MARK: Perform a GET Request
    private func makeHTTPGetRequest(path: String, onCompletion: @escaping ServiceResponse) {
        let config = URLSessionConfiguration.default // Session Configuration
        let session = URLSession(configuration: config) // Load configuration into Session
        var url: URL
        
        if(isTransform){
            url = URL(string:path + transform)!
        }else{
            url = URL(string:path)!
        }
        
        let task = session.dataTask(with: url, completionHandler: {
            (data, response, error) in
            if let jsonData = data {
                let json:JSON = JSON(data: jsonData)
                onCompletion(json)
            } else {
                onCompletion(JSON.null)
            }
        })
        task.resume()
    }
    
    // MARK: Perform a POST Request
    private func makeHTTPPostRequest(path: String, body: [String: AnyObject], method: String, onCompletion: @escaping ServiceResponse) {
        let request = NSMutableURLRequest(url: NSURL(string: path)! as URL)
        
        // Set the method to POST
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = method
        
        do {
            // Set the POST body for the request
            let jsonBody = try JSONSerialization.data(withJSONObject: body, options: .prettyPrinted)
            request.httpBody = jsonBody
            let session = URLSession.shared
            
            let task = session.dataTask(with: request as URLRequest, completionHandler: {
                (data, response, error) in
                if let jsonData = data {
                    let json:JSON = JSON(data: jsonData)
                    onCompletion(json)
                } else {
                    onCompletion(JSON.null)
                }
            })
            task.resume()
        } catch {
            // Create your personal error
            onCompletion(JSON.null)
        }
    }
}


