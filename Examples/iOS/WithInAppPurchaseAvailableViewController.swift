//
// Copyright © 2022 mycujoo. All rights reserved.
//

import Foundation
import UIKit
import StoreKit
import MLSSDK
import MLSSDK_IAP


class WithInAppPurchaseAvailableViewController: UIViewController {
    
    private let tableView = UITableView()
    private var eventId: String? {
        didSet {
            if #available(iOS 15.0, *) {
                getSubscriptionList()
            } else {
                // Fallback on earlier versions
            }
        }
    }
    
    private var productList: [(packageId: String, product: IAPProduct)] = [] {
        didSet {
            DispatchQueue.main.async { [weak self] in
                self?.tableView.reloadData()
            }
        }
    }
    
    private lazy var mls = MLS(publicKey: "", configuration: Configuration(logLevel: .verbose))

    private lazy var paymentAPI: IAPIntegration = {
        return mls.prepare(IAPIntegrationFactory()).build()
    }()
    
    override func loadView() {
        super.loadView()
        setupTableView()
        
        mls.dataProvider().eventList(completionHandler: { [weak self] (events, _, _) in
            self?.eventId = events?.first?.id
        })
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func setupTableView() {
        
        self.title = "In-App Purchase"
        
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        tableView.register(SubtitleTableViewCell.self, forCellReuseIdentifier: "cell")
        
    }
    
}

@available(iOS 15.0, *)
extension WithInAppPurchaseAvailableViewController {
    
    func getSubscriptionList() {
        guard let eventId = eventId else { return }
        Task.init {
            self.productList = try await paymentAPI.listProducts(eventId: eventId)
        }
    }
    
}

class SubtitleTableViewCell: UITableViewCell {

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension WithInAppPurchaseAvailableViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if productList.isEmpty {
            tableView.startSpinner()
        } else {
            tableView.restoreTable()
        }
        return productList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = productList[indexPath.row].product.displayName
        cell.detailTextLabel?.text = productList[indexPath.row].product.displayPrice
            return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let entry = productList[indexPath.row]
        if #available(iOS 15.0, *) {
            Task.init {
                paymentAPI.purchaseProduct(packageId: entry.packageId) { paymentResult in
                    
                    switch paymentResult {
                    case .success:
                        print("Payment successful!")
                    case .finalising:
                        print("Please wait while your payment is being processed.")
                    case .failure(let storeError):
                        print("Payment failed: \(storeError)")
                    case .pending:
                        print("Payment pending for user action")
                    }
                }
                
                DispatchQueue.main.async {
                    tableView.reloadData()
                }
            }
            
        } else {
            // Fallback on earlier versions
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension UITableView {
    func startSpinner() {
        let activity = UIActivityIndicatorView()
        self.backgroundView = activity
        self.separatorStyle = .none
        activity.startAnimating()
    }
    
    func restoreTable() {
        DispatchQueue.main.async {
            self.backgroundView = nil
            self.separatorStyle = .singleLine
        }
    }
}

extension WithInAppPurchaseAvailableViewController: VideoPlayerDelegate {
    
    func playerConcurrencyLimitExceeded(eventId: String, limit: Int, player: VideoPlayer) {
        // TODO: Add your custom error message here
    }
    func playerDidUpdatePlaying(player: VideoPlayer) {
        
    }
    
    func playerDidUpdateTime(player: VideoPlayer) {
        
    }

    
    func playerDidUpdateState(player: VideoPlayer) {
        
    }
    
    func playerDidUpdateControlVisibility(toVisible: Bool, withAnimationDuration: Double, player: VideoPlayer) {
        
    }
    
    func playerDidUpdateStream(stream: MLSSDK.Stream?, player: VideoPlayer) {
        
    }
    
    func playerRequestsVideoAnalyticsCustomData() -> VideoAnalyticsCustomData? {
        return nil
    }
    
    func playerDidUpdateFullscreen(player: VideoPlayer) {
        
    }
    
}
