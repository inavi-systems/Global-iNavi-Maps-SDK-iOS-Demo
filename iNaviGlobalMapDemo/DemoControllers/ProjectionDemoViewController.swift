import UIKit
import iNaviGlobalMapSDK
import CoreLocation

final class ProjectionDemoViewController: GenericDemoViewController {
    private let infoContainer = UIStackView()
    private let tvLatLng = UILabel()
    private let tvScreenPoint = UILabel()
    private let crossHair = UIImageView()

    init() { super.init(screenTitle: "Projection") }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupOverlayUI()
        showProjectionInfo()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        showProjectionInfo()
    }

    private func setupOverlayUI() {
        crossHair.translatesAutoresizingMaskIntoConstraints = false
        crossHair.image = UIImage(named: "crosshair")
        crossHair.contentMode = .scaleAspectFit
        view.addSubview(crossHair)

        infoContainer.translatesAutoresizingMaskIntoConstraints = false
        infoContainer.axis = .vertical
        infoContainer.spacing = 6
        infoContainer.alignment = .fill
        infoContainer.distribution = .fill
        infoContainer.backgroundColor = UIColor.white.withAlphaComponent(0.9)
        infoContainer.layer.cornerRadius = 10
        infoContainer.layer.masksToBounds = true
        infoContainer.layoutMargins = UIEdgeInsets(top: 8, left: 10, bottom: 8, right: 10)
        infoContainer.isLayoutMarginsRelativeArrangement = true

        tvScreenPoint.numberOfLines = 1
        tvScreenPoint.font = .systemFont(ofSize: 13, weight: .semibold)
        tvScreenPoint.textColor = .black

        tvLatLng.numberOfLines = 1
        tvLatLng.font = .systemFont(ofSize: 13, weight: .semibold)
        tvLatLng.textColor = .black

        infoContainer.addArrangedSubview(tvScreenPoint)
        infoContainer.addArrangedSubview(tvLatLng)
        view.addSubview(infoContainer)

        NSLayoutConstraint.activate([
            crossHair.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            crossHair.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            crossHair.widthAnchor.constraint(equalToConstant: 32),
            crossHair.heightAnchor.constraint(equalToConstant: 32),

            infoContainer.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            infoContainer.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            infoContainer.leadingAnchor.constraint(greaterThanOrEqualTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10)
        ])
    }

    private func showProjectionInfo() {
        DispatchQueue.main.async { [weak self] in
            guard let self, let mapView else { return }
            let centerPoint = crossHair.center
            if let latLng = mapView.projection.latlng(point: centerPoint) {
                _ = mapView.projection.point(coord: latLng)
                tvScreenPoint.text = String(format: "Screen Coordinates : (%.1f, %.1f)", centerPoint.x, centerPoint.y)
                tvLatLng.text = String(format: "Map Coordinates : (%.5f, %.5f)", latLng.latitude, latLng.longitude)
            }
        }
    }
}

extension ProjectionDemoViewController {
    func mapView(_ mapView: IgmMapView, regionWillChangeAnimated animated: Bool, reason: IgmCameraUpdateReason) {
        showProjectionInfo()
    }

    func mapView(_ mapView: IgmMapView, regionIsChangingWithReason reason: IgmCameraUpdateReason) {
        showProjectionInfo()
    }

    func mapView(_ mapView: IgmMapView, regionDidChangeAnimated animated: Bool, reason: IgmCameraUpdateReason) {
        showProjectionInfo()
    }
}
