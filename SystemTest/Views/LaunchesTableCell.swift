//
//  LaunchesTableCell.swift
//  SystemTest
//
//  Created by apple on 10/06/22.
//

import UIKit
import Kingfisher

class LaunchesTableCell: UITableViewCell {
    
    @IBOutlet weak var launchImageView: UIImageView!
    @IBOutlet weak var lblMissionName: UILabel!
    @IBOutlet weak var lblRocketName: UILabel!
    @IBOutlet weak var lblLaunchSiteName: UILabel!
    @IBOutlet weak var lblLaunchDate: UILabel!
    
    func setLaunchesData(data:LaunchesModel , indexpath:IndexPath) {
        lblMissionName.text = data.mission_name
        lblRocketName.text = data.rocket?.rocket_name
        lblLaunchSiteName.text = data.launch_site?.site_name
        
        if let launchDateUrlString = data.launch_date_utc {
            let dateFormatter = GWDateFormatter.shared.iso8601UserTimeZone
            if let laucnhDate = dateFormatter.date(from: launchDateUrlString) {
                let launchDateStr = GWDateFormatter.shared.MonthDayYear.string(from: laucnhDate)
                lblLaunchDate.text = launchDateStr
            }
        }
        
        if let imageUrlString = data.links?.mission_patch_small , !imageUrlString.isEmpty {
            if let url = URL(string: imageUrlString) {
                launchImageView.kf.setImage(with: url, placeholder: UIImage(named: "LauchPlaceholder"), options: nil, progressBlock: nil, completionHandler: nil)
            }
        } else {
            launchImageView.image = UIImage(named: "LauchPlaceholder")
        }
    }
}
