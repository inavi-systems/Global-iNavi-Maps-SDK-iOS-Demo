import UIKit
import iNaviGlobalMapSDK
import CoreLocation

final class CameraFitBoundsDemoViewController: GenericDemoViewController {
    private let fitBoundsButton = UIButton(type: .system)

    private let position1 = CLLocationCoordinate2D(latitude: 25.033976, longitude: 121.561964)
    private let position2 = CLLocationCoordinate2D(latitude: 24.626516, longitude: 122.269514)

    private var isInitPosition = true

    init() { super.init(screenTitle: "Camera Move to Fit Bounds") }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupMarkers()
        setupFitBoundsButton()
    }

    private func setupMarkers() {
        let marker1 = IgmMarker()
        marker1.position = position1
        marker1.mapView = mapView

        let marker2 = IgmMarker()
        marker2.position = position2
        marker2.iconImage = IgmImage.markerImageBlue
        marker2.mapView = mapView
    }

    private func setupFitBoundsButton() {
        fitBoundsButton.translatesAutoresizingMaskIntoConstraints = false
        fitBoundsButton.backgroundColor = .systemBlue
        fitBoundsButton.tintColor = .white
        fitBoundsButton.layer.cornerRadius = 24
        fitBoundsButton.setImage(UIImage(systemName: "camera.fill"), for: .normal)
        fitBoundsButton.addTarget(self, action: #selector(respondToFitBounds(_:)), for: .touchUpInside)

        view.addSubview(fitBoundsButton)
        NSLayoutConstraint.activate([
            fitBoundsButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            fitBoundsButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            fitBoundsButton.widthAnchor.constraint(equalToConstant: 48),
            fitBoundsButton.heightAnchor.constraint(equalToConstant: 48)
        ])
    }

    @objc private func respondToFitBounds(_ sender: UIButton) {
        let cameraUpdate: IgmCameraUpdate
        if isInitPosition {
            let southWest = CLLocationCoordinate2D(
                latitude: min(position1.latitude, position2.latitude),
                longitude: min(position1.longitude, position2.longitude)
            )
            let northEast = CLLocationCoordinate2D(
                latitude: max(position1.latitude, position2.latitude),
                longitude: max(position1.longitude, position2.longitude)
            )
            let bounds = IgmLatLngBounds(southWest: southWest, northEast: northEast)
            cameraUpdate = IgmCameraUpdate.cameraUpdate(fitBounds: bounds, padding: 24)
        } else {
            let position = IgmCameraPosition.cameraPosition(position1, zoom: 15.0)
            cameraUpdate = IgmCameraUpdate.cameraUpdate(position: position)
        }

        cameraUpdate.animation = .fly
        cameraUpdate.animationDuration = 3
        mapView?.moveCamera(cameraUpdate)

        let imageName = isInitPosition ? "arrow.clockwise" : "camera.fill"
        fitBoundsButton.setImage(UIImage(systemName: imageName), for: .normal)
        isInitPosition.toggle()
    }
}

extension CameraFitBoundsDemoViewController {
    func mapView(_ mapView: IgmMapView, regionIsChangingWithReason reason: IgmCameraUpdateReason) {
        if isInitPosition && reason == .gesture {
            isInitPosition = false
            fitBoundsButton.setImage(UIImage(systemName: "arrow.clockwise"), for: .normal)
        }
    }
}
