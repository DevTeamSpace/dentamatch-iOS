//
//  APIManager.swift
//  DentaMatch
//
//  Created by Rajan Maheshwari on 12/10/16.
//  Copyright © 2016 Appster. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class APIManager: NSObject {

    class func apiGet(serviceName:String,parameters: [String:Any]?, completionHandler: @escaping (JSON?, NSError?) -> ()) {
        
        Alamofire.request(serviceName, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: [Constants.ServerKey.accessToken:getAccessToken()]).responseJSON { (response:DataResponse<Any>) in
            
            switch(response.result) {
            case .success(_):
                if let data = response.result.value{
                    let json = JSON(data)
                    if json[Constants.ServerKey.statusCode].intValue == 204 {
                        //Invalid Token, Log out
                        Utilities.logOutOfInvalidToken()
                    }
                    completionHandler(json,nil)
                }
                break
                
            case .failure(_):
                completionHandler(nil,response.result.error as NSError?)
                break
                
            }
        }
    }
    
    class func apiPost(serviceName:String,parameters: [String:Any]?, completionHandler: @escaping (JSON?, NSError?) -> ()) {
        
        Alamofire.request(serviceName, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: [Constants.ServerKey.accessToken:getAccessToken()]).responseJSON { (response:DataResponse<Any>) in
            
            switch(response.result) {
            case .success(_):
                if let data = response.result.value{
                    let json = JSON(data)
                    if json[Constants.ServerKey.statusCode].intValue == 204 {
                        //Invalid Token, Log out
                        Utilities.logOutOfInvalidToken()
                    }
                    completionHandler(json,nil)
                }
                break
                
            case .failure(_):
                completionHandler(nil,response.result.error as NSError?)
                break
                
            }
        }
    }
    
    class func apiPostWithJSONEncode(serviceName:String,parameters: [String:Any]?, completionHandler: @escaping (JSON?, NSError?) -> ()) {
        
        Alamofire.request(serviceName, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: [Constants.ServerKey.accessToken:getAccessToken()]).responseJSON { (response:DataResponse<Any>) in
            
            switch(response.result) {
            case .success(_):
                if let data = response.result.value{
                    let json = JSON(data)
                    if json[Constants.ServerKey.statusCode].intValue == 204 {
                        //Invalid Token, Log out
                        Utilities.logOutOfInvalidToken()
                    }
                    completionHandler(json,nil)
                }
                break
                
            case .failure(_):
                completionHandler(nil,response.result.error as NSError?)
                break
                
            }
        }
    }
    
    class func apiPut(serviceName:String,parameters: [String:Any]?, completionHandler: @escaping (JSON?, NSError?) -> ()) {
        
        Alamofire.request(serviceName, method: .put, parameters: parameters, encoding: URLEncoding.default, headers: [Constants.ServerKey.accessToken:getAccessToken()]).responseJSON { (response:DataResponse<Any>) in
            
            switch(response.result) {
            case .success(_):
                if let data = response.result.value{
                    let json = JSON(data)
                    if json[Constants.ServerKey.statusCode].intValue == 204 {
                        //Invalid Token, Log out
                        Utilities.logOutOfInvalidToken()
                    }
                    completionHandler(json,nil)
                }
                break
                
            case .failure(_):
                completionHandler(nil,response.result.error as NSError?)
                break
                
            }
        }
    }
    
    class func apiDelete(serviceName:String,parameters: [String:Any]?, completionHandler: @escaping (JSON?, NSError?) -> ()) {
        
        Alamofire.request(serviceName, method: .delete, parameters: parameters, encoding: URLEncoding.default, headers: [Constants.ServerKey.accessToken:getAccessToken()]).responseJSON { (response:DataResponse<Any>) in
            
            switch(response.result) {
            case .success(_):
                if let data = response.result.value{
                    let json = JSON(data)
                    if json[Constants.ServerKey.statusCode].intValue == 204 {
                        //Invalid Token, Log out
                        Utilities.logOutOfInvalidToken()
                    }
                    completionHandler(json,nil)
                }
                break
                
            case .failure(_):
                completionHandler(nil,response.result.error as NSError?)
                break
                
            }
        }
    }

    
    class func apiMultipart(serviceName:String,parameters: [String:Any]?, completionHandler: @escaping (JSON?, NSError?) -> ()) {
        
        Alamofire.upload(multipartFormData: { (multipartFormData:MultipartFormData) in
            for (key, value) in parameters! {
                if key == "image" {
                    multipartFormData.append(
                        value as! Data,
                        withName: key,
                        fileName: "profileImage.jpg",
                        mimeType: "image/jpg"
                    )
                } else {
                    //multipartFormData
                    multipartFormData.append((value as! String).data(using: .utf8)!, withName: key)
                }
            }
        }, usingThreshold: 1, to: serviceName, method: .post, headers: [Constants.ServerKey.accessToken:getAccessToken()]) { (encodingResult:SessionManager.MultipartFormDataEncodingResult) in
            
            switch encodingResult {
            case .success(let upload, _, _):
                upload.responseJSON { response in
                    if response.result.error != nil {
                        completionHandler(nil,response.result.error as NSError?)
                        return
                    }
                    print(response.result.value!)
                    if let data = response.result.value {
                        let json = JSON(data)
                        if json[Constants.ServerKey.statusCode].intValue == 204 {
                            //Invalid Token, Log out
                            Utilities.logOutOfInvalidToken()
                        }
                        completionHandler(json,nil)
                    }
                }
                break
                
            case .failure(let encodingError):
                print(encodingError)
                completionHandler(nil,encodingError as NSError?)
                break
            }
        }
    }
    
    class func getAccessToken()-> String {
        if let user = UserManager.shared().activeUser {
            return user.accessToken
        }
        return ""
    }
}
