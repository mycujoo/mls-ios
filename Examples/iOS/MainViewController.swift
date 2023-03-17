//
// Copyright © 2022 mycujoo. All rights reserved.
//

import Foundation
import UIKit

class MainViewController: UIViewController {
    
    private let tableView = UITableView()
    
    private lazy var viewControllers: [UIViewController] = [SimpleViewController(), WithAnnotationSupportViewController(), WithIMASupportViewController(), WithCastSupportViewController(), WithPictureInPictureViewController(), WithFullscreenZoomViewController(), UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "WithEventList"), WithConcurrencyLimitViewController(), WithAVPlayerViewController(), WithCustomAnalyticsAccountViewController(), WithInAppPurchaseAvailableViewController()]
    
    private let viewNames: [String] = ["Simple", "With Annotation", "With IMA Support", "With Cast Support", "With PiP", "With Fullscreen zoom", "With event list", "With Concurrency", "With AV Player", "With Custom Analytics", "With InApp Purchase"]
    override func viewDidLoad() {
        super.viewDidLoad()
    }
 
    
    override func loadView() {
        super.loadView()
        setupTableView()
    }
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
          
        
    }
    
}
extension MainViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewControllers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = viewNames[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.navigationController?.pushViewController(viewControllers[indexPath.row], animated: true)
        tableView.deselectRow(at: indexPath, animated: true)

    }
    
}
