//
// Copyright © 2020 mycujoo. All rights reserved.
//

import UIKit
import MLSSDK

class WithEventListViewController: UIViewController {
    @IBOutlet var playerContainerView: UIView!
    @IBOutlet var tableView: UITableView!

    // Make sure to set your organization's public key here!
    private lazy var mls = MLS(
        publicKey: "",
        configuration: Configuration(
            logLevel: .verbose,
            seekTolerance: .zero,
            playerConfig: PlayerConfig(
                primaryColor: "#de6e1f",
                secondaryColor: "#000000")))

    lazy var videoPlayer: VideoPlayer = {
        let player = mls.videoPlayer()
        #if DEBUG
        player.isMuted = true
        #endif
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

    override var shouldAutorotate: Bool {
        return false
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .black
        tableView.tableFooterView = UIView()

        mls.dataProvider().eventList(orderBy: .startTimeDesc, completionHandler: { [weak self] (events, nextPageToken, previousPageToken) in
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
            videoPlayer.playerView.isHidden = true
            videoPlayer.playerView.translatesAutoresizingMaskIntoConstraints = false

            let playerConstraints = [
                videoPlayer.playerView.topAnchor.constraint(equalTo: playerContainerView.topAnchor),
                videoPlayer.playerView.leftAnchor.constraint(equalTo: playerContainerView.leftAnchor),
                videoPlayer.playerView.rightAnchor.constraint(equalTo: playerContainerView.rightAnchor),
                videoPlayer.playerView.bottomAnchor.constraint(equalTo: playerContainerView.bottomAnchor)
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

        let selectedBackgroundView = UIView()
        selectedBackgroundView.backgroundColor = UIColor.init(red: 0, green: 91.0 / 255, blue: 171.0 / 255, alpha: 255)
        cell.selectedBackgroundView = selectedBackgroundView

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard indexPath.row < events.count else { return }

        videoPlayer.playerView.isHidden = false
        videoPlayer.event = events[indexPath.row]
    }
}
