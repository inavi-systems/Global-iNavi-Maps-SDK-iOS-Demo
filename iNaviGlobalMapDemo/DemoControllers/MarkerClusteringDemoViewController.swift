import UIKit
import iNaviGlobalMapSDK
import CoreLocation

final class IgmNumberItem: NSObject, IgmClusterItem {
    let position: CLLocationCoordinate2D
    let number: Int

    init(position: CLLocationCoordinate2D, number: Int) {
        self.position = position
        self.number = number
    }
}

final class MarkerClusteringDemoViewController: GenericDemoViewController {
    private let backgroundColors: [UIColor] = [
        UIColor(hex: 0x0099cc),
        UIColor(hex: 0x669900),
        UIColor(hex: 0xff8800),
        UIColor(hex: 0xcc0000),
        UIColor(hex: 0x9933cc)
    ]

    private let criteria: [UInt] = [10, 50, 100, 200, 500]
    private let markerImages: [IgmImage] = [
        IgmImage.markerImageRed,
        IgmImage.markerImageGreen,
        IgmImage.markerImageBlue,
        IgmImage.markerImageYellow,
        IgmImage.markerImageGray
    ]

    private let centerPosition = CLLocationCoordinate2D(latitude: 25.033976, longitude: 121.561964)
    private var clusterManager: IgmClusterManager?

    init() { super.init(screenTitle: "Marker Clustering") }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        guard let mapView else { return }
        let manager = IgmClusterManager(mapView: mapView)
        manager.delegate = self
        manager.clusterIconGenerator = IgmDefaultClusterIconGenerator(colors: backgroundColors, criteria: criteria)
        clusterManager = manager

        mapView.moveCamera(IgmCameraUpdate.cameraUpdate(zoomTo: 13.0))
        mapView.isZoomControlVisible = true

        for index in 1...1000 {
            let item = IgmNumberItem(position: generateRandomPosition(), number: index)
            manager.addItem(item)
        }
    }

    private func generateRandomPosition() -> CLLocationCoordinate2D {
        func randomScale() -> Double {
            Double(arc4random()) / Double(UInt32.max) * 2.0 - 1.0
        }

        let extent = 0.02
        return CLLocationCoordinate2D(
            latitude: centerPosition.latitude + extent * randomScale(),
            longitude: centerPosition.longitude + extent * randomScale()
        )
    }

    private func formattedCoordinate(_ coordinate: CLLocationCoordinate2D) -> String {
        String(format: "(%.5f, %.5f)", coordinate.latitude, coordinate.longitude)
    }

    private func presentToastLikeAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        present(alert, animated: true) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                alert.dismiss(animated: true)
            }
        }
    }
}

extension MarkerClusteringDemoViewController: IgmClusterManagerDelegate {
    func clusterManager(_ clusterManager: IgmClusterManager, willRenderCluster cluster: any IgmCluster, with markerOptions: any IgmMarkerOptions) {
        markerOptions.position = cluster.position
    }

    func clusterManager(_ clusterManager: IgmClusterManager, willRenderClusterItem clusterItem: any IgmClusterItem, with markerOptions: any IgmMarkerOptions) {
        markerOptions.position = clusterItem.position
        markerOptions.iconScale = 0.8
        if let item = clusterItem as? IgmNumberItem {
            markerOptions.iconImage = markerImages[item.number % markerImages.count]
            markerOptions.title = "Marker #\(item.number)"
        }
    }

    func clusterManager(_ clusterManager: IgmClusterManager, didTapCluster cluster: any IgmCluster, with markerOptions: any IgmMarkerOptions) -> Bool {
        let position = cluster.position
        let message = "Position : \(formattedCoordinate(position))\nIncluded item count : \(cluster.count)"
        presentToastLikeAlert(title: "Cluster Click", message: message)

        let params = IgmCameraUpdateParams.cameraUpdateParams()
        params.targetTo(position)
        let update = IgmCameraUpdate.cameraUpdate(params: params)
        update.animation = .easeIn
        mapView?.moveCamera(update)
        return true
    }

    func clusterManager(_ clusterManager: IgmClusterManager, didTapClusterItem clusterItem: any IgmClusterItem, with markerOptions: any IgmMarkerOptions) -> Bool {
        let position = clusterItem.position
        var message = "Position : \(formattedCoordinate(position))"
        if let item = clusterItem as? IgmNumberItem {
            message.append("\nNumber : \(item.number)")
        }
        presentToastLikeAlert(title: "Item Click", message: message)

        let params = IgmCameraUpdateParams.cameraUpdateParams()
        params.targetTo(position)
        let update = IgmCameraUpdate.cameraUpdate(params: params)
        update.animation = .easeIn
        mapView?.moveCamera(update)
        return true
    }
}

private extension UIColor {
    convenience init(hex: Int) {
        self.init(
            red: CGFloat((hex & 0xff0000) >> 16) / 255.0,
            green: CGFloat((hex & 0x00ff00) >> 8) / 255.0,
            blue: CGFloat(hex & 0x0000ff) / 255.0,
            alpha: 1.0
        )
    }
}
