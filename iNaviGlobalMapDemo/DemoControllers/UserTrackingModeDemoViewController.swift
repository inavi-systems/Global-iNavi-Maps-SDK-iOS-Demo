import UIKit
import iNaviGlobalMapSDK

final class UserTrackingModeDemoViewController: GenericDemoViewController {
    private let selectButton = UIButton(type: .system)
    private let container = UIView()

    private let userTrackingModes = ["None", "NoTracking", "Tracking", "TrackingCompass"]

    init() { super.init(screenTitle: "User Tracking Mode") }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        mapView?.userTrackingMode = .tracking
        mapView?.isLocationButtonVisible = true
        setupSelectButton()
        updateSelectButtonTitle(mode: .tracking)
    }

    private func setupSelectButton() {
        container.translatesAutoresizingMaskIntoConstraints = false
        container.backgroundColor = .white
        container.layer.cornerRadius = 10
        container.layer.masksToBounds = true

        selectButton.translatesAutoresizingMaskIntoConstraints = false
        selectButton.setTitleColor(.black, for: .normal)
        selectButton.backgroundColor = UIColor(white: 0.95, alpha: 1.0)
        selectButton.layer.cornerRadius = 8
        selectButton.contentEdgeInsets = UIEdgeInsets(top: 10, left: 12, bottom: 10, right: 12)
        selectButton.addTarget(self, action: #selector(respondToUserTrackingMode(_:)), for: .touchUpInside)

        container.addSubview(selectButton)
        view.addSubview(container)

        NSLayoutConstraint.activate([
            container.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            container.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),

            selectButton.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 8),
            selectButton.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -8),
            selectButton.topAnchor.constraint(equalTo: container.topAnchor, constant: 8),
            selectButton.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -8)
        ])
    }

    private func updateSelectButtonTitle(mode: IgmUserTrackingMode) {
        let index: Int
        switch mode {
        case .noTracking:
            index = 1
        case .tracking:
            index = 2
        case .trackingCompass:
            index = 3
        default:
            index = 0
        }

        UIView.performWithoutAnimation {
            selectButton.setTitle(userTrackingModes[index], for: .normal)
            selectButton.layoutIfNeeded()
        }
    }

    @objc private func respondToUserTrackingMode(_ sender: UIButton) {
        let alertController = UIAlertController(title: "Select User Tracking Mode", message: nil, preferredStyle: .actionSheet)

        for (index, userTrackingMode) in userTrackingModes.enumerated() {
            alertController.addAction(UIAlertAction(title: userTrackingMode, style: .default) { [weak self] _ in
                guard let self else { return }
                let selectedMode: IgmUserTrackingMode
                switch index {
                case 1:
                    selectedMode = .noTracking
                case 2:
                    selectedMode = .tracking
                case 3:
                    selectedMode = .trackingCompass
                default:
                    selectedMode = .none
                }
                self.mapView?.userTrackingMode = selectedMode
                self.updateSelectButtonTitle(mode: selectedMode)
            })
        }
        alertController.addAction(UIAlertAction(title: "Close", style: .cancel))

        if UIDevice.current.userInterfaceIdiom == .pad {
            if let popoverController = alertController.popoverPresentationController {
                popoverController.sourceView = sender
                popoverController.sourceRect = sender.bounds
                popoverController.permittedArrowDirections = .any
            }
        }
        present(alertController, animated: true)
    }
}
