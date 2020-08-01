//
// Copyright © 2020 mycujoo. All rights reserved.
//

import UIKit
import MLSSDK

class WithEventListViewController: UIViewController {
    @IBOutlet var playerContainerView: UIView!
    @IBOutlet var tableView: UITableView!

    // Make sure to set your organization's public key here!
    private lazy var mls = MLS(publicKey: "F20E0UNTM29R0K5A30JAAE2L87URF2VO", configuration: Configuration())

    lazy var videoPlayer: VideoPlayer = {
        let player = mls.videoPlayer()
        return player
    }()

    private var events: [MLSSDK.Event] = [] {
        didSet {
            tableView.reloadData()
        }
    }

    lazy var df: DateFormatter = {
        let df = DateFormatter()
        df.dateStyle = .short
        df.timeStyle = .short
        return df
    }()

    override var prefersHomeIndicatorAutoHidden: Bool {
        return true
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .black
        tableView.tableFooterView = UIView()

        mls.dataProvider().eventList(orderBy: .startTimeDesc, completionHandler: { [weak self] (events) in
            guard let events = events else { return }
            self?.events = events
        })
    }

    private var didLayoutPlayerView = false
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if !didLayoutPlayerView {
            didLayoutPlayerView = true

            playerContainerView.addSubview(videoPlayer.playerView)
            videoPlayer.playerView.backgroundColor = .clear
            videoPlayer.playerView.translatesAutoresizingMaskIntoConstraints = false
            videoPlayer.fullscreenButtonIsHidden = true

            let playerConstraints = [
                videoPlayer.playerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                // Note that this heightAnchor approach will not look good on some devices in landscape.
                // For a more complete solution, see `WithFullscreenZoomViewController.swift`
                videoPlayer.playerView.heightAnchor.constraint(equalTo: videoPlayer.playerView.widthAnchor, multiplier: 9 / 16),
                videoPlayer.playerView.leftAnchor.constraint(equalTo: view.leftAnchor),
                videoPlayer.playerView.rightAnchor.constraint(equalTo: view.rightAnchor),
                videoPlayer.playerView.bottomAnchor.constraint(lessThanOrEqualTo: view.bottomAnchor)
            ]

            NSLayoutConstraint.activate(playerConstraints)
        }
    }
}

extension WithEventListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard indexPath.row < events.count else { return UITableViewCell() }

        let event = events[indexPath.row]

        let cell = tableView.dequeueReusableCell(withIdentifier: "EventCell", for: indexPath)

        cell.textLabel?.text = event.title
        if let descriptionText = event.descriptionText, descriptionText.count > 0 {
            cell.detailTextLabel?.text = descriptionText
        } else if let startTime = event.startTime {
            cell.detailTextLabel?.text = df.string(from: startTime)
        } else {
            cell.detailTextLabel?.text = " "
        }

        let accessoryView = UIImageView(frame: CGRect(x: 0, y: 0, width: 18, height: 18))
        accessoryView.image = UIImage(named: "Play")
        accessoryView.tintColor = .white
        cell.accessoryView = accessoryView
        cell.selectionStyle = .none

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard indexPath.row < events.count else { return }

        videoPlayer.event = events[indexPath.row]
    }
}
