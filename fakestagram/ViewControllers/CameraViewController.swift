//
//  CameraViewController.swift
//  fakestagram
//
//  Created by LuisE on 10/19/19.
//  Copyright © 2019 3zcurdia. All rights reserved.
//

import UIKit
import CoreLocation
import AVFoundation

class CameraViewController: UIViewController {
    
    @IBOutlet weak var MLDescriptionBackgroundView: UIView! {
        didSet {
            MLDescriptionBackgroundView.layer.cornerRadius = 4.0
            MLDescriptionBackgroundView.isHidden = true
        }
    }
    @IBOutlet weak var MLDescriptionLabel: UILabel!
    
    let model = MobileNet()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        enableBasicLocationServices()
        enableCameraAccess()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        locationManager.startUpdatingLocation()
    }

    override func viewWillDisappear(_ animated: Bool) {
        locationManager.stopUpdatingLocation()
        super.viewWillDisappear(animated)
    }

    let service = CreatePostService()
    @IBAction func onTapCreate(_ sender: Any) {
        print("📸")
        let settings: AVCapturePhotoSettings
        print(self.photoOutput.availablePhotoCodecTypes)
        if self.photoOutput.availablePhotoCodecTypes.contains(.hevc) {
            settings = AVCapturePhotoSettings(format:
                [AVVideoCodecKey: AVVideoCodecType.hevc])
        } else {
            settings = AVCapturePhotoSettings()
        }
        settings.flashMode = .auto
        photoOutput.capturePhoto(with: settings, delegate: self)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: - CoreLocation methods
    let locationManager = CLLocationManager()
    func enableBasicLocationServices() {
        locationManager.delegate = self
        switch CLLocationManager.authorizationStatus() {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted, .denied:
            print("Disable location features")
        case .authorizedWhenInUse, .authorizedAlways:
            print("Enable location features")
        @unknown default:
            fatalError()
        }
    }

    // MARK: - AVFoundation methods

    @IBOutlet weak var previewView: PreviewView!
    func enableCameraAccess() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
            case .authorized:
                // The user has previously granted access to the camera.
                self.setupCaptureSession()
            case .notDetermined:
                // The user has not yet been asked for camera access.
                AVCaptureDevice.requestAccess(for: .video) { granted in
                    if granted {
                        self.setupCaptureSession()
                    }
                }
            case .denied:
                // The user has previously denied access.
                return
            case .restricted:
                // The user can't grant access due to restrictions.
                return
        @unknown default:
            fatalError()
        }
    }

    let session = AVCaptureSession()
    let photoOutput = AVCapturePhotoOutput()

    func setupCaptureSession() {
        session.beginConfiguration()
        let device = AVCaptureDevice.default(.builtInDualCamera,
                                                 for: .video, position: .back)!
        guard let videoDeviceInput = try? AVCaptureDeviceInput(device: device),
            session.canAddInput(videoDeviceInput) else { return }
        session.addInput(videoDeviceInput)

        guard session.canAddOutput(photoOutput) else { return }
        session.sessionPreset = .photo
        session.addOutput(photoOutput)

        session.commitConfiguration()
        previewView.session = session

        session.startRunning()
    }

}

extension CameraViewController: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        debugPrint(photo.metadata)

        guard let data = photo.fileDataRepresentation(), let img = UIImage(data: data) else { return }
        
        
        
        service.call(image: img, title: UUID().uuidString) { postId in
            print("Successful!")
            print(postId ?? -1)
        }
    }
}

extension CameraViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        service.update(coordinate: location.coordinate)
    }
}



// MARK: Machine Learning Stuff

extension CameraViewController {
    typealias Prediction = (String, Double)
    
    func predictUsingCoreML(image: UIImage) -> String? {
      if let pixelBuffer = image.pixelBuffer(width: 224, height: 224),
         let prediction = try? model.prediction(data: pixelBuffer) {
         
        let top5 = top(5, prediction.prob)
        
        if let highestPrediction = top5.first {
            let accuracy = String(format: "%.2f", highestPrediction.1 * 100)
            let prediction = highestPrediction.0.split(separator: " ")[1]
            return "I think this is a: \(prediction) --> \(accuracy)%"
        }
        else {
            return nil
        }
        
      }
        
        return nil
    }
    
    func top(_ k: Int, _ prob: [String: Double]) -> [Prediction] {
      precondition(k <= prob.count)

      return Array(prob.map { x in (x.key, x.value) }
                       .sorted(by: { a, b -> Bool in a.1 > b.1 })
                       .prefix(through: k - 1))
    }
}



// MARK: Alert Stuff

extension CameraViewController {
    func sendAlertWithMessage(_ message: String){
        let alert = UIAlertController(title: "Fakestagram", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(action)
        
        DispatchQueue.main.async {
            self.present(alert, animated: true)
        }
        
        
    }
}
