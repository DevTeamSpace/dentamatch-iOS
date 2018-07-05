//
//  PhotoGalleryManager.swift
//  DentaMatch
//
//  Created by Rajan Maheshwari on 13/12/16.
//  Copyright © 2016 Appster. All rights reserved.
//

import AVFoundation
import Photos
import UIKit

class CameraGalleryManager: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    private var presentedFromController: UIViewController?
    private var allowsEditing = false

    private enum CameraError: String {
        case denied = "Camera permissions are turned off. Please turn it on in Settings"
        case restricted = "Camera permissions are restricted"
        case notDetermined = "Camera permissions are not determined yet"
        case unavailable = "Camera not available"
    }

    private enum GalleryError: String {
        case denied = "Photo Gallery permissions are turned off. Please turn it on in Settings"
        case restricted = "Photo Gallery permissions are restricted"
        case notDetermined = "Photo Gallery permissions are not determined yet"
    }

    typealias ImagePickedClosure = (_ image: UIImage?, _ error: NSError?) -> Void
    private var completionHandler: ImagePickedClosure?

    private let imagePicker = UIImagePickerController()

    // MARK: - Singleton Instance

    static let shared = CameraGalleryManager()

    // MARK: - View LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Permissions

    /// Checks the Permission for Photo Gallery
    ///
    /// - Parameter completionHandler: Accepts a closure of a success bool variable which is sent back as a completon handler
    ///   - success: Bool
    private func checkGalleryPermission(_ completionHandler: @escaping (_ success: Bool) -> Void) {
        PHPhotoLibrary.requestAuthorization({ (status: PHAuthorizationStatus) in
            if status == .authorized {
                completionHandler(true)
            } else if status == .denied {
                completionHandler(false)
            } else {
                completionHandler(false)
            }
        })
    }

    /// Checks the Permission for Camera
    ///
    /// - Parameter completionHandler: Accepts a closure of a success bool variable which is sent back as a completon handler
    /// - success: Bool
    private func checkCameraPermission(_ completionHandler: @escaping (_ success: Bool) -> Void) {
        if AVCaptureDevice.authorizationStatus(for: AVMediaType.video) == AVAuthorizationStatus.authorized {
            // Already Authorized
            completionHandler(true)
        } else {
            AVCaptureDevice.requestAccess(for: AVMediaType.video, completionHandler: { (granted: Bool) -> Void in
                if granted == true {
                    // User granted
                    OperationQueue.main.addOperation({
                        completionHandler(true)
                    })
                } else {
                    // User Rejected
                    completionHandler(false)
                    // debugPrint("No permission")
                }
            })
        }
    }

    // MARK: - Opening Gallery and Camera

    /// Presents Photo Gallery on the current view
    ///
    /// - Parameters:
    ///   - viewController: Current ViewController from where the gallery is presenting. Generally self.
    ///   - allowsEditing: bool which allows whether the photo can be edited after picking or not.
    ///   - completionHandler: returns the UIImage object and NSError in case of error
    func openGallery(viewController: UIViewController, allowsEditing: Bool, completionHandler: @escaping ImagePickedClosure) {
        self.completionHandler = completionHandler
        presentedFromController = viewController
        self.allowsEditing = allowsEditing
        checkGalleryPermission { success in
            if success {
                self.imagePicker.delegate = self
                self.imagePicker.allowsEditing = allowsEditing
                self.imagePicker.sourceType = .photoLibrary
                OperationQueue.main.addOperation({
                    viewController.present(self.imagePicker, animated: true, completion: nil)
                })
            } else {
                self.completionHandler?(nil, NSError(domain: "", code: PHPhotoLibrary.authorizationStatus().rawValue, userInfo:
                    [
                        NSLocalizedDescriptionKey: GalleryError.denied.rawValue,
                        NSLocalizedFailureReasonErrorKey: GalleryError.denied.rawValue,
                        NSLocalizedRecoverySuggestionErrorKey: GalleryError.denied.rawValue,
                ]))
            }
        }
    }

    /// Presents Camera on the current view
    ///
    /// - Parameters:
    ///   - viewController: Current ViewController from where the camera is presenting. Generally self.
    ///   - allowsEditing: bool which allows whether the photo can be edited after picking or not.
    ///   - completionHandler: returns the UIImage object and NSError in case of error
    func openCamera(viewController: UIViewController, allowsEditing: Bool, completionHandler: @escaping ImagePickedClosure) {
        self.completionHandler = completionHandler
        self.allowsEditing = allowsEditing

        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            presentedFromController = viewController

            checkCameraPermission { success in
                if success {
                    self.imagePicker.allowsEditing = allowsEditing
                    self.imagePicker.sourceType = .camera
                    self.imagePicker.delegate = self
                    OperationQueue.main.addOperation({
                        self.presentedFromController?.present(self.imagePicker, animated: true, completion: nil)
                    })
                } else {
                    self.completionHandler?(nil, NSError(domain: "", code: AVAuthorizationStatus.denied.rawValue,
                                                         userInfo: [
                                                             NSLocalizedDescriptionKey: CameraError.denied.rawValue,
                                                             NSLocalizedFailureReasonErrorKey: CameraError.denied.rawValue,
                                                             NSLocalizedRecoverySuggestionErrorKey: CameraError.denied.rawValue,
                    ]))
                }
            }
        } else {
            self.completionHandler?(nil, NSError(domain: "", code: 500,
                                                 userInfo: [
                                                     NSLocalizedDescriptionKey: CameraError.unavailable.rawValue,
                                                     NSLocalizedFailureReasonErrorKey: CameraError.unavailable.rawValue,
                                                     NSLocalizedRecoverySuggestionErrorKey: CameraError.unavailable.rawValue,
            ]))
        }
    }

    // MARK: - ImagePicker Delegates

    func imagePickerController(_: UIImagePickerController, didFinishPickingMediaWithInfo info: [String: Any]) {
        if allowsEditing {
            if let pickedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
                var image = pickedImage
                image = image.rotateImageWithScaling()
                completionHandler?(image, nil)
            }

        } else {
            if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
                var image = pickedImage
                image = image.rotateImageWithScaling()
                completionHandler?(image, nil)
            }
        }
        presentedFromController?.dismiss(animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_: UIImagePickerController) {
        presentedFromController?.dismiss(animated: true, completion: nil)
    }
}
