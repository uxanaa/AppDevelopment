//
//  MapViewController.swift
//  New Brighton Murals
//
//  Created by Uxanaa Shashitharen on 26/11/2022.
//

import UIKit
import MapKit
import CoreLocation


class MapViewController: UIViewController {

    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var mapView: MKMapView!
    
    private var murals = [Mural]()
    private let image = UIImage(systemName: "star.fill")!
    private let locationManager = CLLocationManager()

    var firstRun = true
    var startTrackingTheUser = false
    
    // MARK: saves favourite murals using UserDefaults
    private var favoriteMurals: [String] {
        get {
            return UserDefaults.standard.object(forKey: "favoriteMurals") as? [String] ?? []
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "favoriteMurals")
            UserDefaults.standard.synchronize()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTableView()
        setUpMapView()
        dowloadMurals()
    }
    
    // MARK: - prepare for segue from map view to detail view when user clicks on an annotation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard
            let annotation = mapView.selectedAnnotations.first,
            let muralAnnotation = annotation as? MuralAnnotation,
            let mural = murals.first(where: { mural in
                mural.id == muralAnnotation.id
            }),
            let detailViewController = segue.destination as? DetailViewController
        else { return }
        detailViewController.mural = mural
        super.prepare(for: segue, sender: sender)
    }
    
    // MARK: - get table view data
    func setUpTableView() {
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    // MARK: - Phils code
    func setUpMapView() {
        // Make this view controller a delegate of the Location Manager, so that it
        //is able to call functions provided in this view controller.
        locationManager.delegate = self as CLLocationManagerDelegate
        
        //set the level of accuracy for the user's location.
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        
        //Ask the location manager to request authorisation from the user. Note that this
        //only happens once if the user selects the "when in use" option. If the user
        //denies access, then your app will not be provided with details of the user's
        //location.
        locationManager.requestWhenInUseAuthorization()
        
        //Once the user's location is being provided then ask for udpates when the user
        //moves around.
        locationManager.startUpdatingLocation()
        
        //configure the map to show the user's location (with a blue dot).
        mapView.showsUserLocation = true
        
        //
        mapView.delegate = self
        DispatchQueue.global(qos: .background).async {
            if CLLocationManager.locationServicesEnabled() {
                self.locationManager.startUpdatingLocation()
            }
        }
    }
    
 
    private func dowloadMurals() {
        let urlText = "https://cgi.csc.liv.ac.uk/~phil/Teaching/COMP228/nbm/data2.php?class=newbrighton_murals"
        guard let url = URL(string: urlText) else { return }
        URLSession.shared.dataTask(with: url) { (data, response, error) -> Void in
            guard
                let data = data,
                error == nil,
                let muralParse = try? JSONDecoder().decode(
                    newbrightonMuralsParser.self,
                    from: data)
            else { return }
            self.murals = muralParse.newbrightonMurals
            self.updateUI()
        }.resume()
    }
    
    // MARK: - update the table view to show the order of the closest murals to the user as they walk through New Brighton
    private func updateUI() {
        DispatchQueue.main.async { [self] in
            if let coordinate = locationManager.location?.coordinate {
                murals = murals.sorted(by: { firstMural, secondMural in
                    guard
                        let firstDistance = firstMural.coordinate?.distance(from: CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)),
                        let secondDistance = secondMural.coordinate?.distance(from: CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude))
                    else { return false }
                    return firstDistance < secondDistance
                })
            }
            updateTableView()
            updateMap()
        }
    }
    
    private func updateTableView() {
        tableView.reloadData()
    }
    
    
    private func updateMap() {
        let annotaions = murals.compactMap { mural in
            MuralAnnotation(mural: mural)
        }
        mapView.addAnnotations(annotaions)
    }
    
}


extension MapViewController: MKMapViewDelegate {
    // MARK: segue from map view to detail view when user clicks on an annotation
    func mapView(_ mapView: MKMapView, didSelect annotation: MKAnnotation) {
        performSegue(withIdentifier: "showDetails", sender: nil)
    }
    
}


// MARK: - Phil's code
extension MapViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locationOfUser = locations[0] //this method returns an array of locations
        //generally we always want the first one (usually there's only 1 anyway)
        
        let latitude = locationOfUser.coordinate.latitude
        let longitude = locationOfUser.coordinate.longitude
        //get the users location (latitude & longitude)
        let location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        
        if firstRun {
            firstRun = false
            let latDelta: CLLocationDegrees = 0.0025
            let lonDelta: CLLocationDegrees = 0.0025
            //a span defines how large an area is depicted on the map.
            let span = MKCoordinateSpan(latitudeDelta: latDelta, longitudeDelta: lonDelta)
            
            //a region defines a centre and a size of area covered.
            let region = MKCoordinateRegion(center: location, span: span)
            
            //make the map show that region we just defined.
            self.mapView.setRegion(region, animated: true)
            
            //the following code is to prevent a bug which affects the zooming of the map to the user's location.
            //We have to leave a little time after our initial setting of the map's location and span,
            //before we can start centering on the user's location, otherwise the map never zooms in because the
            //intial zoom level and span are applied to the setCenter( ) method call, rather than our "requested" ones,
            //once they have taken effect on the map.
            
            //we setup a timer to set our boolean to true in 5 seconds.
            _ = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(startUserTracking), userInfo: nil, repeats: false)
        }
        
        if startTrackingTheUser == true {
            mapView.setCenter(location, animated: true)
        }
    }
    
    //this method sets the startTrackingTheUser boolean class property to true. Once it's true, subsequent calls
    //to didUpdateLocations will cause the map to center on the user's location.
    @objc func startUserTracking() {
        startTrackingTheUser = true
        
    }
    
}


extension MapViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return murals.count
    }
    
    // MARK: - This method defines what each cell inside the tableview will look like, it will contain a title, artist and image
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //read objects
        let cell = tableView.dequeueReusableCell(withIdentifier: "mural_location_cell", for: indexPath)
        let mural = murals[indexPath.row]
        
        //modify
        cell.textLabel?.text = mural.title
        cell.detailTextLabel?.text = mural.artist
        
        if case .downloaded(let image) = mural.thumbnailImage {
            cell.imageView?.image = image
        } else if case .initiated = mural.thumbnailImage {
            if let url = mural.thumbnailUrl {
                url.downloadImage { image in
                    guard let image = image else {
                        mural.thumbnailImage = .empty
                        return
                    }
                    mural.thumbnailImage = .downloaded(image: image)
                    tableView.reloadRows(at: [indexPath], with: .automatic)
                }
            }
            cell.imageView?.image = nil
        } else {
            cell.imageView?.image = nil
        }
        let isFavorite = favoriteMurals.contains(mural.id)
        cell.accessoryView = isFavorite ? UIImageView(image: image) : nil
        //return
        return cell
    }
    
}


extension MapViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        60
    }
    
    // MARK: - when user selects a cell it will be favourited and a star will appear on that cell and remove the star if user selects it again
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let muralID = murals[indexPath.row].id
        var favoriteMurals = self.favoriteMurals
        if favoriteMurals.contains(muralID) {
            favoriteMurals.removeAll(where: { $0 == muralID })
        } else {
            favoriteMurals.append(muralID)
        }
        self.favoriteMurals = favoriteMurals
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }

}
