//
//  LaunchDetailViewController.swift
//  SystemTest
//
//  Created by apple on 03/09/22.
//

import UIKit

class LaunchDetailViewController: UIViewController {

    @IBOutlet weak var launchImage: UIImageView!
    @IBOutlet weak var lblMissionName: UILabel!
    @IBOutlet weak var lblRocketName: UILabel!
    @IBOutlet weak var lblRockeType: UILabel!
    @IBOutlet weak var lblLaunchSiteName: UILabel!
    @IBOutlet weak var lblLaunchDate: UILabel!
    @IBOutlet weak var lblDetails: UILabel!
    @IBOutlet weak var lblLauchSucess: UILabel!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var lblMessage: UILabel!

    var launch: LaunchesModel? {
      didSet {
        refreshUI()
      }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        backgroundView.isHidden = true
        lblMessage.isHidden = false
    }
}

extension LaunchDetailViewController {
    private func refreshUI() {
      loadViewIfNeeded()
        if let launch = launch {
            backgroundView.isHidden = false
            lblMessage.isHidden = true
            lblMissionName.text = "Mission Name : \(launch.mission_name ?? "-")"
            lblRocketName.text =  "Rocket Name : \(launch.rocket?.rocket_name ?? "-")"
            lblRockeType.text = "Rocket Type : \(launch.rocket?.rocket_type ?? "-")"
            lblLaunchSiteName.text = "Site Name : \(launch.launch_site?.site_name ?? "-")"
            lblDetails.text = "Details: \(launch.details ?? "-")"
            lblLauchSucess.text = "Lauch Success : \(launch.launch_success ?? false)"

            if let launchDateUrlString = launch.launch_date_utc {
                let dateFormatter = GWDateFormatter.shared.iso8601UserTimeZone
                if let laucnhDate = dateFormatter.date(from: launchDateUrlString) {
                    let launchDateStr = GWDateFormatter.shared.MonthDayYear.string(from: laucnhDate)
                    lblLaunchDate.text = "Launch Date : \(launchDateStr)"
                }
            }
            if let imageUrlString = launch.links?.mission_patch_small , !imageUrlString.isEmpty {
                if let url = URL(string: imageUrlString) {
                    launchImage.kf.setImage(with: url, placeholder: UIImage(named: "SpectPlaceholder"), options: nil, progressBlock: nil, completionHandler: nil)
                }
            } else {
                launchImage.image = UIImage(named: "LauchPlaceholder")
            }
        }
    }
}

extension LaunchDetailViewController: LaunchSelectionDelegate {
    func launchSelected(_ launchObj: LaunchesModel?) {
        self.launch = launchObj
    }
}
