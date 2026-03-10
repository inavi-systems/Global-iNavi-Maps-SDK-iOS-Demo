import UIKit
import iNaviGlobalMapSDK
import CoreLocation

final class CameraEventsDemoViewController: GenericDemoViewController {
    private let cameraPositionLabel = UILabel()
    private let cameraMoveButton = UIButton(type: .system)
    private let buttonContainer = UIView()

    private let position1 = CLLocationCoordinate2D(latitude: 25.033976, longitude: 121.561964)
    private let position2 = CLLocationCoordinate2D(latitude: 24.157552, longitude: 120.66603)
    private let labelTextFormat = "Status : %@\nPosition : (%.5f, %.5f)\nZoom Level : %.2f\nTilt : %.2f\nBearing : %.2f"

    private var isInitPosition = true

    init() { super.init(screenTitle: "Camera Events") }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupMarkers()
        setupOverlayUI()
        showCameraPositionInfo(false)
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

    private func setupOverlayUI() {
        cameraPositionLabel.translatesAutoresizingMaskIntoConstraints = false
        cameraPositionLabel.numberOfLines = 0
        cameraPositionLabel.font = .systemFont(ofSize: 13, weight: .medium)
        cameraPositionLabel.textColor = .black
        cameraPositionLabel.backgroundColor = UIColor.white.withAlphaComponent(0.9)
        cameraPositionLabel.layer.cornerRadius = 10
        cameraPositionLabel.layer.masksToBounds = true
        cameraPositionLabel.textAlignment = .left

        buttonContainer.translatesAutoresizingMaskIntoConstraints = false
        buttonContainer.backgroundColor = .white
        buttonContainer.layer.cornerRadius = 24
        buttonContainer.layer.masksToBounds = true

        cameraMoveButton.translatesAutoresizingMaskIntoConstraints = false
        cameraMoveButton.tintColor = .white
        cameraMoveButton.backgroundColor = .systemBlue
        cameraMoveButton.layer.cornerRadius = 20
        cameraMoveButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
        cameraMoveButton.addTarget(self, action: #selector(respondToCameraMove(_:)), for: .touchUpInside)

        view.addSubview(cameraPositionLabel)
        buttonContainer.addSubview(cameraMoveButton)
        view.addSubview(buttonContainer)

        NSLayoutConstraint.activate([
            cameraPositionLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            cameraPositionLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            cameraPositionLabel.widthAnchor.constraint(equalToConstant: 220),

            buttonContainer.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            buttonContainer.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            buttonContainer.widthAnchor.constraint(equalToConstant: 48),
            buttonContainer.heightAnchor.constraint(equalToConstant: 48),

            cameraMoveButton.centerXAnchor.constraint(equalTo: buttonContainer.centerXAnchor),
            cameraMoveButton.centerYAnchor.constraint(equalTo: buttonContainer.centerYAnchor),
            cameraMoveButton.widthAnchor.constraint(equalToConstant: 40),
            cameraMoveButton.heightAnchor.constraint(equalToConstant: 40)
        ])

        cameraPositionLabel.text = ""
    }

    private func showCameraPositionInfo(_ isMoving: Bool) {
        guard let cameraPosition = mapView?.cameraPosition else { return }
        let statusText = isMoving ? "Moving" : "Idle"
        let raw = String(
            format: labelTextFormat,
            statusText,
            cameraPosition.target.latitude,
            cameraPosition.target.longitude,
            cameraPosition.zoom,
            cameraPosition.tilt,
            cameraPosition.bearing
        )
        cameraPositionLabel.text = "  " + raw.replacingOccurrences(of: "\n", with: "\n  ")
    }

    private func presentShortAlert(title: String) {
        let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        present(alert, animated: true) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                alert.dismiss(animated: true)
            }
        }
    }

    @objc private func respondToCameraMove(_ sender: UIButton) {
        guard let mapView else { return }

        let target = isInitPosition ? position2 : position1
        let position = IgmCameraPosition.cameraPosition(target, zoom: 14.0)
        let cameraUpdate = IgmCameraUpdate.cameraUpdate(position: position)
        cameraUpdate.animation = .fly
        cameraUpdate.animationDuration = 3
        mapView.moveCamera(cameraUpdate) { [weak self] in
            guard let self else { return }
            self.cameraMoveButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
            self.presentShortAlert(title: "Camera Move Completed")
        }

        cameraMoveButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
        isInitPosition.toggle()
    }
}

extension CameraEventsDemoViewController {
    func mapView(_ mapView: IgmMapView, regionIsChangingWithReason reason: IgmCameraUpdateReason) {
        showCameraPositionInfo(true)
    }

    func mapView(_ mapView: IgmMapView, regionDidChangeAnimated animated: Bool, reason: IgmCameraUpdateReason) {
        showCameraPositionInfo(false)
    }
}
