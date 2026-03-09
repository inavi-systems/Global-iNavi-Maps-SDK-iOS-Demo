import UIKit
import iNaviGlobalMapSDK
import CoreLocation

final class CameraMoveDemoViewController: GenericDemoViewController {
    private let selectButton = UIButton(type: .system)
    private let moveButton = UIButton(type: .system)
    private let buttonContainer = UIStackView()

    private let position1 = CLLocationCoordinate2D(latitude: 25.033976, longitude: 121.561964)
    private let position2 = CLLocationCoordinate2D(latitude: 24.626516, longitude: 122.269514)

    private var isInitPosition = true
    private var cameraUpdateAnimation: IgmCameraUpdateAnimation = .fly
    private let animationTypes = ["None", "Linear", "Ease In", "Ease Out", "Fly"]

    init() { super.init(screenTitle: "Camera Move") }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupMarkers()
        setupButtons()
        selectButton.setTitle(animationTypes.last, for: .normal)
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

    private func setupButtons() {
        buttonContainer.translatesAutoresizingMaskIntoConstraints = false
        buttonContainer.axis = .vertical
        buttonContainer.alignment = .fill
        buttonContainer.distribution = .fillEqually
        buttonContainer.spacing = 8
        buttonContainer.backgroundColor = .white
        buttonContainer.layer.cornerRadius = 10
        buttonContainer.layer.masksToBounds = true
        buttonContainer.layoutMargins = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        buttonContainer.isLayoutMarginsRelativeArrangement = true

        selectButton.setTitleColor(.black, for: .normal)
        selectButton.backgroundColor = UIColor(white: 0.95, alpha: 1.0)
        selectButton.layer.cornerRadius = 8
        selectButton.addTarget(self, action: #selector(respondToCameraUpdateAnimation(_:)), for: .touchUpInside)

        moveButton.setTitle("Move Camera", for: .normal)
        moveButton.setTitleColor(.white, for: .normal)
        moveButton.backgroundColor = .systemBlue
        moveButton.layer.cornerRadius = 8
        moveButton.addTarget(self, action: #selector(respondToCameraMove(_:)), for: .touchUpInside)

        buttonContainer.addArrangedSubview(selectButton)
        buttonContainer.addArrangedSubview(moveButton)
        view.addSubview(buttonContainer)

        NSLayoutConstraint.activate([
            buttonContainer.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            buttonContainer.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            buttonContainer.widthAnchor.constraint(equalToConstant: 170)
        ])
    }

    @objc private func respondToCameraUpdateAnimation(_ sender: UIButton) {
        let alertController = UIAlertController(title: "Select Animation", message: nil, preferredStyle: .actionSheet)

        for (index, animationType) in animationTypes.enumerated() {
            alertController.addAction(UIAlertAction(title: animationType, style: .default) { [weak self] _ in
                guard let self else { return }
                switch index {
                case 1: self.cameraUpdateAnimation = .linear
                case 2: self.cameraUpdateAnimation = .easeIn
                case 3: self.cameraUpdateAnimation = .easeOut
                case 4: self.cameraUpdateAnimation = .fly
                default: self.cameraUpdateAnimation = .none
                }

                UIView.performWithoutAnimation {
                    self.selectButton.setTitle(self.animationTypes[index], for: .normal)
                    self.selectButton.layoutIfNeeded()
                }
            })
        }
        alertController.addAction(UIAlertAction(title: "Close", style: .cancel))

        if UIDevice.current.userInterfaceIdiom == .pad {
            if let popoverController = alertController.popoverPresentationController {
                popoverController.sourceView = sender
                popoverController.sourceRect = sender.bounds
                popoverController.permittedArrowDirections = .any
            }
        }
        present(alertController, animated: true)
    }

    @objc private func respondToCameraMove(_ sender: UIButton) {
        let cameraUpdate = IgmCameraUpdate.cameraUpdate(targetTo: isInitPosition ? position2 : position1)
        cameraUpdate.animation = cameraUpdateAnimation
        cameraUpdate.animationDuration = 3
        mapView?.moveCamera(cameraUpdate)
        isInitPosition.toggle()
    }
}
