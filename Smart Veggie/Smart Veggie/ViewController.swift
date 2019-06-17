//
//  ViewController.swift
//  Smart Veggie
//
//  Created by lttc on 13/6/2019.
//  Copyright © 2019 Team B. All rights reserved.
//

import UIKit
import CoreML

class ViewController: UIViewController, UINavigationControllerDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var result: UILabel!
    var model: MobileNetV2!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //setup view
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //create instance of the machine learning model
    override func viewWillAppear(_ animated: Bool) {
        self.model = MobileNetV2()
    }
    
    //when click camera
    @IBAction func camera(_ sender: Any) {
        if !UIImagePickerController.isSourceTypeAvailable(.camera) {
            return
        }
        
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .camera
        picker.allowsEditing = false
        present(picker, animated: true)
    }
    
    //when click button "Album"
    @IBAction func album(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = false
        picker.sourceType = .photoLibrary
        present(picker, animated: true)
    }
    
    //when click button "Analyze"
    @IBAction func analyze(_ sender: Any) {
        if let target = imageView?.image {
//            result.text = predict(image: target)
            if let output = predict(image: target) {
//                print(objects.count)
//                print(objects.dataType)
//                readMLArray(array: output)
                result.text = output
            }
        }
    }
    
    @IBAction func addMaterialToList(_ sender: Any) {
        if let material = result.text {
            RecipeManager.addMaterial(name: material, quan: 100)
        }
    }
    
    func readMLArray(array: MLMultiArray) -> String? {
        let result: String? = ""
//        let pointer = UnsafeMutablePointer<Double>(OpaquePointer(array.dataPointer))
//        let offset = 1 * array.strides[0].intValue + 1 * array.strides[1].intValue + 1 * array.strides[2].intValue
//        let value = pointer[offset]
        return result
    }
    
    //make prediction
    func predict(image: UIImage) -> String? {
        if let scaledImage = image.resizeImage(size: CGSize(width: 224, height: 224)) { //resize image to certain dimension
            print("image resized \(scaledImage.size.width), \(scaledImage.size.height)") //print resized image information
            if let pixelBuffer = ImageProcessor.generatePixelBuffer(source: scaledImage.cgImage!) {
                guard let output = try? self.model.prediction(image: pixelBuffer) else { fatalError("Unexpected runtime error") }
                return output.classLabel
            }
        }
        return nil
    }

}

extension ViewController: UIImagePickerControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        picker.dismiss(animated: true)
        result.text = "Let me think..."
        guard let image = info["UIImagePickerControllerOriginalImage"] as? UIImage else {
            return
        }
        imageView.image = image
    }
}

extension UIImage {
    func resizeImage(size: CGSize) -> UIImage? {
        UIGraphicsBeginImageContext(size);
        self.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        if let resizedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext() {
            UIGraphicsEndImageContext()
            return resizedImage
        }
        return nil
    }
    
    func scaleImage(rate: CGFloat) -> UIImage? {
        let scale = CGSize(width: self.size.width * rate, height: self.size.height * rate)
        return resizeImage(size: scale)
    }
}

