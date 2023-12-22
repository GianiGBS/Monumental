//
//  MapViewController.swift
//  Monumental
//
//  Created by Giovanni Gabriel on 04/12/2023.
//
// swiftlint:disable line_length
import UIKit
import MapKit
import FloatingPanel

class MapViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var mapView: MKMapView!
    // MARK: - Properties
    let floatingPanelController = FloatingPanelController()
    let floatingPanelStoryboardID = "tableViewFloatingPanel"
    var landmarks: [Landmark] = []

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMapView()
        setUpFloatingPanel()
    }

    // MARK: - Methods
    // MARK: FloatingPanel
    func setUpFloatingPanel() {
        // Initialize a `FloatingPanelController` object.
        floatingPanelController.delegate = self
        // Set a content view controller.
        guard let contentPanelVC = storyboard?.instantiateViewController(identifier: floatingPanelStoryboardID) as? SelectViewController else { return }
        floatingPanelController.set(contentViewController: contentPanelVC)
        floatingPanelController.addPanel(toParent: self)
    }
    // MARK: MapView
    func setupMapView() {
            mapView.delegate = self
            mapView.showsUserLocation = true
            // Set the initial region or center the map based on your requirements.
        }
    func centerMapOnLandmarks() {
        guard !landmarks.isEmpty, let firstCoordinate = landmarks.first?.coordonneesWgs84 else {
                    return
                }

                var bounds = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: firstCoordinate.lat ?? 0, longitude: firstCoordinate.lon ?? 0),
                                                 span: MKCoordinateSpan(latitudeDelta: 0, longitudeDelta: 0))

                for coordinate in landmarks.compactMap({ $0.coordonneesWgs84 }) {
                    bounds.center.latitude += coordinate.lat ?? 0
                    bounds.center.longitude += coordinate.lon ?? 0
                    bounds.span.latitudeDelta = max(bounds.span.latitudeDelta, abs(coordinate.lat ?? 0 - bounds.center.latitude) * 2)
                    bounds.span.longitudeDelta = max(bounds.span.longitudeDelta, abs(coordinate.lon ?? 0 - bounds.center.longitude) * 2)
                }

                mapView.setRegion(bounds, animated: true)
            }
    func addLandmarkMarkers() {
            for landmark in landmarks {
                guard let coordinates = landmark.coordonneesWgs84 else { continue }
                let annotation = MKPointAnnotation()
                annotation.coordinate = CLLocationCoordinate2D(latitude: coordinates.lat ?? 0, longitude: coordinates.lon ?? 0)
                annotation.title = landmark.denominationDeLEdifice
                mapView.addAnnotation(annotation)
            }
        centerMapOnLandmarks()
        }
    func showLandmarkDetails(_ landmark: Landmark) {
            if let detailsVC = floatingPanelController.contentViewController as? MonumentDetailsViewController {
                detailsVC.selectedLandmark = landmark
                // TODO: Implement logic to update the UI in the details view controller based on the selected landmark.
                // This could include updating labels, images, or any other relevant UI elements.
            }
        }
}
// MARK: - MapView - Delegate
extension MapViewController: MKMapViewDelegate {

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            guard let annotation = annotation as? MKPointAnnotation else { return nil }
            let identifier = "LandmarkMarker"
            var annotationView: MKMarkerAnnotationView

            if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView {
                dequeuedView.annotation = annotation
                annotationView = dequeuedView
            } else {
                annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                annotationView.canShowCallout = true
                annotationView.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            }
            return annotationView
        }

    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            // Handle the tap on the callout button (show details, open new screen, etc.)
            if let monumentName = view.annotation?.title,
                let selectedLandmark = landmarks.first(where: { $0.denominationDeLEdifice == monumentName }) {
                showLandmarkDetails(selectedLandmark)
            }
        }
    }
}
// MARK: - FloatingPanel - Delegate
extension MapViewController: FloatingPanelControllerDelegate {
    func floatingPanelWillBeginDragging(_ fpc: FloatingPanelController) {
            // Handle any actions when the user starts dragging the Floating Panel
        }

}
