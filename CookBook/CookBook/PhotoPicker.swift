//
//  PhotoPicker.swift
//  CookBook
//
//  Created by Gupta, Rishi on 4/30/22.
//

import Foundation
import UIKit


class PhotoPicker : NSObject {
    private weak var presentationViewController: UIViewController?
    private var callback: ((UIImage) -> Void)?
    
    init(presentationViewController: UIViewController) {
        super.init()
        self.presentationViewController = presentationViewController
    }
    func presentCamera(with callback: @escaping (UIImage) -> Void) {
        if !UIImagePickerController.isSourceTypeAvailable(.camera) {
            let alertController = UIAlertController(title: nil, message: "Device has no camera.", preferredStyle: .alert)

            let okAction = UIAlertAction(title: "Alright", style: .default, handler: { (alert: UIAlertAction!) in
            })

            alertController.addAction(okAction)
            if let presentationViewController = presentationViewController {
                presentationViewController.present(alertController, animated: true, completion: nil)
            }
            
        }
        else{
            let cameraVC = UIImagePickerController()
            cameraVC.sourceType = .camera
            cameraVC.allowsEditing = true
            cameraVC.delegate = self
            self.callback = callback
            if let presentationViewController = presentationViewController {
                presentationViewController.present(cameraVC, animated: true)
            }
        }
        }
        
        
}

extension PhotoPicker: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else {
            print("failed to get image")
            return
        }
        print(image.pngData() ?? "DIDNT WORK")
        callback?(image)
    }
}
