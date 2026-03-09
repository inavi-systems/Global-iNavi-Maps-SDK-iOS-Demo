import UIKit
import iNaviGlobalMapSDK
import CoreLocation

final class GlobalZIndexDemoViewController: GenericDemoViewController {
    private var polyline: IgmPolyline?
    private var circleDefaultGlobalZIndex: Int = 0

    private let toggleContainer = UIView()
    private let toggleLabel = UILabel()
    private let zIndexSwitch = UISwitch()

    private let polylineCoords: [CLLocationCoordinate2D] = [
        CLLocationCoordinate2D(latitude: 25.040936, longitude: 121.565194),
        CLLocationCoordinate2D(latitude: 25.036436, longitude: 121.561054),
        CLLocationCoordinate2D(latitude: 25.032496, longitude: 121.567094),
        CLLocationCoordinate2D(latitude: 25.031236, longitude: 121.559584),
        CLLocationCoordinate2D(latitude: 25.026706, longitude: 121.562464)
    ]

    init() { super.init(screenTitle: "Global Z-Index") }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        moveCameraToDemoArea()
        setupShapes()
        setupGlobalZIndexSwitch()
    }

    private func moveCameraToDemoArea() {
        let target = CLLocationCoordinate2D(latitude: 25.033976, longitude: 121.561964)
        let params = IgmCameraUpdateParams.cameraUpdateParams()
        params.targetTo(target)
        params.zoomTo(14.0)
        let update = IgmCameraUpdate.cameraUpdate(params: params)
        mapView?.moveCamera(update)
    }

    private func setupShapes() {
        let circle = IgmCircle()
        circle.center = CLLocationCoordinate2D(latitude: 25.033976, longitude: 121.561964)
        circle.radius = 500
        circle.fillColor = UIColor(red: 1.0, green: 0.0, blue: 0.0, alpha: 0.5)
        circle.strokeColor = .red
        circle.strokeWidth = 3
        circle.mapView = mapView
        circleDefaultGlobalZIndex = circle.globalZIndex

        let line = IgmPolyline(coords:polylineCoords)
        line.color = .blue
        line.width = 3
        line.mapView = mapView
        polyline = line
    }

    private func setupGlobalZIndexSwitch() {
        toggleContainer.translatesAutoresizingMaskIntoConstraints = false
        toggleContainer.backgroundColor = .white
        toggleContainer.layer.cornerRadius = 10
        toggleContainer.layer.masksToBounds = true

        toggleLabel.translatesAutoresizingMaskIntoConstraints = false
        toggleLabel.text = "Global Z Index"
        toggleLabel.textColor = .black
        toggleLabel.font = .systemFont(ofSize: 14, weight: .semibold)

        zIndexSwitch.translatesAutoresizingMaskIntoConstraints = false
        zIndexSwitch.isOn = false
        zIndexSwitch.addTarget(self, action: #selector(respondToGlobalZIndex(_:)), for: .valueChanged)

        toggleContainer.addSubview(toggleLabel)
        toggleContainer.addSubview(zIndexSwitch)
        view.addSubview(toggleContainer)

        NSLayoutConstraint.activate([
            toggleContainer.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            toggleContainer.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),

            toggleLabel.leadingAnchor.constraint(equalTo: toggleContainer.leadingAnchor, constant: 10),
            toggleLabel.centerYAnchor.constraint(equalTo: toggleContainer.centerYAnchor),

            zIndexSwitch.leadingAnchor.constraint(equalTo: toggleLabel.trailingAnchor, constant: 8),
            zIndexSwitch.trailingAnchor.constraint(equalTo: toggleContainer.trailingAnchor, constant: -10),
            zIndexSwitch.topAnchor.constraint(equalTo: toggleContainer.topAnchor, constant: 8),
            zIndexSwitch.bottomAnchor.constraint(equalTo: toggleContainer.bottomAnchor, constant: -8)
        ])
    }

    @objc private func respondToGlobalZIndex(_ sender: UISwitch) {
        polyline?.globalZIndex = circleDefaultGlobalZIndex + (sender.isOn ? -1 : 1)
    }
}
