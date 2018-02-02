//
//  NetworkManager.swift
//  TableListing
//
//  Created by Ajay S Moorthy on 19/01/18.
//  Copyright © 2018 myyshopp. All rights reserved.
//

import Foundation
import Alamofire

public typealias successClosure = (_ result:[String:AnyObject]) -> Void
public typealias errorClosure = (_ error:Error) -> Void

enum ApiWebServiceType:String {
    case URLSession = "URLSession"
    case Alamofire = "Alamofire"
}

class NetworkManager {
    
    // MARK: - Public Functions -
    
    public class func performWebServiceRequest(withType apiType:ApiWebServiceType, toURL urlString:String, withParameters parameters:[String:AnyObject], onSuccessCallBack successCB:@escaping successClosure, andOnError errorCB:@escaping errorClosure) {
        
        guard let validURL = URL(string: urlString) else {
            let error = NSError(domain: "Invalid URL", code: 404, userInfo: nil)
            errorCB(error as Error)
            return
        }
        
        if apiType == .URLSession {
            performWebServiceRequestUsingURLSessionPost(toURL: validURL, withParameters: parameters, andSuccess: successCB, andOnError: errorCB)
        } else if apiType == .Alamofire {
            performWebServiceRequestUsingAlamofirePost(toURL: validURL, withParameters: parameters, andSuccess: successCB, andOnError: errorCB)
        } else {
            debugPrint("Unknown Api Web Service Type")
        }
    
    }
    
    // MARK: - Private Functions -
    private class func performWebServiceRequestUsingURLSessionPost(toURL Url:URL, withParameters parameters:[String:AnyObject]?, andSuccess successCB:@escaping successClosure, andOnError errorCB:@escaping errorClosure) {
        
//        let url = URL(string: "https://api.myjson.com/bins/vi56v")
        let task = URLSession.shared.dataTask(with: Url) {(data, response, error) in
            guard error == nil else {
                errorCB(error!)
                print("Returning error")
                return
            }
            guard let content = data else {
                print("Not returning data")
                return
            }
            
            guard let json = (try? JSONSerialization.jsonObject(with: content, options: JSONSerialization.ReadingOptions.mutableContainers)) as? [String: AnyObject] else {
                print("Not containing JSON")
                return
            }
            
            if let array = json["companies"] as? [String] {
                print(array)
            }
            DispatchQueue.main.async {
                successCB(json)
            }
        }
        task.resume()
        
    }
    
    private class func performWebServiceRequestUsingAlamofirePost(toURL Url:URL, withParameters parameters:[String:AnyObject]?, andSuccess successCB:@escaping successClosure, andOnError errorCB:@escaping errorClosure) {
        
        Alamofire.request(Url, method: .post, parameters: parameters, encoding: URLEncoding.httpBody, headers: nil)
            .validate()
            .responseJSON {
            (response:DataResponse<Any>) in
            switch(response.result){
            case .success(_):
                if let _data = response.result.value as? [String:AnyObject] {
                    successCB(_data)
                }
            case .failure(_):
                if let _error = response.result.error {
                    errorCB(_error)
                }
            }
        }
        
    }
    
}
