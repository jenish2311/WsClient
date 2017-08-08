//
//  WSClient.swift
//  Alamofier
//
//  Created by Jenish on 03/01/17.
//  Copyright © 2017 jenish. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
import SystemConfiguration
import SVProgressHUD

enum WSRequestType : Int
{
    case WSRequestType_getfeedlist = 1
   
}

enum WSAPI : String
{
    case getfeedlist           = "app/getfeedlist"
    
}

enum UploadImgType : Int
{
    case ImgType_ProfilePic = 1
    case ImgType_CoverPic
}

enum ImgPath : String
{
    case ProfilePicPath = "user/updateuser"
    case CoverPicPath   = "Cover"
}

enum MultipartUploadStatus {
    case success(progress : Float, response : AnyObject?)
    case uploading(progress: Float)
    case failure(error : NSError?)
}

class WSClient: NSObject {
    
    static let sharedInstance : WSClient = {
        let instance = WSClient()
        return instance
    }()
    
    //MARK:- Base URL

    let BaseURL = "http://"
    let BasePathImgUpload = "http://"
    let ParameterKey = "params"
    
    //MARK:- Get API
   private func getAPI(apiType : WSRequestType) -> String
    {
        switch apiType
        {
        case .WSRequestType_getfeedlist:
            return BaseURL+WSAPI.getfeedlist.rawValue
        
        }
    }
    
    //MARK:- Convert Dictionary to Json
    private func convertDictToJson(dict : NSDictionary) -> NSDictionary?
    {
        var jsonDict : NSDictionary!
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject:dict, options:[])
            let jsonDataString = String(data: jsonData, encoding: String.Encoding.utf8)!
            print("Post Request Params : \(jsonDataString)")
            jsonDict = [ParameterKey : jsonDataString]            
            return jsonDict
        } catch {
            print("JSON serialization failed:  \(error)")
            jsonDict = nil
        }
        return jsonDict
    }
    
    //MARK:- Post Request
    func postRequestForAPI(apiType : WSRequestType, parameters : NSDictionary? = nil, completionHandler:@escaping (_ responseObject : NSDictionary?, _ error : NSError?) -> Void)
    {
        if !WSClient.sharedInstance.isConnectedToNetwork(){
            CommonUnit.progressHUD(.dismissProgress)
            CommonUnit.alertController(Constant.LocalizationKey.Error as NSString, message: Constant.LocalizationKey.NoNetworkMsg, okTitle: Constant.LocalizationKey.OK, okCompletion: {
            })
            return
        }
        
        let apipath : String = getAPI(apiType: apiType)
        var apiParams : NSDictionary!
        
        if (parameters != nil)
        {
           apiParams = convertDictToJson(dict: parameters!)
        }
        
        print("Post Requset URL : \(apipath)")
        
        //--------------------------------------------------------------------------------------
        //Send "device_type", "device_token", "app_version" in header
        var appVersion: String? = ""
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            appVersion = version
        }
        
        if (UserDefaults.standard.string(forKey: "HeaderToken")) == nil{
            UserDefaults.standard.set("", forKey: "HeaderToken")
        }

        //Constant.GlobalVars.HeaderToken = UserDefaults.standard.string(forKey: "HeaderToken")!

        let requestHeader: HTTPHeaders = [
            "header_token": (UserDefaults.standard.string(forKey: "HeaderToken")!),
            "device_type": "1",
            "device_token": Constant.Common.DeviceToken,
            "app_version": appVersion!,
            "app_type":"1",                 //1-UserApp,2-DriverApp
            "Accept": "application/json"
        ]
        print("Header : \(requestHeader)")
        
        Alamofire.request(apipath, method: .post, parameters: apiParams as? Parameters, encoding: URLEncoding.default, headers: requestHeader)
            .responseJSON { response in
                switch(response.result) {
                case .success(_):
                    do {
                        let JSON = try JSONSerialization.jsonObject(with: response.data! as Data, options:JSONSerialization.ReadingOptions(rawValue: 0))
                        
                        guard let JSONDictionary: NSDictionary = JSON as? NSDictionary else {
                            print("Not a Dictionary")
                            return
                        }
                        
                        print("Response : \(JSONDictionary)")
                        
                        /*if let status = Int(CommonUnit.sharedInstance.checkIfNull(someObject: JSONDictionary[Constant.Key.status] as AnyObject)){
                            if status == Constant.StatusCode.SuccessStatus{
                               
                            }else if status == Constant.StatusCode.UnAuthorisedToken{
                                NotificationCenter.default.post(name: Constant.notification.refreshNewTrip, object: nil)
                                Constant.ViewControllerObj.CustomTabVC.setSelectedTabIndx(tabBarIndex.newTrip.rawValue)
                                Constant.Common.APPDELObj.ObjNav = UINavigationController.init(rootViewController: Constant.Common.Storyboard.instantiateViewController(withIdentifier: Constant.ViewIdentifiers.LogInVC) as! LogInVC)
                                UserDefaults.standard.set("", forKey: "HeaderToken")
                                UIApplication.shared.keyWindow?.rootViewController = Constant.Common.APPDELObj.ObjNav
                            }
                        }*/
                        CommonUnit.progressHUD(.dismissProgress)
                        completionHandler(JSONDictionary,nil)
                    }
                    catch let JSONError as NSError {
                        print("\(JSONError)")
                    }
                    break
                case .failure(_):
                    
                    CommonUnit.progressHUD(.dismissProgress)
                    print("failure Http: \(String(describing: response.result.error?.localizedDescription))")
                    completionHandler(nil,response.result.error! as NSError)
                    break
                }
        }
    }
    
    //MARK:- Get Request
    func getRequestForAPI(apiType : WSRequestType, completionHandler:@escaping (_ responseObject : NSDictionary?, _ error : NSError?) -> Void)
    {
        let apipath : String = getAPI(apiType: apiType)
        
        print("Get Requset URL : \(apipath)")
        
        let headers: HTTPHeaders = ["token":"69723e64-b6dc-11e6-9927-02330b50d5d7" , "device_type":"1" , "app_version":"1"]
        
        Alamofire.request(apipath, method: .get, parameters: ["":""], encoding: URLEncoding.default, headers: headers)
            .responseJSON { response in
                switch(response.result) {
                case .success(_):
                    do {
                        let JSON = try JSONSerialization.jsonObject(with: response.data! as Data, options:JSONSerialization.ReadingOptions(rawValue: 0))
                        
                        guard let JSONDictionary: NSDictionary = JSON as? NSDictionary else {
                            print("Not a Dictionary")
                            return
                        }
                        
                        completionHandler(JSONDictionary,nil)
                    }
                    catch let JSONError as NSError {
                        print("\(JSONError)")
                    }
                    
                    break
                case .failure(_):
                    print("failure Http: \(String(describing: response.result.error?.localizedDescription))")
                    completionHandler(nil,response.result.error! as NSError)
                    break
                }
        }
    }
    
    //MARK:- Get Image Upload Path
    func getImgUploadPath(imgType : UploadImgType) -> String
    {
        switch imgType
        {
        case .ImgType_CoverPic:
            return BasePathImgUpload+ImgPath.CoverPicPath.rawValue
        case .ImgType_ProfilePic:
            return BasePathImgUpload+ImgPath.ProfilePicPath.rawValue
        }
    }
    
    //MARK:- Image Upload multipart
    func imageUploadFromURL(imgType: UploadImgType, strImage : String, parameter: [String:String]? = nil, completionHandler: @escaping (_ uploadStatus : MultipartUploadStatus) -> Void) {
        downloadImage(url: strImage) { (_ error : NSError?, _ image : UIImage?) -> Void in
            self.imageUpload(imgType: imgType, image: image!, parameter: parameter) { (_ imgUploadStatus) in
                completionHandler(imgUploadStatus)
            }
        }
    }
    
    func imageUpload(imgType: UploadImgType, image : UIImage, parameter: [String:String]? = nil, completionHandler: @escaping (_ uploadStatus : MultipartUploadStatus) -> Void) {
        
        let uploadPath : String = getImgUploadPath(imgType: imgType)
        let imgData : Data = UIImageJPEGRepresentation(image, 1.0)!
        
        var appVersion: String? = ""
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            appVersion = version
        }
        
        let requestHeader: HTTPHeaders = [
            //"header_token": (UserDefaults.standard.string(forKey: "HeaderToken")!),
            "device_type": "1",
            //"device_token": Constant.GlobalVars.DeviceToken,
            "app_version": appVersion!,
            "app_type":"1",                 //1-UserApp,2-DriverApp
            "Accept": "application/json"
        ]
        
        var apiParams : NSDictionary!
        
        if (parameter != nil)
        {
            apiParams = convertDictToJson(dict: parameter! as NSDictionary)
        }
        
        print("Params : \(String(describing: apiParams)) and Header : \(requestHeader)")
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            multipartFormData.append(imgData, withName: "filedata", fileName: "filedata.jpg", mimeType: "image/jpeg")
            print("mutlipart 1st \(multipartFormData)")
            if (apiParams != nil)
            {
                for (key, value) in apiParams! {
                    multipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key as! String )
                }
                print("mutlipart 2nd \(multipartFormData)")
            }
        }, to:uploadPath, method:.post, headers:requestHeader)
        { (result) in
            switch result {
            case .success(let upload, _, _):
                
                upload.uploadProgress(closure: { (Progress) in
                    completionHandler(.uploading(progress: Float(Progress.fractionCompleted)))
                })
                
                upload.responseJSON { response in
                    
                    if let JSON = response.result.value {
                        completionHandler(.success(progress: 1.0, response: JSON as! NSDictionary))
                    }
                }
            case .failure(let encodingError):
                print(encodingError)
                completionHandler(.failure(error: encodingError as NSError))
            }
        }
    }
    
    //MARK:- Image Downloader
    func downloadImage(url: String, completionHandler: @escaping (_ error: NSError?, _ image:UIImage?)-> Void) {
        Alamofire.request(url)
            .downloadProgress { progress in
                //print("Download Progress: \(progress.fractionCompleted)")
                SVProgressHUD.showProgress(Float(progress.fractionCompleted))
            }
            .responseData { response in
                if let data = response.result.value {
                    let image = UIImage(data: data)
                    SVProgressHUD.dismiss()
                    completionHandler(response.result.error as NSError?,image)
                }
        }
    }
    
    func isConnectedToNetwork() -> Bool {
        
        var zeroAddress = sockaddr_in(sin_len: 0, sin_family: 0, sin_port: 0, sin_addr: in_addr(s_addr: 0), sin_zero: (0, 0, 0, 0, 0, 0, 0, 0))
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)

        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }

        var flags: SCNetworkReachabilityFlags = SCNetworkReachabilityFlags(rawValue: 0)
        if SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) == false {
            return false
        }
        
        /* Only Working for WIFI
         let isReachable = flags == .reachable
         let needsConnection = flags == .connectionRequired
         
         return isReachable && !needsConnection
         */
        
        // Working for Cellular and WIFI
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        let ret = (isReachable && !needsConnection)

        return ret
    }
}
