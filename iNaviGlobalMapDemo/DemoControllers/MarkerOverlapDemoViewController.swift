import UIKit
import iNaviGlobalMapSDK
import CoreLocation

final class MarkerOverlapDemoViewController: GenericDemoViewController {

    var markers: [IgmMarker] = []
    let markerImages: [IgmImage] = [IgmImage.markerImageRed, IgmImage.markerImageGreen, IgmImage.markerImageBlue, IgmImage.markerImageYellow, IgmImage.markerImageGray]
    private let overlapContainer = UIView()
    private let overlapLabel = UILabel()
    private let overlapSwitch = UISwitch()

    init() { super.init(screenTitle: "Marker Overlap") }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupOverlapSwitch()

        guard let bounds = mapView?.contentBounds else { return }

        for index in 1...50 {
            let marker = IgmMarker.marker(withPosition:
                CLLocationCoordinate2D(
                    latitude: (bounds.northEast.latitude - bounds.southWest.latitude) * drand48() + bounds.southWest.latitude,
                    longitude: (bounds.northEast.longitude - bounds.southWest.longitude) * drand48() + bounds.southWest.longitude
                )
            )
            let idx = Int(arc4random_uniform(UInt32(markerImages.count)))
            marker.iconImage = markerImages[idx]
            marker.title = "Marker #\(index)"
            marker.isAllowOverlapMarkers = overlapSwitch.isOn
            marker.mapView = mapView
            markers.append(marker)
        }
    }

    private func setupOverlapSwitch() {
        overlapContainer.translatesAutoresizingMaskIntoConstraints = false
        overlapContainer.backgroundColor = .white
        overlapContainer.layer.cornerRadius = 10
        overlapContainer.layer.masksToBounds = true

        overlapLabel.translatesAutoresizingMaskIntoConstraints = false
        overlapLabel.text = "overlap"
        overlapLabel.textColor = .black
        overlapLabel.font = .systemFont(ofSize: 14, weight: .semibold)

        overlapSwitch.translatesAutoresizingMaskIntoConstraints = false
        overlapSwitch.isOn = true
        overlapSwitch.addTarget(self, action: #selector(didChangeOverlapSwitch(_:)), for: .valueChanged)

        overlapContainer.addSubview(overlapLabel)
        overlapContainer.addSubview(overlapSwitch)
        view.addSubview(overlapContainer)

        NSLayoutConstraint.activate([
            overlapContainer.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            overlapContainer.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),

            overlapLabel.leadingAnchor.constraint(equalTo: overlapContainer.leadingAnchor, constant: 10),
            overlapLabel.centerYAnchor.constraint(equalTo: overlapContainer.centerYAnchor),

            overlapSwitch.leadingAnchor.constraint(equalTo: overlapLabel.trailingAnchor, constant: 8),
            overlapSwitch.trailingAnchor.constraint(equalTo: overlapContainer.trailingAnchor, constant: -10),
            overlapSwitch.topAnchor.constraint(equalTo: overlapContainer.topAnchor, constant: 8),
            overlapSwitch.bottomAnchor.constraint(equalTo: overlapContainer.bottomAnchor, constant: -8)
        ])
    }

    @objc private func didChangeOverlapSwitch(_ sender: UISwitch) {
        for marker in markers {
            marker.isAllowOverlapMarkers = sender.isOn
        }
    }
}
