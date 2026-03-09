import UIKit
import iNaviGlobalMapSDK
import CoreLocation

class CustomInfoWindowView: UIView {
    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var textLabel: UILabel!
}

final class InfoWindowCustomDataSource: NSObject, IgmImageViewDataSource {
    private var rootView: CustomInfoWindowView!

    func view(with shape: IgmShape) -> UIView {
        guard let infoWindow = shape as? IgmInfoWindow else { return rootView }
        if rootView == nil {
            rootView = Bundle.main.loadNibNamed("CustomInfoWindowView", owner: nil, options: nil)?.first as? CustomInfoWindowView
        }

        if let marker = infoWindow.marker {
            rootView.iconView.image = UIImage(named: "baseline_room_black_24pt")
            rootView.textLabel.text = marker.userInfo["title"] as? String
        } else {
            rootView.iconView.image = UIImage(named: "baseline_gps_fixed_black_24pt")
            rootView.textLabel.text = String(format: "(%.5f, %.5f)", infoWindow.position?.latitude ?? 0.0, infoWindow.position?.longitude ?? 0.0)
        }
        rootView.textLabel.sizeToFit()

        let textWidth = rootView.textLabel.frame.size.width
        let iconWidth = rootView.iconView.frame.size.width
        let viewWidth = iconWidth + textWidth + 32

        var rect = rootView.frame
        rect.size.width = viewWidth
        rect.size.height = 57
        rootView.frame = rect
        rootView.layoutIfNeeded()

        return rootView
    }
}

final class InfoWindowTextDataSource: NSObject, IgmImageTextDataSource {
    func title(with shape: IgmShape) -> String? {
        shape.userInfo["title"] as? String ?? ""
    }
}

final class InfoWindowDemoViewController: GenericDemoViewController {
    private let initPosition = CLLocationCoordinate2D(latitude: 25.033976, longitude: 121.561964)
    private let infoWindow = IgmInfoWindow()
    private let customInfoWindowDataSource = InfoWindowCustomDataSource()
    private let textInfoWindowDataSource = InfoWindowTextDataSource()
    private let customSwitchContainer = UIView()
    private let customSwitchLabel = UILabel()
    private let customSwitch = UISwitch()

    init() { super.init(screenTitle: "infoWindow") }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureInfoWindowDemo()
        setupCustomSwitch()
    }

    private func configureInfoWindowDemo() {
        let title = String(format: "Coordinates : (%.5f, %.5f)", initPosition.latitude, initPosition.longitude)
        infoWindow.position = initPosition
        infoWindow.userInfo["title"] = title
        infoWindow.touchEvent = { [weak self] (_: IgmShape) -> Bool in
            self?.infoWindow.mapView = nil
            return true
        }
        infoWindow.imageDataSource = textInfoWindowDataSource
        infoWindow.mapView = mapView

        let markerTouchEvent: IgmShapeTouchEvent = { [weak self] (shape: IgmShape) -> Bool in
            guard let marker = shape as? IgmMarker, let self else { return true }

            self.infoWindow.userInfo["title"] = "Marker : \(marker.userInfo["title"] as? String ?? "")"
            self.infoWindow.marker = marker
            if self.infoWindow.mapView == nil {
                self.infoWindow.mapView = self.mapView
            } else {
                self.infoWindow.invalidate()
            }
            return true
        }

        let marker1 = IgmMarker()
        marker1.position = CLLocationCoordinate2D(latitude: 25.036436, longitude: 121.561054)
        marker1.iconImage = IgmImage.markerImageRed
        marker1.touchEvent = markerTouchEvent
        marker1.userInfo = ["title": "RED"]
        marker1.mapView = mapView

        let marker2 = IgmMarker()
        marker2.position = CLLocationCoordinate2D(latitude: 25.032366, longitude: 121.563504)
        marker2.iconImage = IgmImage.markerImageBlue
        marker2.touchEvent = markerTouchEvent
        marker2.userInfo = ["title": "BLUE"]
        marker2.mapView = mapView
    }

    private func setupCustomSwitch() {
        customSwitchContainer.translatesAutoresizingMaskIntoConstraints = false
        customSwitchContainer.backgroundColor = .white
        customSwitchContainer.layer.cornerRadius = 10
        customSwitchContainer.layer.masksToBounds = true

        customSwitchLabel.translatesAutoresizingMaskIntoConstraints = false
        customSwitchLabel.text = "Custom View"
        customSwitchLabel.textColor = .black
        customSwitchLabel.font = .systemFont(ofSize: 14, weight: .semibold)

        customSwitch.translatesAutoresizingMaskIntoConstraints = false
        customSwitch.isOn = false
        customSwitch.addTarget(self, action: #selector(didChangeCustomSwitch(_:)), for: .valueChanged)

        customSwitchContainer.addSubview(customSwitchLabel)
        customSwitchContainer.addSubview(customSwitch)
        view.addSubview(customSwitchContainer)

        NSLayoutConstraint.activate([
            customSwitchContainer.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            customSwitchContainer.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),

            customSwitchLabel.leadingAnchor.constraint(equalTo: customSwitchContainer.leadingAnchor, constant: 10),
            customSwitchLabel.centerYAnchor.constraint(equalTo: customSwitchContainer.centerYAnchor),

            customSwitch.leadingAnchor.constraint(equalTo: customSwitchLabel.trailingAnchor, constant: 8),
            customSwitch.trailingAnchor.constraint(equalTo: customSwitchContainer.trailingAnchor, constant: -10),
            customSwitch.topAnchor.constraint(equalTo: customSwitchContainer.topAnchor, constant: 8),
            customSwitch.bottomAnchor.constraint(equalTo: customSwitchContainer.bottomAnchor, constant: -8)
        ])
    }

    @objc private func didChangeCustomSwitch(_ sender: UISwitch) {
        infoWindow.imageDataSource = sender.isOn ? customInfoWindowDataSource : textInfoWindowDataSource
        if infoWindow.mapView != nil {
            infoWindow.invalidate()
        }
    }
}

extension InfoWindowDemoViewController {
    func didTapMapView(_ point: CGPoint, latLng: CLLocationCoordinate2D) {
        let title = String(format: "Coordinates : (%.5f, %.5f)", latLng.latitude, latLng.longitude)
        infoWindow.position = latLng
        infoWindow.userInfo["title"] = title
        if infoWindow.mapView == nil {
            infoWindow.mapView = mapView
        } else {
            infoWindow.invalidate()
        }
    }
}
