import UIKit
import iNaviGlobalMapSDK
import CoreLocation

final class MarkerDemoViewController: GenericDemoViewController {
    
    private let marker1 = IgmMarker()
    private let marker2 = IgmMarker()
    private let marker3 = IgmMarker()
    private let marker4 = IgmMarker()
    private let marker5 = IgmMarker()
    private let marker6 = IgmMarker()
    
    init() { super.init(screenTitle: "Marker") }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        moveCameraToDemoArea()

//        let taipei101 = CLLocationCoordinate2D(latitude: 25.033976, longitude: 121.561964)
//
//        let marker = IgmMarker()
//        marker.position = taipei101
//        marker.title = "Taipei 101"
//        marker.userInfo = ["title": "Taipei 101"]
//        marker.mapView = mapView
//
//        let params = IgmCameraUpdateParams.cameraUpdateParams()
//        params.targetTo(taipei101)
//        params.zoomTo(14.0)
//        let update = IgmCameraUpdate.cameraUpdate(with: params)
//        mapView?.moveCamera(update)
        
        marker1.position = CLLocationCoordinate2D(latitude: 25.033976, longitude: 121.561964)
        marker1.title = "Title"
        marker1.mapView = mapView
        
        let rightBottomImage = UIImage(named: "Igm_marker_right_bottom")
        var marker2Image: IgmImage? = nil
        if let rightBottomImage = rightBottomImage {
            marker2Image = IgmImage.image(with: rightBottomImage)
        }
        
        marker2.position = CLLocationCoordinate2D(latitude: 25.036436, longitude: 121.561054)
        if let marker2Image = marker2Image {
            marker2.iconImage = marker2Image
            marker2.anchor = CGPoint(x: 0.9, y: 0.9)
            marker2.angle = 90
        }
        marker2.mapView = mapView
        
        marker3.position = CLLocationCoordinate2D(latitude: 25.034526, longitude: 121.559254)
        marker3.iconImage = IgmImage.markerImageBlue
        marker3.titleColor = UIColor.green
        marker3.title = "Title Color Applied"
        marker3.mapView = mapView
        
        marker4.position = CLLocationCoordinate2D(latitude: 25.031686, longitude: 121.560844)
        marker4.iconImage = IgmImage.markerImageYellow
        marker4.titleSize = 16
        marker4.title = "Title Size Applied"
        marker4.mapView = mapView
        
        marker5.position = CLLocationCoordinate2D(latitude: 25.035026, longitude: 121.563954)
        marker5.iconImage = IgmImage.markerImageGreen
        marker5.alpha = 0.5
        marker5.title = "Semi-Transparent Marker"
        marker5.mapView = mapView
        
        marker6.position = CLLocationCoordinate2D(latitude: 25.032366, longitude: 121.563504)
        marker6.iconImage = IgmImage.image(named: "baseline_star_black_24pt")
        marker6.iconScale = 2.0
        marker6.anchor = CGPoint(x: 0.5, y: 0.5)
        marker6.mapView = mapView
    }

    private func moveCameraToDemoArea() {
        let target = CLLocationCoordinate2D(latitude: 25.033976, longitude: 121.561964)
        let params = IgmCameraUpdateParams.cameraUpdateParams()
        params.targetTo(target)
        params.zoomTo(14.0)
        let update = IgmCameraUpdate.cameraUpdate(params: params)
        mapView?.moveCamera(update)
    }
}
