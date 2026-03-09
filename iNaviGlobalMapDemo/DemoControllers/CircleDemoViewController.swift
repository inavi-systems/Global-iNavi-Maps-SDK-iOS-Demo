import UIKit
import iNaviGlobalMapSDK
import CoreLocation

final class CircleDemoViewController: GenericDemoViewController {
    private let circle1 = IgmCircle()
    private let circle2 = IgmCircle()

    private let toggleContainer = UIView()
    private let toggleLabel = UILabel()
    private let deleteSwitch = UISwitch()

    init() { super.init(screenTitle: "Circel") }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        moveCameraToDemoArea()
        setupCircles()
        setupDeleteSwitch()
    }

    private func moveCameraToDemoArea() {
        let target = CLLocationCoordinate2D(latitude: 25.032476, longitude: 121.561964)
        let params = IgmCameraUpdateParams.cameraUpdateParams()
        params.targetTo(target)
        params.zoomTo(14.0)
        let update = IgmCameraUpdate.cameraUpdate(params: params)
        mapView?.moveCamera(update)
    }

    private func setupCircles() {
        circle1.center = CLLocationCoordinate2D(latitude: 25.033976, longitude: 121.561964)
        circle1.radius = 300
        circle1.fillColor = UIColor(red: 1.0, green: 0.0, blue: 0.0, alpha: 0.5)
        circle1.strokeColor = .red
        circle1.strokeWidth = 3
        circle1.mapView = mapView

        circle2.center = CLLocationCoordinate2D(latitude: 25.026566, longitude: 121.562354)
        circle2.radius = 200
        circle2.fillColor = UIColor(red: 0.0, green: 1.0, blue: 0.0, alpha: 0.5)
        circle2.strokeColor = .green
        circle2.strokeWidth = 3
        circle2.globalZIndex = 1000
        circle2.mapView = mapView
    }

    private func setupDeleteSwitch() {
        toggleContainer.translatesAutoresizingMaskIntoConstraints = false
        toggleContainer.backgroundColor = .white
        toggleContainer.layer.cornerRadius = 10
        toggleContainer.layer.masksToBounds = true

        toggleLabel.translatesAutoresizingMaskIntoConstraints = false
        toggleLabel.text = "Delete Circle"
        toggleLabel.textColor = .black
        toggleLabel.font = .systemFont(ofSize: 14, weight: .semibold)

        deleteSwitch.translatesAutoresizingMaskIntoConstraints = false
        deleteSwitch.isOn = false
        deleteSwitch.addTarget(self, action: #selector(respondToDeleteCircle(_:)), for: .valueChanged)

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

    @objc private func respondToDeleteCircle(_ sender: UISwitch) {
        let allCircles = [circle1, circle2]
        if sender.isOn {
            allCircles.forEach { $0.mapView = nil }
        } else {
            allCircles.forEach { $0.mapView = mapView }
        }
    }
}
