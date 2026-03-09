import UIKit
import iNaviGlobalMapSDK
import CoreLocation

final class CameraUpdateParamsDemoViewController: GenericDemoViewController {
    private let position1 = CLLocationCoordinate2D(latitude: 25.033976, longitude: 121.561964)
    private let position2 = CLLocationCoordinate2D(latitude: 24.626516, longitude: 122.269514)
    private let maximumTilt = 60.0

    private var updateTarget = false
    private var updateZoom = true
    private var updateTilt = true
    private var updateBearing = true
    private var isInitPosition = true

    private let panel = UIStackView()

    init() { super.init(screenTitle: "CameraUpdateParams") }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupMarkers()
        setupControlPanel()
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

    private func setupControlPanel() {
        panel.translatesAutoresizingMaskIntoConstraints = false
        panel.axis = .vertical
        panel.spacing = 8
        panel.alignment = .fill
        panel.distribution = .fill
        panel.backgroundColor = .white
        panel.layer.cornerRadius = 10
        panel.layer.masksToBounds = true
        panel.layoutMargins = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        panel.isLayoutMarginsRelativeArrangement = true

        panel.addArrangedSubview(makeSwitchRow(title: "Target", initial: updateTarget, action: #selector(respondToCameraUpdateTarget(_:))))
        panel.addArrangedSubview(makeSwitchRow(title: "Zoom", initial: updateZoom, action: #selector(respondToCameraUpdateZoom(_:))))
        panel.addArrangedSubview(makeSwitchRow(title: "Tilt", initial: updateTilt, action: #selector(respondToCameraUpdateTilt(_:))))
        panel.addArrangedSubview(makeSwitchRow(title: "Bearing", initial: updateBearing, action: #selector(respondToCameraUpdateBearing(_:))))

        let applyButton = UIButton(type: .system)
        applyButton.setTitle("Apply Params", for: .normal)
        applyButton.setTitleColor(.white, for: .normal)
        applyButton.backgroundColor = .systemBlue
        applyButton.layer.cornerRadius = 8
        applyButton.contentEdgeInsets = UIEdgeInsets(top: 10, left: 12, bottom: 10, right: 12)
        applyButton.addTarget(self, action: #selector(respondToCameraUpdate(_:)), for: .touchUpInside)
        panel.addArrangedSubview(applyButton)

        view.addSubview(panel)
        NSLayoutConstraint.activate([
            panel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            panel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            panel.widthAnchor.constraint(equalToConstant: 230)
        ])
    }

    private func makeSwitchRow(title: String, initial: Bool, action: Selector) -> UIView {
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
        uiSwitch.addTarget(self, action: action, for: .valueChanged)

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

    @objc private func respondToCameraUpdateTarget(_ sender: UISwitch) {
        updateTarget = sender.isOn
    }

    @objc private func respondToCameraUpdateZoom(_ sender: UISwitch) {
        updateZoom = sender.isOn
    }

    @objc private func respondToCameraUpdateTilt(_ sender: UISwitch) {
        updateTilt = sender.isOn
    }

    @objc private func respondToCameraUpdateBearing(_ sender: UISwitch) {
        updateBearing = sender.isOn
    }

    @objc private func respondToCameraUpdate(_ sender: UIButton) {
        guard let mapView, let cameraPosition = mapView.cameraPosition else { return }

        let params = IgmCameraUpdateParams.cameraUpdateParams()
        var duration = 1.0

        if updateTarget {
            params.targetTo(isInitPosition ? position2 : position1)
            isInitPosition.toggle()
            duration = 5.0
        }

        if updateZoom {
            var zoomDelta = 3.0
            if cameraPosition.zoom + zoomDelta >= mapView.maximumZoomLevel {
                zoomDelta *= -1
            }
            params.zoomBy(zoomDelta)
        }

        if updateTilt {
            var tiltDelta = 10.0
            if cameraPosition.tilt + tiltDelta >= maximumTilt {
                tiltDelta *= -1
            }
            params.tiltBy(tiltDelta)
        }

        if updateBearing {
            params.bearingBy(30)
        }

        let cameraUpdate = IgmCameraUpdate.cameraUpdate(params: params)
        cameraUpdate.animation = .fly
        cameraUpdate.animationDuration = duration
        mapView.moveCamera(cameraUpdate)
    }
}
