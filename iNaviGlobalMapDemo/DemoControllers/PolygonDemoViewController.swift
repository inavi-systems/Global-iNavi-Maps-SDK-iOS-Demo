import UIKit
import iNaviGlobalMapSDK
import CoreLocation

final class PolygonDemoViewController: GenericDemoViewController {
    private var polygon1: IgmPolygon?
    private var polygon2: IgmPolygon?

    private let toggleContainer = UIView()
    private let toggleLabel = UILabel()
    private let deleteSwitch = UISwitch()

    private let polygon1Coords: [CLLocationCoordinate2D] = [
        CLLocationCoordinate2D(latitude: 25.041926, longitude: 121.561304),
        CLLocationCoordinate2D(latitude: 25.040936, longitude: 121.565194),
        CLLocationCoordinate2D(latitude: 25.037166, longitude: 121.565594),
        CLLocationCoordinate2D(latitude: 25.036436, longitude: 121.561054),
        CLLocationCoordinate2D(latitude: 25.039336, longitude: 121.557294)
    ]

    private let polygon2Coords: [CLLocationCoordinate2D] = [
        CLLocationCoordinate2D(latitude: 25.031236, longitude: 121.559584),
        CLLocationCoordinate2D(latitude: 25.032496, longitude: 121.567094),
        CLLocationCoordinate2D(latitude: 25.025736, longitude: 121.566944),
        CLLocationCoordinate2D(latitude: 25.027326, longitude: 121.559464)
    ]

    init() { super.init(screenTitle: "Plygon") }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        moveCameraToDemoArea()
        setupPolygons()
        setupDeleteSwitch()
    }

    private func moveCameraToDemoArea() {
        let target = CLLocationCoordinate2D(latitude: 25.033976, longitude: 121.561964)
        let params = IgmCameraUpdateParams.cameraUpdateParams()
        params.targetTo(target)
        params.zoomTo(14.0)
        let update = IgmCameraUpdate.cameraUpdate(params: params)
        mapView?.moveCamera(update)
    }

    private func setupPolygons() {
        let poly1 = IgmPolygon(coords: polygon1Coords)
        poly1.fillColor = UIColor(red: 0.0, green: 0.0, blue: 1.0, alpha: 0.5)
        poly1.strokeColor = .blue
        poly1.strokeWidth = 3
        poly1.mapView = mapView
        polygon1 = poly1

        let poly2 = IgmPolygon(coords: polygon2Coords, fillColor: UIColor(red: 1.0, green: 1.0, blue: 0.0, alpha: 0.5))
        poly2.strokeColor = .black
        poly2.strokeWidth = 3
        poly2.mapView = mapView
        polygon2 = poly2
    }

    private func setupDeleteSwitch() {
        toggleContainer.translatesAutoresizingMaskIntoConstraints = false
        toggleContainer.backgroundColor = .white
        toggleContainer.layer.cornerRadius = 10
        toggleContainer.layer.masksToBounds = true

        toggleLabel.translatesAutoresizingMaskIntoConstraints = false
        toggleLabel.text = "Delete Polygon"
        toggleLabel.textColor = .black
        toggleLabel.font = .systemFont(ofSize: 14, weight: .semibold)

        deleteSwitch.translatesAutoresizingMaskIntoConstraints = false
        deleteSwitch.isOn = false
        deleteSwitch.addTarget(self, action: #selector(respondToDeletePolygon(_:)), for: .valueChanged)

        toggleContainer.addSubview(toggleLabel)
        toggleContainer.addSubview(deleteSwitch)
        view.addSubview(toggleContainer)

        NSLayoutConstraint.activate([
            toggleContainer.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            toggleContainer.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),

            toggleLabel.leadingAnchor.constraint(equalTo: toggleContainer.leadingAnchor, constant: 10),
            toggleLabel.centerYAnchor.constraint(equalTo: toggleContainer.centerYAnchor),

            deleteSwitch.leadingAnchor.constraint(equalTo: toggleLabel.trailingAnchor, constant: 8),
            deleteSwitch.trailingAnchor.constraint(equalTo: toggleContainer.trailingAnchor, constant: -10),
            deleteSwitch.topAnchor.constraint(equalTo: toggleContainer.topAnchor, constant: 8),
            deleteSwitch.bottomAnchor.constraint(equalTo: toggleContainer.bottomAnchor, constant: -8)
        ])
    }

    @objc private func respondToDeletePolygon(_ sender: UISwitch) {
        let polygons = [polygon1, polygon2]
        if sender.isOn {
            polygons.forEach { $0?.mapView = nil }
        } else {
            polygons.forEach { $0?.mapView = mapView }
        }
    }
}
