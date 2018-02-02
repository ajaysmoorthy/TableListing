//
//  WebServiceAPI.swift
//  TableListing
//
//  Created by Ajay S Moorthy on 19/01/18.
//  Copyright © 2018 myyshopp. All rights reserved.
//

import Foundation

public typealias successCB = (_ result:[String:AnyObject]) -> Void
public typealias errorCB = (_ error:Error) -> Void

class WebServiceAPI {
    public class func trialWebService(_ requiredData:[String:AnyObject], onSuccess successCallBack:@escaping successCB, andOnError errorCallBack:@escaping errorCB ) {
        
        NetworkManager.performWebServiceRequest(withType: .Alamofire, toURL: "http://myyshopp-test-new.us-west-1.elasticbeanstalk.com/ads/api/v1.1/restaurant/paymentOptions", withParameters: requiredData, onSuccessCallBack: { (result) in
            successCallBack(result)
        }) { (error) in
            errorCallBack(error)
        }
        
    }
}
