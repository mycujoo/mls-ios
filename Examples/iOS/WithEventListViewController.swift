//
// Copyright © 2020 mycujoo. All rights reserved.
//

import UIKit
import GoogleCast
import MLSSDK
import MLSSDK_Cast
import MLSSDK_IMA

class WithEventListViewController: UIViewController {
    @IBOutlet var playerContainerView: UIView!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var castMiniControllerView: UIView!

    // Make sure to set your organization's public key here!
    private lazy var mls = MLS(
        publicKey: "",
        configuration: Configuration(
            logLevel: .minimal,
            seekTolerance: .zero,
            playerConfig: PlayerConfig(
                primaryColor: "#de6e1f",
                secondaryColor: "#000000",
                imaAdUnit: "/124319096/external/single_ad_samples")),
        useConcurrencyControl: false)

    lazy var castButtonParentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            view.widthAnchor.constraint(equalToConstant: 40),
            view.heightAnchor.constraint(equalToConstant: 40),
        ])
        return view
    }()
    
    lazy var videoPlayer: VideoPlayer = {
        let player = mls.videoPlayer()
        #if DEBUG
        player.isMuted = true
        #endif
        player.castIntegration = mls.prepare(CastIntegrationFactory()).build(delegate: self)
        player.imaIntegration = mls.prepare(IMAIntegrationFactory()).build(videoPlayer: player, delegate: self)
        player.topTrailingControlsStackView?.insertArrangedSubview(castButtonParentView, at: 0)
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
        return .all
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

        if !didLayoutPlayerView, let playerView = videoPlayer.playerView {
            didLayoutPlayerView = true

            playerContainerView.addSubview(playerView)
            playerView.isHidden = true
            playerView.translatesAutoresizingMaskIntoConstraints = false

            let playerConstraints = [
                playerView.topAnchor.constraint(equalTo: playerContainerView.topAnchor),
                playerView.leftAnchor.constraint(equalTo: playerContainerView.leftAnchor),
                playerView.rightAnchor.constraint(equalTo: playerContainerView.rightAnchor),
                playerView.bottomAnchor.constraint(equalTo: playerContainerView.bottomAnchor)
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

        videoPlayer.playerView?.isHidden = false
        videoPlayer.event = events[indexPath.row]
    }
}

extension WithEventListViewController: CastIntegrationDelegate {
    func getCastButtonParentViews() -> [(parentView: UIView, tintColor: UIColor)] {
        return [(parentView: castButtonParentView, tintColor: .white)]
    }

    func getMiniControllerParentView() -> UIView? {
        return castMiniControllerView
    }

    func getMiniControllerParentViewController() -> UIViewController? {
        return self
    }
}

extension WithEventListViewController: IMAIntegrationDelegate {
    func presentingView(for videoPlayer: VideoPlayer) -> UIView {
        return videoPlayer.playerView!
    }
    
    func presentingViewController(for videoPlayer: VideoPlayer) -> UIViewController? {
        return self
    }
    func getCustomParameters(forItemIn videoPlayer: VideoPlayer) -> [String : String] {
        return [:]
    }
    func imaAdStarted(for videoPlayer: VideoPlayer) {}

    func imaAdStopped(for videoPlayer: VideoPlayer) {}
}
