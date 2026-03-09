import UIKit
import iNaviGlobalMapSDK

final class LocationIconDemoViewController: GenericDemoViewController {
    private var locationIcon: IgmLocationIcon?

    private var defaultImage: IgmImage?
    private var defaultScale: CGFloat = 1.0
    private var defaultCircleRadius: Double = 50.0
    private var defaultCircleColor: UIColor?

    private let panel = UIStackView()
    private let imageSwitch = UISwitch()
    private let scaleSwitch = UISwitch()
    private let circleRadiusSwitch = UISwitch()
    private let circleColorSwitch = UISwitch()
    private let bearingValueLabel = UILabel()

    init() { super.init(screenTitle: "Location Icon") }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupLocationIcon()
        setupControlPanel()
        updateBearingLabel()
    }

    private func setupLocationIcon() {
        guard let mapView else { return }
        locationIcon = mapView.locationIcon

        defaultImage = locationIcon?.imageTracking
        defaultScale = locationIcon?.scale ?? 1.0
        defaultCircleRadius = locationIcon?.circleRadius ?? 24.0
        defaultCircleColor = locationIcon?.circleColor

        locationIcon?.touchEvent = { [weak self] in
            let alert = UIAlertController(title: "Location Icon Tapped", message: nil, preferredStyle: .alert)
            self?.present(alert, animated: true) {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    alert.dismiss(animated: true)
                }
            }
        }
    }

    private func setupControlPanel() {
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

        panel.addArrangedSubview(makeSwitchRow(title: "Visible", uiSwitch: makeVisibleSwitch()))
        panel.addArrangedSubview(makeSwitchRow(title: "Custom Image", uiSwitch: imageSwitch))
        panel.addArrangedSubview(makeSwitchRow(title: "Scale x2", uiSwitch: scaleSwitch))
        panel.addArrangedSubview(makeSwitchRow(title: "Circle Radius", uiSwitch: circleRadiusSwitch))
        panel.addArrangedSubview(makeSwitchRow(title: "Circle Color", uiSwitch: circleColorSwitch))

        imageSwitch.addTarget(self, action: #selector(respondToLocationIconImage(_:)), for: .valueChanged)
        scaleSwitch.addTarget(self, action: #selector(respondToLocationIconScale(_:)), for: .valueChanged)
        circleRadiusSwitch.addTarget(self, action: #selector(respondToLocationIconCircleRadius(_:)), for: .valueChanged)
        circleColorSwitch.addTarget(self, action: #selector(respondToLocationIconCircleColor(_:)), for: .valueChanged)

        view.addSubview(panel)
        NSLayoutConstraint.activate([
            panel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            panel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            panel.widthAnchor.constraint(equalToConstant: 250)
        ])

        setOptionControlsEnabled(locationIcon?.isVisible ?? true)
    }

    private func makeVisibleSwitch() -> UISwitch {
        let visibleSwitch = UISwitch()
        visibleSwitch.translatesAutoresizingMaskIntoConstraints = false
        visibleSwitch.isOn = locationIcon?.isVisible ?? true
        visibleSwitch.addTarget(self, action: #selector(respondToLocationIconVisible(_:)), for: .valueChanged)
        return visibleSwitch
    }

    private func makeSwitchRow(title: String, uiSwitch: UISwitch) -> UIView {
        let row = UIView()
        row.translatesAutoresizingMaskIntoConstraints = false

        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = title
        label.textColor = .black
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        label.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        label.setContentHuggingPriority(.defaultLow, for: .horizontal)

        uiSwitch.translatesAutoresizingMaskIntoConstraints = false
        uiSwitch.setContentCompressionResistancePriority(.required, for: .horizontal)
        uiSwitch.setContentHuggingPriority(.required, for: .horizontal)

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

    private func makeBearingRow() -> UIView {
        let row = UIView()
        row.translatesAutoresizingMaskIntoConstraints = false

        let title = UILabel()
        title.translatesAutoresizingMaskIntoConstraints = false
        title.text = "Bearing (ReadOnly)"
        title.textColor = .black
        title.font = .systemFont(ofSize: 14, weight: .semibold)

        bearingValueLabel.translatesAutoresizingMaskIntoConstraints = false
        bearingValueLabel.textColor = .darkGray
        bearingValueLabel.font = .systemFont(ofSize: 13, weight: .medium)
        bearingValueLabel.textAlignment = .right

        row.addSubview(title)
        row.addSubview(bearingValueLabel)
        NSLayoutConstraint.activate([
            row.heightAnchor.constraint(equalToConstant: 34),
            title.leadingAnchor.constraint(equalTo: row.leadingAnchor),
            title.centerYAnchor.constraint(equalTo: row.centerYAnchor),
            bearingValueLabel.trailingAnchor.constraint(equalTo: row.trailingAnchor),
            bearingValueLabel.centerYAnchor.constraint(equalTo: row.centerYAnchor),
            title.trailingAnchor.constraint(lessThanOrEqualTo: bearingValueLabel.leadingAnchor, constant: -8)
        ])
        return row
    }

    private func setOptionControlsEnabled(_ enabled: Bool) {
        imageSwitch.isEnabled = enabled
        scaleSwitch.isEnabled = enabled
        circleRadiusSwitch.isEnabled = enabled
        circleColorSwitch.isEnabled = enabled
    }

    private func updateBearingLabel() {
        let value = Int(locationIcon?.bearing ?? 0)
        bearingValueLabel.text = "\(value)°"
    }

    @objc private func respondToLocationIconVisible(_ sender: UISwitch) {
        mapView?.userTrackingMode = sender.isOn ? .tracking : .none
        setOptionControlsEnabled(sender.isOn)
        updateBearingLabel()
    }

    @objc private func respondToLocationIconImage(_ sender: UISwitch) {
        if sender.isOn, let customImage = IgmImage.image(named: "baseline_directions_run_black_36pt") {
            locationIcon?.image = customImage
            locationIcon?.imageTracking = customImage
        } else {
            locationIcon?.image = defaultImage
            locationIcon?.imageTracking = defaultImage
        }
    }

    @objc private func respondToLocationIconScale(_ sender: UISwitch) {
        locationIcon?.scale = sender.isOn ? 2.0 : defaultScale
    }

    @objc private func respondToLocationIconCircleRadius(_ sender: UISwitch) {
        locationIcon?.circleRadius = sender.isOn ? 100.0 : defaultCircleRadius
    }

    @objc private func respondToLocationIconCircleColor(_ sender: UISwitch) {
        locationIcon?.circleColor = sender.isOn ? .yellow : defaultCircleColor
    }
}
