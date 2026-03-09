import UIKit
import iNaviGlobalMapSDK
import CoreLocation

final class MapClickDemoViewController: GenericDemoViewController {
    private var useClickEvent = true
    private var useLongClickEvent = true

    private let panel = UIStackView()

    init() { super.init(screenTitle: "Map Click") }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupControls()
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

        panel.addArrangedSubview(makeSwitchRow(title: "Map Click", initial: true, tag: 0))
        panel.addArrangedSubview(makeSwitchRow(title: "Map Long Click", initial: true, tag: 1))

        view.addSubview(panel)
        NSLayoutConstraint.activate([
            panel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            panel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            panel.widthAnchor.constraint(equalToConstant: 230)
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
        uiSwitch.isOn = initial
        uiSwitch.tag = tag
        uiSwitch.addTarget(self, action: #selector(respondToMapClickEvent(_:)), for: .valueChanged)

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

    private func showAlertMessage(_ title: String, point: CGPoint, latLng: CLLocationCoordinate2D) {
        let message = String(
            format: "Screen : (%.0f, %.0f)\nMap : (%.5f, %.5f)",
            point.x,
            point.y,
            latLng.latitude,
            latLng.longitude
        )
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        present(alertController, animated: true) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                alertController.dismiss(animated: true)
            }
        }
    }

    @objc private func respondToMapClickEvent(_ sender: UISwitch) {
        switch sender.tag {
        case 0:
            useClickEvent = sender.isOn
        case 1:
            useLongClickEvent = sender.isOn
        default:
            break
        }
    }
}

extension MapClickDemoViewController {
    func didTapMapView(_ point: CGPoint, latLng: CLLocationCoordinate2D) {
        if useClickEvent {
            showAlertMessage("Map Click", point: point, latLng: latLng)
        }
    }

    func didLongTapMapView(_ point: CGPoint, latLng: CLLocationCoordinate2D) {
        if useLongClickEvent {
            showAlertMessage("Map Long Click", point: point, latLng: latLng)
        }
    }
}
