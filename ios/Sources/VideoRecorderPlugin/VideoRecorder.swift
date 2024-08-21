import Foundation
import Capacitor
import AVFoundation
import MobileCoreServices

@objc(VideoRecorderPlugin)
public class VideoRecorderPlugin: CAPPlugin, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var call: CAPPluginCall?

    @objc func recordVideo(_ call: CAPPluginCall) {
        self.call = call
        DispatchQueue.main.async {
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                let videoPicker = UIImagePickerController()
                videoPicker.delegate = self
                videoPicker.sourceType = .camera
                videoPicker.mediaTypes = [kUTTypeMovie as String]
                self.bridge?.viewController?.present(videoPicker, animated: true, completion: nil)
            } else {
                call.reject("Camera not available")
            }
        }
    }

    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        if let videoURL = info[UIImagePickerController.InfoKey.mediaURL] as? URL {
            call?.resolve(["videoUrl": videoURL.absoluteString])
        } else {
            call?.reject("Failed to capture video")
        }
    }

    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
        call?.reject("User cancelled video recording")
    }
}
