//
//  AllHistoryViewController.swift
//  BluetoothScan
//
//  Created by TechUnity IOS Developer on 23/08/22.
//

import UIKit
import MapKit
class AllHistoryViewController: UIViewController, MKMapViewDelegate {
    @IBOutlet weak var DeviceMapView: MKMapView!
    @IBOutlet var PinDetailView: UIView!
    @IBOutlet weak var TagImageView: UIImageView!
    @IBOutlet weak var TagNameLable: UILabel!
    @IBOutlet weak var IdentifierLable: UILabel!
    var initialLocation : CLLocation!
    var fromDashboard = Bool()
    var currentLocation : CLLocation!
    var locationManager = CLLocationManager()
    var HistoryLocalArray = [PheripheralObj]()
    var PinCustomColor : UIColor!
    override func viewDidLoad() {
        super.viewDidLoad()
        DeviceMapView.delegate = self
        if fromDashboard{
            let noLocation = CLLocationCoordinate2D(latitude: initialLocation.coordinate.latitude, longitude: initialLocation.coordinate.longitude)
            DeviceMapView.showsUserLocation = false
            let viewRegion = MKCoordinateRegion(center: noLocation, latitudinalMeters: 300, longitudinalMeters: 300)
            DeviceMapView.setRegion(viewRegion, animated: false)
            let artwork = Artwork(title: "Techunity", locationName: "Sivananda colony", discipline: UIColor.red, coordinate: CLLocationCoordinate2D(latitude: initialLocation.coordinate.latitude, longitude: initialLocation.coordinate.longitude), TagImage: UIImage())
            DeviceMapView.addAnnotation(artwork)
        }else{
            
            
        }
        
    }
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if view.annotation is Artwork {
            let anno = view.annotation as! Artwork
            TagImageView.image = anno.TagImage
            TagNameLable.text = anno.title
            IdentifierLable.text = anno.locationName
        PinDetailView.removeFromSuperview()
        PinDetailView.frame = CGRect(x: -150, y: -110, width: 330, height: 100)
        PinDetailView.layer.borderColor = UIColor.systemTeal.cgColor
        PinDetailView.layer.borderWidth = 1
        shadowDrop(view: PinDetailView)
            shadowDrop(view: TagImageView)
            TagImageView.layer.borderColor = UIColor.systemTeal.cgColor
            TagImageView.layer.borderWidth = 1
        PinDetailView.alpha = 0
        view.addSubview(PinDetailView)
        PinDetailView.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
        UIView.animate(withDuration: 0.3) {
            self.PinDetailView.transform = .identity
            self.PinDetailView.alpha = 1
        }
        }
    }
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        if let location = locations.last{
//            let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
//            let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
//            DeviceMapView.setRegion(region, animated: true)
//        }
//    }
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        PinDetailView.removeFromSuperview()
        
    }
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        
        if annotation is MKUserLocation{
            return nil
        }
//        var pinAnnotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "DefaultPinView")
//        if pinAnnotationView == nil {
//            pinAnnotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "DefaultPinView")
//            pinAnnotationView = .orange
//        }
        let anno = annotation as! Artwork
        
        let annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "pin")

        annotationView.pinTintColor = anno.discipline

//                return annotationView
        return annotationView
        
    }
    
    func showData(Multiple_Pin:Bool, index:Int){
        print("ShowData called")
        DeviceMapView.removeAnnotations(DeviceMapView.annotations)
        HistoryLocalArray = DBcall.readHistoryTable()
        if Multiple_Pin == true
        {
            DeviceMapView.showsUserLocation = true
            if HistoryLocalArray.count>0{
                let noLocation = CLLocationCoordinate2D(latitude: HistoryLocalArray[0].Latitude, longitude: HistoryLocalArray[0].Longitude)
                let viewRegion = MKCoordinateRegion(center: noLocation, latitudinalMeters: 200, longitudinalMeters: 200)
                DeviceMapView.setRegion(viewRegion, animated: false)
                for obj in HistoryLocalArray{
                    if obj.LostAssetTag == 1
                    {
                        PinCustomColor = UIColor.red
                        let artwork = Artwork(title: obj.name, locationName: "\(obj.identifier)\n\(obj.registerDateTime)", discipline: PinCustomColor, coordinate: CLLocationCoordinate2D(latitude: obj.Latitude, longitude: obj.Longitude), TagImage: obj.TagImage)
                        
                        DeviceMapView.addAnnotation(artwork)
                        
                    }
                    else
                    {
                        PinCustomColor = UIColor.systemTeal
                        let artwork = Artwork(title: obj.name, locationName: "\(obj.identifier)\n\(obj.registerDateTime)", discipline: PinCustomColor, coordinate: CLLocationCoordinate2D(latitude: obj.Latitude, longitude: obj.Longitude), TagImage: obj.TagImage)
                        
                        DeviceMapView.addAnnotation(artwork)
                        
                    }
                }
            }
        }
        else
        {
            DeviceMapView.showsUserLocation = true
            if HistoryLocalArray.count>0{
                if HistoryLocalArray[index].LostAssetTag == 1
                {
                    PinCustomColor = UIColor.red
                }
                else
                {
                    PinCustomColor = UIColor.systemTeal
                }
                let obj = HistoryLocalArray[index]
                let noLocation = CLLocationCoordinate2D(latitude: obj.Latitude, longitude: obj.Longitude)
                let viewRegion = MKCoordinateRegion(center: noLocation, latitudinalMeters: 200, longitudinalMeters: 200)
                DeviceMapView.setRegion(viewRegion, animated: false)
                //                for obj in HistoryLocalArray{
                let artwork = Artwork(title: obj.name, locationName: obj.identifier, discipline: PinCustomColor, coordinate: CLLocationCoordinate2D(latitude: obj.Latitude, longitude: obj.Longitude), TagImage: obj.TagImage)
                DeviceMapView.addAnnotation(artwork)
                //                }
            }
        }
    }
    
}
extension ViewController: MKMapViewDelegate {
    // 1
    func mapView(
        _ mapView: MKMapView,
        viewFor annotation: MKAnnotation
    ) -> MKAnnotationView? {
        // 2
        guard let annotation = annotation as? Artwork else {
            return nil
        }
        // 3
        let identifier = "artwork"
        var view: MKMarkerAnnotationView
        // 4
        if let dequeuedView = mapView.dequeueReusableAnnotationView(
            withIdentifier: identifier) as? MKMarkerAnnotationView {
            dequeuedView.annotation = annotation
            view = dequeuedView
        } else {
            // 5
            view = MKMarkerAnnotationView(
                annotation: annotation,
                reuseIdentifier: identifier)
            view.canShowCallout = true
            view.calloutOffset = CGPoint(x: -5, y: 5)
            view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        return view
    }
}


private extension MKMapView {
    func centerToLocation(
        _ location: CLLocation,
        regionRadius: CLLocationDistance = 1000
    ) {
        let coordinateRegion = MKCoordinateRegion(
            center: location.coordinate,
            latitudinalMeters: regionRadius,
            longitudinalMeters: regionRadius)
        setRegion(coordinateRegion, animated: true)
    }
}

class Artwork: NSObject, MKAnnotation {
    let title: String?
    let locationName: String?
    let discipline: UIColor?
    let coordinate: CLLocationCoordinate2D
    let TagImage: UIImage?
    init(
        title: String?,
        locationName: String?,
        discipline: UIColor?,
        coordinate: CLLocationCoordinate2D,
        TagImage: UIImage?
    ) {
        self.title = title
        self.locationName = locationName
        self.discipline = discipline
        self.coordinate = coordinate
        self.TagImage = TagImage
        super.init()
    }
    
    var subtitle: String? {
        return locationName
    }
}

