//
//  ViewController.swift
//  iNaviGlobalMapDemo
//
//  Created by DAECHEOL KIM on 1/22/26.
//

import UIKit

struct DemoSection {
    let title: String
    let items: [String]
}

final class ViewController: UIViewController {
    private let tableView = UITableView(frame: .zero, style: .insetGrouped)

    private let sections: [DemoSection] = [
        DemoSection(title: "Map", items: ["MapView"]),
        DemoSection(title: "Shape", items: ["Marker", "Marker Overlap", "infoWindow", "Polygon", "PolyLine", "Circel", "Global Z-Index"]),
        DemoSection(title: "Clustering", items: ["Marker Clustering"]),
        DemoSection(title: "Camera", items: ["Camera Move", "Camera Move to Fit Bounds", "Camera Events"]),
        DemoSection(title: "Click Events", items: ["Map Click", "Shape Click"]),
        DemoSection(title: "Location", items: ["User Tracking Mode", "Location Icon"]),
        DemoSection(title: "Misc", items: ["Projection", "Coordinates Conversion"])
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "iNavi Global Map Demo"
        view.backgroundColor = .systemBackground

        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "DemoCell")
        tableView.rowHeight = 52
        tableView.sectionHeaderTopPadding = 8

        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
}

extension ViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        sections.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        sections[section].items.count
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        sections[section].title
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = sections[indexPath.section].items[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "DemoCell", for: indexPath)
        var config = cell.defaultContentConfiguration()
        config.text = item
        config.secondaryText = "BaseViewController"
        cell.contentConfiguration = config
        cell.accessoryType = .disclosureIndicator
        return cell
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let item = sections[indexPath.section].items[indexPath.row]
        let destination = DemoViewControllerFactory.make(for: item)
        showDestination(destination)
    }

    private func showDestination(_ viewController: BaseViewController) {
        if let splitViewController, !splitViewController.isCollapsed {
            let navigationController = UINavigationController(rootViewController: viewController)
            navigationController.navigationBar.isTranslucent = false
            showDetailViewController(navigationController, sender: self)
            return
        }

        navigationController?.pushViewController(viewController, animated: true)
    }
}

private enum DemoViewControllerFactory {
    static func make(for item: String) -> BaseViewController {
        switch item {
        case "MapView": return MapViewDemoViewController()
        case "Marker": return MarkerDemoViewController()
        case "Marker Overlap": return MarkerOverlapDemoViewController()
        case "infoWindow": return InfoWindowDemoViewController()
        case "Polygon": return PolygonDemoViewController()
        case "PolyLine": return PolyLineDemoViewController()
        case "Circel": return CircleDemoViewController()
        case "Global Z-Index": return GlobalZIndexDemoViewController()
        case "Marker Clustering": return MarkerClusteringDemoViewController()
        case "Camera Move": return CameraMoveDemoViewController()
        case "Camera Move to Fit Bounds": return CameraFitBoundsDemoViewController()
        case "Camera Events": return CameraEventsDemoViewController()
        case "Map Click": return MapClickDemoViewController()
        case "Shape Click": return ShapeClickDemoViewController()
        case "User Tracking Mode": return UserTrackingModeDemoViewController()
        case "Location Icon": return LocationIconDemoViewController()
        case "Projection": return ProjectionDemoViewController()
        case "Coordinates Conversion": return CoordinatesConversionDemoViewController()
        default: return GenericDemoViewController(screenTitle: item)
        }
    }
}

extension ViewController: UISplitViewControllerDelegate {
    func primaryViewController(forExpanding splitViewController: UISplitViewController) -> UIViewController? {
        nil
    }

    func primaryViewController(forCollapsing splitViewController: UISplitViewController) -> UIViewController? {
        nil
    }

    func splitViewController(
        _ splitViewController: UISplitViewController,
        collapseSecondary secondaryViewController: UIViewController,
        onto primaryViewController: UIViewController
    ) -> Bool {
        true
    }
}
