import UIKit
import iNaviGlobalMapSDK
import CoreLocation

final class ShapeClickDemoViewController: GenericDemoViewController {
    private let marker = IgmMarker()
    private var useClickEvent = true
    private var consumeClickEvent = true

    private let panel = UIStackView()

    init() { super.init(screenTitle: "Shape Click") }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupShape()
        setupControls()
    }

    private func setupShape() {
        marker.position = CLLocationCoordinate2D(latitude: 25.033976, longitude: 121.561964)
        marker.tag = 0
        marker.titleColor = .red
        marker.titleSize = 14
        marker.title = "Marker tapped 0 times"
        marker.touchEvent = { [weak self] shape in
            guard let self else { return false }
            if self.useClickEvent, let marker = shape as? IgmMarker {
                marker.tag += 1
                marker.title = "Marker \(marker.tag) taps"
            }
            return self.useClickEvent && self.consumeClickEvent
        }
        marker.mapView = mapView
    }

    private func setupControls() {
        panel.translatesAutoresizingMaskIntoConstraints = false
        panel.axis = .vertical
        panel.alignment = .fill
        panel.distribution = .fill
        panel.spacing = 8
        panel.backgroundColor = .white
        panel.layer.cornerRadius = 10
        panel.layer.masksToBounds = true
        panel.layoutMargins = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        panel.isLayoutMarginsRelativeArrangement = true

        panel.addArrangedSubview(makeSwitchRow(title: "Use Shape Click", initial: true, tag: 0))
        panel.addArrangedSubview(makeSwitchRow(title: "Consume Click", initial: true, tag: 1))

        view.addSubview(panel)
        NSLayoutConstraint.activate([
            panel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            panel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            panel.widthAnchor.constraint(equalToConstant: 220)
        ])
    }

    private func makeSwitchRow(title: String, initial: Bool, tag: Int) -> UIView {
        let row = UIView()
        row.translatesAutoresizingMaskIntoConstraints = false

        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = title
        label.textColor = .black
        label.font = .systemFont(ofSize: 14, weight: .semibold)

        let uiSwitch = UISwitch()
        uiSwitch.translatesAutoresizingMaskIntoConstraints = false
        uiSwitch.tag = tag
        uiSwitch.isOn = initial
        uiSwitch.addTarget(self, action: #selector(respondToShapeClickEvent(_:)), for: .valueChanged)

        row.addSubview(label)
        row.addSubview(uiSwitch)
        NSLayoutConstraint.activate([
            row.heightAnchor.constraint(equalToConstant: 34),
            label.leadingAnchor.constraint(equalTo: row.leadingAnchor),
            label.centerYAnchor.constraint(equalTo: row.centerYAnchor),
            uiSwitch.trailingAnchor.constraint(equalTo: row.trailingAnchor),
            uiSwitch.centerYAnchor.constraint(equalTo: row.centerYAnchor),
            label.trailingAnchor.constraint(lessThanOrEqualTo: uiSwitch.leadingAnchor, constant: -8)
        ])
        return row
    }

    @objc private func respondToShapeClickEvent(_ sender: UISwitch) {
        switch sender.tag {
        case 0:
            useClickEvent = sender.isOn
        case 1:
            consumeClickEvent = sender.isOn
        default:
            break
        }
    }
}

extension ShapeClickDemoViewController {
    func didTapMapView(_ point: CGPoint, latLng: CLLocationCoordinate2D) {
        let message = String(
            format: "Screen : (%.0f, %.0f)\nMap : (%.5f, %.5f)",
            point.x,
            point.y,
            latLng.latitude,
            latLng.longitude
        )
        let alertController = UIAlertController(title: "Map Click", message: message, preferredStyle: .alert)
        present(alertController, animated: true) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                alertController.dismiss(animated: true)
            }
        }
    }
}
