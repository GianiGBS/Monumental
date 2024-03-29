//
//  MapViewController.swift
//  Monumental
//
//  Created by Giovanni Gabriel on 04/12/2023.
//

import UIKit
import MapKit
import FloatingPanel

class MapViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var locationButton: UIButton!

    // MARK: - Properties
    private let searchView = SearchViewController()
    public weak var delegate: MapViewDelegate?
    private let landmarkModel = ExploreManager()
    private var locationService: CoreLocationService?
    let floatingPanelController = FloatingPanelController()
    let floatingPanelStoryboardID = "tableViewFloatingPanel"
    let modalStoryboardID = "searchFloatingPanel"
    var landmarks: [Landmark]? = []

    let defaultHeight: CGFloat = 300

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpDelegateModel()
        setupMapView()
        searchView.delegate = self
        setUpLocationService()
        
    }

    // MARK: - Action
    @IBAction func searchButtonTapped(_ sender: Any) {
        presentSearchModal()
    }
    @IBAction func showNearBy() {
        locationService?.startUpdatingLocation()
        // Get Department
        centerMapOnUserLocation(mapView: mapView)
        didRequestLandmarks(department: locationService?.currentDepartment)
    }
    @objc func directionsButtonTapped() {
        // Select Annotation
        if let selectedAnnotation = mapView.selectedAnnotations.first as? MKPointAnnotation {
            // Found monument that launch func showDirections
            if let landmark = landmarks?.first(where: { $0.denominationDeLEdifice == selectedAnnotation.title }) {
                showDirections(for: landmark)
            }
        }
    }
    // MARK: - Methods
    // MARK: SearchView
    func presentSearchModal() {
            guard let searchViewController = storyboard?.instantiateViewController(withIdentifier: modalStoryboardID)
                    as? SearchViewController else {
                return
            }
        searchViewController.delegate = self
            let navigationController = UINavigationController(rootViewController: searchViewController)

            // modal style
        navigationController.modalPresentationStyle = .overCurrentContext
            present(navigationController, animated: true, completion: nil)
        }
    // MARK: Explore
    func setUpDelegateModel() {
        landmarkModel.delegate = self
    }
    // MARK: - MapView
    // Get user location
    func setUpLocationService() {
        locationService = CoreLocationService()
        locationService?.delegate = self
        locationService?.requestLocationAuthorization()
    }
    func setupMapView() {
            mapView.delegate = self
            mapView.showsUserLocation = true
            // Set the initial region or center the map based on your requirements.
        }
    func centerMapOnUserLocation(mapView: MKMapView) {
        guard let userLocation = mapView.userLocation.location?.coordinate else {
            presentAlert(title: "Error", message: "Position non disponibles.")
            
            return
        }

        let center = CLLocationCoordinate2D(latitude: userLocation.latitude, longitude: userLocation.longitude)
        mapView.setCenter(center, animated: true)
    }
    func centerMapOnLandmark(_ landmark: Landmark) {
        guard let coordinate = landmark.coordonneesAuFormatWgs84 else {
            return
        }

        let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: coordinate.lat ?? 0,
                                                                       longitude: coordinate.lon ?? 0),
                                        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))

        mapView.setRegion(region, animated: true)
    }
    func centerMapOnLandmarks() {
        guard let monuments = landmarks, !monuments.isEmpty else {
                return
            }
        // Initiation region bounds with first landmark
            var bounds = MKCoordinateRegion()
        if let firstCoordinate = monuments.first?.coordonneesAuFormatWgs84 {
            bounds = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: firstCoordinate.lat ?? 0,
                                                                       longitude: firstCoordinate.lon ?? 0),
                                        span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))

            mapView.setRegion(bounds, animated: true)
        }
        }
    func addLandmarkMarkers(to mapView: MKMapView) {
        mapView.removeAnnotations(mapView.annotations)
        if let monuments = landmarks {
            for (index, landmark) in monuments.enumerated() {
                if let coordonates = landmark.coordonneesAuFormatWgs84,
                   let latitude = coordonates.lat,
                   let longitude = coordonates.lon {

                    let annotation = MKPointAnnotation()
                    annotation.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                    annotation.title = "\(index + 1). \(landmark.denominationDeLEdifice ?? "Non renseigné")"
                    annotation.subtitle = landmark.titreEditorialDeLaNotice

                    print("Lat: \(annotation.coordinate.latitude), Lon: \(annotation.coordinate.longitude)")
                    mapView.addAnnotation(annotation)
                }
            }
        }
    }
    func showLandmarkDetails(_ landmark: Landmark) {
            if let detailsVC = floatingPanelController.contentViewController as? MonumentDetailsViewController {
                detailsVC.selectedLandmark = landmark
                // Implement logic to update the UI in the details view controller based on the selected landmark.
                // This could include updating labels, images, or any other relevant UI elements.
            }
        }
    // MARK: - FloatingPanel
    func setUpFloatingPanel() {
        // Initialize a `FloatingPanelController` object.
        floatingPanelController.delegate = self
        let contentPanelVC = storyboard?.instantiateViewController(identifier: floatingPanelStoryboardID)
        as? ContentTableViewController
        floatingPanelController.set(contentViewController: contentPanelVC)
        floatingPanelController.addPanel(toParent: self)
        contentPanelVC?.monuments = landmarkModel.monuments
        contentPanelVC?.tableView.reloadData()
    }
}
// MARK: - MapView - Delegate
extension MapViewController: MKMapViewDelegate {

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            guard let annotation = annotation as? MKPointAnnotation else { return nil }
            let identifier = "LandmarkMarker"
            var annotationView: MKMarkerAnnotationView

            if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
                as? MKMarkerAnnotationView {
                dequeuedView.annotation = annotation
                annotationView = dequeuedView
            } else {
                annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                annotationView.canShowCallout = true
                annotationView.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            }
            return annotationView
        }

    func mapView(_ mapView: MKMapView,
                 annotationView view: MKAnnotationView,
                 calloutAccessoryControlTapped control: UIControl) {
        if let monuments = landmarks {
            if control == view.rightCalloutAccessoryView {
                // Handle the tap on the callout button (show details, open new screen, etc.)
                if let monumentName = view.annotation?.title,
                   let selectedLandmark = monuments.first(where: { $0.denominationDeLEdifice == monumentName }) {
                    showLandmarkDetails(selectedLandmark)
                }
            }
        }
    }
}

// MARK: - CoreLocationServiceDelegate
extension MapViewController: CorelocationServiceDelegate {
    func didUpdateDepartment(_ department: String) {
        didRequestLandmarks(department: department)
    }
    
    func didFailWithError(_ error: Error) {
        print("Location error \(error.localizedDescription)")
    }
}
// MARK: - FloatingPanel - Delegate
extension MapViewController: FloatingPanelControllerDelegate {
}

// MARK: - Explore - Delegate
extension MapViewController: ViewDelegate {
    func updateView() {
        landmarks = landmarkModel.monuments
        print(landmarkModel.monuments)

        if landmarks?.isEmpty ?? true {
            floatingPanelController.removePanelFromParent(animated: true)
            presentAlert(title: "Oups!", message: "Liste de recherche vide.")
        } else {
            addLandmarkMarkers(to: mapView)
            centerMapOnLandmarks()
            setUpFloatingPanel()
            floatingPanelController.move(to: .half, animated: false)
        }
    }
    func fetchDataInProgress(shown: Bool) {}
    func presentAlert(title: String, message: String) {
        // Present alert message to user
    }
}

// MARK: - MapView - Delegate
extension MapViewController: MapViewDelegate {
    func didRequestLandmarks(department: String?) {
        if let department = department {
            // fetch les monuments
            landmarkModel.fetchData(for: department)
        }
    }
    func showDirections(for landmark: Landmark?) {
            guard let monumentCoordinate = landmark?.coordonneesAuFormatWgs84 else {
                presentAlert(title: "Error", message: "Coordonnées du monument non disponibles.")
                return
            }

            let destinationPlacemark = MKPlacemark(coordinate:
                                                    CLLocationCoordinate2D(latitude: monumentCoordinate.lat ?? 0,
                                                                           longitude: monumentCoordinate.lon ?? 0))

            let mapItem = MKMapItem(placemark: destinationPlacemark)
            mapItem.name = landmark?.denominationDeLEdifice

            let options = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDefault]
            mapItem.openInMaps(launchOptions: options)
        }
    func dismissViewModal() {
        dismiss(animated: true, completion: nil)
    }
}
