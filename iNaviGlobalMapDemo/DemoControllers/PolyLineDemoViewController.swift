import UIKit
import iNaviGlobalMapSDK
import CoreLocation

final class PolyLineDemoViewController: GenericDemoViewController {
    private var polyline1: IgmPolyline?
    private var polyline2: IgmPolyline?

    private let toggleContainer = UIView()
    private let toggleLabel = UILabel()
    private let deleteSwitch = UISwitch()

    private let polyline1Coords: [CLLocationCoordinate2D] = [
        CLLocationCoordinate2D(latitude: 25.040936, longitude: 121.565194),
        CLLocationCoordinate2D(latitude: 25.036436, longitude: 121.561054),
        CLLocationCoordinate2D(latitude: 25.032496, longitude: 121.567094),
        CLLocationCoordinate2D(latitude: 25.031236, longitude: 121.559584)
    ]

    private let polyline2Coords: [CLLocationCoordinate2D] = [
        CLLocationCoordinate2D(latitude: 25.031236, longitude: 121.559584),
        CLLocationCoordinate2D(latitude: 25.026706, longitude: 121.562464)
    ]

    init() { super.init(screenTitle: "PolyLine") }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        moveCameraToDemoArea()
        setupPolylines()
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

    private func setupPolylines() {
        let line1 = IgmPolyline(coords: polyline1Coords)
        line1.color = .red
        line1.width = 3
        line1.mapView = mapView
        polyline1 = line1

        let line2 = IgmPolyline(coords: polyline2Coords)
        line2.color = .blue
        line2.pattern = [10, 10]
        line2.width = 3
        line2.mapView = mapView
        polyline2 = line2
    }

    private func setupDeleteSwitch() {
        toggleContainer.translatesAutoresizingMaskIntoConstraints = false
        toggleContainer.backgroundColor = .white
        toggleContainer.layer.cornerRadius = 10
        toggleContainer.layer.masksToBounds = true

        toggleLabel.translatesAutoresizingMaskIntoConstraints = false
        toggleLabel.text = "Delete PolyLine"
        toggleLabel.textColor = .black
        toggleLabel.font = .systemFont(ofSize: 14, weight: .semibold)

        deleteSwitch.translatesAutoresizingMaskIntoConstraints = false
        deleteSwitch.isOn = false
        deleteSwitch.addTarget(self, action: #selector(respondToDeletePolyline(_:)), for: .valueChanged)

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

    @objc private func respondToDeletePolyline(_ sender: UISwitch) {
        let allPolylines = [polyline1, polyline2]
        if sender.isOn {
            allPolylines.forEach { $0?.mapView = nil }
        } else {
            allPolylines.forEach { $0?.mapView = mapView }
        }
    }
}
