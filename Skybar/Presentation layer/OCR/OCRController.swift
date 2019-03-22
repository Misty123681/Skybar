//
//  OCRController.swift
//  Skybar
//
//  Created by Christopher Nassar on 9/29/18.
//  Copyright © 2018 Christopher Nassar. All rights reserved.
//

import UIKit
import CoreML
//import Vision
//import GoogleMobileVision

class OCRController: ParentController {
//    @IBOutlet weak var landingBG: UIImageView!
//    var session = AVCaptureSession()
//    var requests = [VNRequest]()
//
//    @IBOutlet weak var viewPlace: UIView!
//    @IBOutlet weak var loader: UIActivityIndicatorView!
//    @IBOutlet weak var congratsView: UIView!
//    var textDetector:GMVDetector!
//    var key:String!
//
//    @IBOutlet weak var captureBtn: UIButton!
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        textDetector = GMVDetector.init(ofType: GMVDetectorTypeText, options: nil)
//        startLiveVideo()
//        startTextDetection()
//    }
//
//    override func viewWillAppear(_ animated: Bool) {
//
//    }
//
//    @IBAction func captureBtn(_ sender: Any) {
//        if let key = self.key{
//        self.loader.startAnimating()
//            ServiceInterface.activateSkyKey(key: key) { (success, result) in
//
//            }
//        }
//    }
//
//    @IBAction func popController(_ sender: Any) {
//        self.navigationController?.popViewController(animated: true)
//    }
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }
//
//    func startLiveVideo() {
//        //1
//        self.view.layoutIfNeeded()
//        session.sessionPreset = AVCaptureSession.Preset.photo
//        guard let captureDevice = AVCaptureDevice.default(for: AVMediaType.video) else{
//            print("No device")
//            return
//        }
//
//        //2
//        if let deviceInput = try? AVCaptureDeviceInput(device: captureDevice){
//            let deviceOutput = AVCaptureVideoDataOutput()
//            deviceOutput.videoSettings = [kCVPixelBufferPixelFormatTypeKey as String: Int(kCVPixelFormatType_32BGRA)]
//            deviceOutput.setSampleBufferDelegate(self, queue: DispatchQueue.global(qos: DispatchQoS.QoSClass.default))
//            session.addInput(deviceInput)
//            session.addOutput(deviceOutput)
//
//            //3
//            let imageLayer = AVCaptureVideoPreviewLayer(session: session)
//            imageLayer.videoGravity = .resizeAspectFill
//            imageLayer.frame = self.landingBG.bounds
//            imageLayer.backgroundColor = UIColor.blue.cgColor
//            viewPlace.layer.addSublayer(imageLayer)
//
//            session.startRunning()
//        }
//    }
//
//    func imageFromSampleBuffer(sampleBuffer : CMSampleBuffer) -> UIImage
//    {
//        // Get a CMSampleBuffer's Core Video image buffer for the media data
//        let  imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
//        // Lock the base address of the pixel buffer
//        CVPixelBufferLockBaseAddress(imageBuffer!, CVPixelBufferLockFlags.readOnly);
//
//
//        // Get the number of bytes per row for the pixel buffer
//        let baseAddress = CVPixelBufferGetBaseAddress(imageBuffer!);
//
//        // Get the number of bytes per row for the pixel buffer
//        let bytesPerRow = CVPixelBufferGetBytesPerRow(imageBuffer!);
//        // Get the pixel buffer width and height
//        let width = CVPixelBufferGetWidth(imageBuffer!);
//        let height = CVPixelBufferGetHeight(imageBuffer!);
//
//        // Create a device-dependent RGB color space
//        let colorSpace = CGColorSpaceCreateDeviceRGB();
//
//        // Create a bitmap graphics context with the sample buffer data
//        var bitmapInfo: UInt32 = CGBitmapInfo.byteOrder32Little.rawValue
//        bitmapInfo |= CGImageAlphaInfo.premultipliedFirst.rawValue & CGBitmapInfo.alphaInfoMask.rawValue
//        //let bitmapInfo: UInt32 = CGBitmapInfo.alphaInfoMask.rawValue
//        let context = CGContext.init(data: baseAddress, width: width, height: height, bitsPerComponent: 8, bytesPerRow: bytesPerRow, space: colorSpace, bitmapInfo: bitmapInfo)
//        // Create a Quartz image from the pixel data in the bitmap graphics context
//        let quartzImage = context?.makeImage();
//        // Unlock the pixel buffer
//        CVPixelBufferUnlockBaseAddress(imageBuffer!, CVPixelBufferLockFlags.readOnly);
//
//        // Create an image object from the Quartz image
//        let image = UIImage.init(cgImage: quartzImage!);
//
//        return (image);
//    }
//
//    func printWords(sampleBuffer:CMSampleBuffer){
//        let image = imageFromSampleBuffer(sampleBuffer: sampleBuffer)
//        let features = textDetector.features(in: image, options: nil)!
//        for textBlock in features {
//            print(textBlock)
//            if let textBlock = textBlock as? GMVTextBlockFeature{
//                for textLine in textBlock.lines {
//                    // For each line, iterate over each word.
//                    for textElement in textLine.elements {
//                        if let value = textElement.value{
//                            print("value: \(textElement.value!)")
//                            self.key = value
//                        }
//                    }
//                }
//            }
//        }
//    }
//    override func viewDidLayoutSubviews() {
//        viewPlace.layer.sublayers?[0].frame = viewPlace.bounds
//    }
//
//    func startTextDetection() {
//        let textRequest = VNDetectTextRectanglesRequest(completionHandler: self.detectTextHandler)
//        textRequest.reportCharacterBoxes = true
//        self.requests = [textRequest]
//    }
//
//    func detectTextHandler(request: VNRequest, error: Error?) {
//        guard let observations = request.results else {
//            print("no result")
//            return
//        }
//
//        let result = observations.map({$0 as? VNTextObservation})
//
//        DispatchQueue.main.async() {
//            self.viewPlace.layer.sublayers?.removeSubrange(1...)
//            for region in result {
//                guard let rg = region else {
//                    continue
//                }
//
//                self.highlightWord(box: rg)
//
////                if let boxes = region?.characterBoxes {
////                    for characterBox in boxes {
////                        self.highlightLetters(box: characterBox)
////                    }
////                }
//            }
//        }
//    }
//
//    func highlightWord(box: VNTextObservation) {
//        guard let boxes = box.characterBoxes else {
//            return
//        }
//
//        var maxX: CGFloat = 9999.0
//        var minX: CGFloat = 0.0
//        var maxY: CGFloat = 9999.0
//        var minY: CGFloat = 0.0
//
//        for char in boxes {
//            if char.bottomLeft.x < maxX {
//                maxX = char.bottomLeft.x
//            }
//            if char.bottomRight.x > minX {
//                minX = char.bottomRight.x
//            }
//            if char.bottomRight.y < maxY {
//                maxY = char.bottomRight.y
//            }
//            if char.topRight.y > minY {
//                minY = char.topRight.y
//            }
//        }
//
//        let xCord = maxX * viewPlace.frame.size.width
//        let yCord = (1 - minY) * viewPlace.frame.size.height
//        let width = (minX - maxX) * viewPlace.frame.size.width
//        let height = (minY - maxY) * viewPlace.frame.size.height
//
//        let outline = CALayer()
//        outline.frame = CGRect(x: xCord, y: yCord, width: width, height: height)
//        outline.borderWidth = 2.0
//        outline.borderColor = UIColor.red.cgColor
//
//        viewPlace.layer.addSublayer(outline)
//    }
//
//    func highlightLetters(box: VNRectangleObservation) {
//        let xCord = box.topLeft.x * viewPlace.frame.size.width
//        let yCord = (1 - box.topLeft.y) * viewPlace.frame.size.height
//        let width = (box.topRight.x - box.bottomLeft.x) * viewPlace.frame.size.width
//        let height = (box.topLeft.y - box.bottomLeft.y) * viewPlace.frame.size.height
//
//        let outline = CALayer()
//        outline.frame = CGRect(x: xCord, y: yCord, width: width, height: height)
//        outline.borderWidth = 1.0
//        outline.borderColor = UIColor.blue.cgColor
//
//        viewPlace.layer.addSublayer(outline)
//    }
//}
//
//extension OCRController: AVCaptureVideoDataOutputSampleBufferDelegate {
//    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
//        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
//            return
//        }
//
//        printWords(sampleBuffer:sampleBuffer)
//        var requestOptions:[VNImageOption : Any] = [:]
//
//        if let camData = CMGetAttachment(sampleBuffer, kCMSampleBufferAttachmentKey_CameraIntrinsicMatrix, nil) {
//            requestOptions = [.cameraIntrinsics:camData]
//        }
//
//        let imageRequestHandler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, orientation: CGImagePropertyOrientation(rawValue: 6)!, options: requestOptions)
//
//        do {
//            try imageRequestHandler.perform(self.requests)
//        } catch {
//            print(error)
//        }
//    }
}
