import UIKit
import iNaviGlobalMapSDK
import CoreLocation

final class CoordinatesConversionDemoViewController: GenericDemoViewController {
    private let panel = UIStackView()
    private let tvLatLng = UILabel()
    private let convertButton = UIButton(type: .system)
    private let crossHair = UIImageView()

    private var currentPosition = CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0)

    init() { super.init(screenTitle: "Coordinates Conversion") }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupOverlayUI()
        showWGS84Info()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        showWGS84Info()
    }

    private func setupOverlayUI() {
        crossHair.translatesAutoresizingMaskIntoConstraints = false
        crossHair.image = UIImage(named: "crosshair")
        crossHair.contentMode = .scaleAspectFit
        view.addSubview(crossHair)

        panel.translatesAutoresizingMaskIntoConstraints = false
        panel.axis = .vertical
        panel.alignment = .fill
        panel.distribution = .fill
        panel.spacing = 8
        panel.backgroundColor = UIColor.white.withAlphaComponent(0.9)
        panel.layer.cornerRadius = 10
        panel.layer.masksToBounds = true
        panel.layoutMargins = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        panel.isLayoutMarginsRelativeArrangement = true

        tvLatLng.numberOfLines = 1
        tvLatLng.font = .systemFont(ofSize: 13, weight: .semibold)
        tvLatLng.textColor = .black
        tvLatLng.text = "(0.00000, 0.00000)"

        convertButton.setTitle("Convert Coordinates", for: .normal)
        convertButton.setTitleColor(.white, for: .normal)
        convertButton.backgroundColor = .systemBlue
        convertButton.layer.cornerRadius = 8
        convertButton.contentEdgeInsets = UIEdgeInsets(top: 10, left: 12, bottom: 10, right: 12)
        convertButton.addTarget(self, action: #selector(respondToCoordinatesConversion(_:)), for: .touchUpInside)

        panel.addArrangedSubview(tvLatLng)
        panel.addArrangedSubview(convertButton)
        view.addSubview(panel)

        NSLayoutConstraint.activate([
            crossHair.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            crossHair.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            crossHair.widthAnchor.constraint(equalToConstant: 32),
            crossHair.heightAnchor.constraint(equalToConstant: 32),

            panel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            panel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            panel.leadingAnchor.constraint(greaterThanOrEqualTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10)
        ])
    }

    private func showWGS84Info() {
        DispatchQueue.main.async { [weak self] in
            guard let self, let mapView else { return }
            let centerPoint = crossHair.center
            if let latLng = mapView.projection.latlng(point: centerPoint) {
                currentPosition = latLng
                _ = mapView.projection.point(coord: latLng)
                tvLatLng.text = String(format: "(%.5f, %.5f)", latLng.latitude, latLng.longitude)
            }
        }
    }

    @objc private func respondToCoordinatesConversion(_ sender: UIButton) {
        let wgs84 = currentPosition
        let katec = IgmKatec(latLng: wgs84)
        let utmk = IgmUtmk(latLng: wgs84)
        let tm = IgmTm(latLng: wgs84)
        let grs80 = IgmGrs80(latLng: wgs84)

        let message = """
        KATEC Coordinates
        \(String(format: "(%.5f, %.5f)", katec.x, katec.y))

        UTM-K Coordinates
        \(String(format: "(%.5f, %.5f)", utmk.x, utmk.y))

        TM Coordinates
        \(String(format: "(%.5f, %.5f)", tm.x, tm.y))

        GRS80 Coordinates
        \(String(format: "(%.5f, %.5f)", grs80.x, grs80.y))
        """

        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default)
        alert.addAction(okAction)
        present(alert, animated: true)
    }
}

extension CoordinatesConversionDemoViewController {
    func mapView(_ mapView: IgmMapView, regionWillChangeAnimated animated: Bool, reason: IgmCameraUpdateReason) {
        showWGS84Info()
    }

    func mapView(_ mapView: IgmMapView, regionIsChangingWithReason reason: IgmCameraUpdateReason) {
        showWGS84Info()
    }

    func mapView(_ mapView: IgmMapView, regionDidChangeAnimated animated: Bool, reason: IgmCameraUpdateReason) {
        showWGS84Info()
    }
}
