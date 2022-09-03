//
//  LaunchesListViewController.swift
//  SystemTest
//
//  Created by apple on 09/03/2022.
//

import UIKit

protocol LaunchSelectionDelegate: AnyObject {
  func launchSelected(_ launchObj: LaunchesModel?)
}

class LaunchesListViewController: UITableViewController {

    var launchessDataArray : [LaunchesModel]?
    lazy var viewModel = LaunchesViewModel()
    weak var delegate: LaunchSelectionDelegate?
    weak var activityIndicatorView: UIActivityIndicatorView!

    // MARK: LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let activityIndicatorView = UIActivityIndicatorView(style: .large)
        self.tableView.backgroundView = activityIndicatorView
        self.activityIndicatorView = activityIndicatorView

        setupUI()
        getLaunches()
    }
        
    private func setupUI() {
        self.title = "Launches"
        self.tableView.estimatedRowHeight = 150
        self.tableView.rowHeight = UITableView.automaticDimension
    }
}

// MARK: ServiceCall Method
extension LaunchesListViewController {
    
    func getLaunches() {
        activityIndicatorView.startAnimating()

        viewModel.callgetLaunchesAPI(params: "", delegate: self) {[weak self] responseArray, error in
            self?.launchessDataArray = responseArray

            self?.launchessDataArray =  self?.launchessDataArray?.sorted {
                let valueOne = $0.launch_date_utc ?? ""
                let valueTwo = $1.launch_date_utc ?? ""
                return valueOne > valueTwo
            }
            DispatchQueue.main.async {
                self?.tableView.backgroundView = nil
                self?.tableView.reloadData()
            }
        }
    }
}

// MARK: UITableView Delegate, DataSource Methods
extension LaunchesListViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        launchessDataArray?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: LaunchesTableCell.className, for: indexPath) as? LaunchesTableCell else { return UITableViewCell() }
        if let object = launchessDataArray?[indexPath.row] {
          cell.setLaunchesData(data: object, indexpath: indexPath)
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedLaunch = launchessDataArray?[indexPath.row]
        delegate?.launchSelected(selectedLaunch)
        if let detailViewController = delegate as? LaunchDetailViewController {
          splitViewController?.showDetailViewController(detailViewController, sender: nil)
        }
    }
}
