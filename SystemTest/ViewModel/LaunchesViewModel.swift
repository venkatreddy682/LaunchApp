//
//  LaunchesViewModel.swift
//  SystemTest
//
//  Created by apple on 09/03/2022.
//

import Foundation
import UIKit

class LaunchesViewModel {

    func callgetLaunchesAPI(params: String, delegate:UIViewController?, completionHandler: @escaping (_ responseArray:[LaunchesModel]?,_ error:Error?)->Void) {
        NetWorkManager.shared.initiateServiceCall(SERVICE_BASE_URL, params, GET_REQUEST, delegate) { responseObj, error in
            if error == nil {
                if let launchDataObj = responseObj as? [LaunchesModel] {
                    completionHandler(launchDataObj,error)
                }
            }
        }
    }
}
