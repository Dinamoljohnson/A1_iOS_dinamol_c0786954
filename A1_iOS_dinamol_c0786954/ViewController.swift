//
//  ViewController.swift
//  A1_iOS_dinamol_c0786954
//
//  Created by MacStudent on 2021-05-16.
//  Copyright © 2021 MacStudent. All rights reserved.
import MapKit
import UIKit

class ViewController: UIViewController , MKMapViewDelegate, CLLocationManagerDelegate{
    @IBOutlet var mapView: MKMapView!
    @IBOutlet weak var btnNavigation: UIButton!
    var count = 0 // variable to keep count for long press touch markers
    var TouchLocation = [String:CLLocationCoordinate2D]()
    
    
    let manager = CLLocationManager()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        manager.desiredAccuracy = kCLLocationAccuracyBest //define the accuracy of location
        manager.delegate = self
        manager.requestWhenInUseAuthorization() //permission to access the location
        manager.startUpdatingLocation() //for updating the location
        
        let longpressgesture = UILongPressGestureRecognizer(target: self, action: #selector(dropMarkerOnPressLocation))
        mapView.addGestureRecognizer(longpressgesture)
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            manager.stopUpdatingLocation()
            
        render(location)
        }
        }

    func render(_ location:CLLocation) {
        let coordinate = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        let  region = MKCoordinateRegion(center: coordinate, span: span)
        
        mapView.setRegion(region,animated: true)
    }
    
    
    
        
        //func to add lonpressgesture
    @objc func  dropMarkerOnPressLocation(gestureRecognizer: UIGestureRecognizer){
        let touchPoint = gestureRecognizer.location(in: mapView)
        let coordinate = mapView.convert(touchPoint, toCoordinateFrom: mapView)
        func drawTrianglePolygon(coordinates: [CLLocationCoordinate2D]) {
            let polygon = MKPolygon(coordinates: coordinates, count: coordinates.count)
            mapView.addOverlay(polygon)
            
        }
        // draw polygon on third marker
        if(TouchLocation.count==3) {
            btnNavigation.isHidden = false
            let values = TouchLocation.values
            var coordinates = [CLLocationCoordinate2D]()
            for value in values{
                coordinates.append(value)
            }
            coordinates.append(coordinates[0])
            drawTrianglePolygon(coordinates: coordinates)
            
            
        }
        count += 1
        switch count {
        case 1:
            // add annotation
            let annotation = MKPointAnnotation()
            annotation.title = "A"
            annotation.coordinate = coordinate
            mapView.addAnnotation(annotation)
        case 2:
            let annotation = MKPointAnnotation()
            annotation.title = "B"
            annotation.coordinate = coordinate
            mapView.addAnnotation(annotation)
        case 3:
            let annotation = MKPointAnnotation()
            annotation.title = "c"
            annotation.coordinate = coordinate
            mapView.addAnnotation(annotation)
            
        default:
            break
            }



//mark: remove pin from map
        func removePin() {
            for _ in mapView.annotations {
                mapView.removeAnnotations(mapView.annotations)
            }
        }
   
}
}
