//
//  LaunchesModel.swift
//  SystemTest
//
//  Created by apple on 09/03/2022.
//

import Foundation

struct LaunchesModel: Codable {
    var mission_name : String?
    var launch_date_utc : String?
    var rocket : RocketObject?
    var launch_site: LaunchSiteObject?
    var links: LaunchImage?
    var details: String?
    var launch_success: Bool?
}
struct RocketObject: Codable {
    var rocket_name: String?
    var rocket_type: String
}

struct LaunchSiteObject: Codable {
    var site_name: String?
}

struct LaunchImage: Codable {
    var mission_patch_small : String?
}
