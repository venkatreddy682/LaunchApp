//
//  NetWorkManager.swift
//  SystemTest
//
//  Created by apple on 09/03/2022.
//

import Foundation
import UIKit
import Reachability

class NetWorkManager {
    
    static let shared = NetWorkManager()
    private var delegate: UIViewController?
    
    func initiateServiceCall(_ serviceUrl: String ,_ params: String?,_ methodType: String?, _ delegate: UIViewController?, _ completionHandler: @escaping (_ data:Any?,_ error:Error?)->Void) {
        
        self.delegate = delegate
        let reachability = try! Reachability()
        if reachability.connection == .unavailable {
            AppSharedManager.presentationAlert(title: ALERT_TITLE, message: NO_INTERNET_ALERT, addButtons: [OK_TEXT], viewController: nil) { (alertCOntroller, alertAction) in
             }
            completionHandler(nil, nil)
            return
        }
        var serviceUrlformat:String = ""
        if methodType == GET_REQUEST {
            if !(params?.isEmpty ?? false) {
                serviceUrlformat = String(format:"%@?%@",serviceUrl,params!)
            } else {
                serviceUrlformat = serviceUrl
            }
        }
        let set = CharacterSet.urlQueryAllowed
        guard let encodedUrlAsString = serviceUrlformat.addingPercentEncoding(withAllowedCharacters: set) else { return }
        let urlPoint=URL(string:encodedUrlAsString)
        guard let url = urlPoint  else { return }
        
        var request = URLRequest(url:url)
        request.timeoutInterval = TimeInterval(REQUEST_TIMEOUT)
        request.cachePolicy = .reloadIgnoringLocalCacheData
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = methodType
        
        let session = URLSession.shared
        let task=session.dataTask(with: request) { (data, response, error) in
            
            if let urlResponse = response as? HTTPURLResponse , urlResponse.statusCode == 404 {
                self.showResponseErrorAlert(errorMessage: SERVER_NOT_FOUND)
                DispatchQueue.main.async(execute: {() -> Void in
                    completionHandler(nil, nil)
                })
                return
            }
            
            guard error == nil else {
                self.showResponseErrorAlert(errorMessage: error?.localizedDescription ?? SOMETHING_WRONG)
                DispatchQueue.main.async(execute: {() -> Void in
                    completionHandler(nil, error)
                })
                return
            }
            guard let responseData = data else {
                print("Error: did not receive data")
                DispatchQueue.main.async(execute: {() -> Void in
                    completionHandler(nil, error)
                })
                return
            }
            do {
                let jsonDecoder = JSONDecoder()
                let responseData = try jsonDecoder.decode([LaunchesModel].self, from: responseData)
                DispatchQueue.main.async(execute: {() -> Void in
                    completionHandler(responseData, error)
                    
                })
            }
            catch let error {
                print("Error while converting data to JSON")
                self.showResponseErrorAlert(errorMessage: error.localizedDescription)
                DispatchQueue.main.async(execute: {() -> Void in
                    completionHandler(nil, error)
                })
            }
        }
        task.resume()
    }
    
    private func checkInternetConnection(completionHandler: @escaping (_ isNetetworkAvailable:Bool)->Void) {
        
        var isReachable = false
        do {
            let reachability = try Reachability()
            if reachability.connection == .cellular || reachability.connection == .wifi {
                isReachable = true
            }
            completionHandler(isReachable)
        }
        catch {
            completionHandler(isReachable)
        }
    }
    
    private func showResponseErrorAlert(errorMessage: String) {
        DispatchQueue.main.async {
            AppSharedManager.presentationAlert(title: ERROR_TEXT, message: errorMessage, addButtons: [OK_TEXT], viewController: nil) { (alertCOntroller, alertAction) in
                // do nothing
            }
        }
    }
}
