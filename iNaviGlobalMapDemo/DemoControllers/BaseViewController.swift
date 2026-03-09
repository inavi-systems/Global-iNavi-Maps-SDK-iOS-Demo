//
//  BaseViewController.swift
//  iNaviGlobalMapDemo
//
//  Created by DAECHEOL KIM on 2/20/26.
//

import UIKit
import iNaviGlobalMapSDK
import CoreLocation
class BaseViewController: UIViewController {
    var mapView:IgmMapView?
    override func viewDidLoad() {
        super.viewDidLoad()
        IGMService.shared.delegate = self
        //24.9593093,121.3156949
        //25.033976,121.561964
//                let taipei = CLLocationCoordinate2D(latitude: 24.9593093, longitude: 121.3156949)
        let center = CLLocationCoordinate2D(latitude: 25.033976, longitude: 121.561964)
        mapView = IgmMapView(frame: self.view.bounds,
                             options: IgmMapOptions(camera: IgmCameraPosition.cameraPosition(center, zoom: 15)),
                             delegate: self)
        
//        area that restricts map panning.
//        mapView?.constraintBounds = IgmLatLngBounds(southWest: CLLocationCoordinate2DMake(21.5, 119.5),
//                                                    northEast: CLLocationCoordinate2DMake(25.8, 122.5))
//        mapView?.automaticallyAdjustsContentInset = false
        view = mapView
        navigationController?.navigationBar.isTranslucent = false
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    override func viewDidAppear(_ animated: Bool) {
        print("insets = \(mapView?.safeAreaInsets)")
    }

}

extension BaseViewController: IgmMapSdkDelegate {
    func authResultCode(_ resultCode: Int, message: String?) {
        print("authResultCode =\(resultCode), message = \(String(describing: message))")
        print("isMainThread \(Thread.isMainThread)")
    }
}

extension BaseViewController: IgmMapDelegate {
    
}
