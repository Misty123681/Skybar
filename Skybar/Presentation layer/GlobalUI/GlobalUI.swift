//
//  GlobalUI.swift
//  Skybar
//
//  Created by Christopher Nassar on 7/29/18.
//  Copyright © 2018 Christopher Nassar. All rights reserved.
//

import UIKit
public typealias ImageHandler = (_ success:Bool,_ data:Data?) -> Void

class GlobalUI: NSObject {
    
    static var loadingView:UIView!
    static var loadingIndicator:UIActivityIndicatorView!
    static var cachedImages = [String:Data]()
    
    static func gradientImage(size: CGSize, color1: CIColor, color2: CIColor) -> UIImage? {
        
        let context = CIContext(options: nil)
        let filter = CIFilter(name: "CILinearGradient")
        var startVector: CIVector
        var endVector: CIVector
        
        filter!.setDefaults()
        
        startVector = CIVector(x: 0, y: 0)
        endVector = CIVector(x: size.width, y: 0)
        
        filter!.setValue(startVector, forKey: "inputPoint0")
        filter!.setValue(endVector, forKey: "inputPoint1")
        filter!.setValue(color1, forKey: "inputColor0")
        filter!.setValue(color2, forKey: "inputColor1")
        
        if let cgImage = context.createCGImage(filter!.outputImage!, from: CGRect(x: 0, y: 0, width: size.width, height: size.height)){
            return UIImage(cgImage: cgImage)
        }
        
        return nil
    }
    
    static func showLoading(_ view:UIView){
        if let _ = loadingView{
        }else{
            loadingView = UIView(frame: view.bounds)
            loadingView.backgroundColor = UIColor(white: 0, alpha: 0.4)
        }
        
        loadingView.removeFromSuperview()
        view.addSubview(loadingView)
        
        if let _ = loadingIndicator{
        }else{
            loadingIndicator = UIActivityIndicatorView(style: .whiteLarge)
            loadingIndicator.center = loadingView.center;
            loadingIndicator.hidesWhenStopped = true
        }
        
        loadingIndicator.startAnimating()
        loadingView.addSubview(loadingIndicator)
    }
    
    static func hideLoading(){
        OperationQueue.main.addOperation {
            loadingIndicator.stopAnimating()
            loadingView.removeFromSuperview()
        }
    }
    
    static func showMessage(title:String,message:String,cntrl:UIViewController){
        OperationQueue.main.addOperation {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) in
                
            }))
            cntrl.present(alert, animated: true, completion: nil)
        }
    }
}

extension UIView{
    func getX()->CGFloat{
        return self.getLeft()
    }
    func getY()->CGFloat{
        return self.getTop()
    }
    func getRight()->CGFloat{
        return self.getLeft()+self.getWidth()
    }
    
    func getLeft()->CGFloat{
        return self.frame.origin.x
    }
    
    func getBottom()->CGFloat{
        return self.getTop()+self.getHeight()
    }
    
    func getTop()->CGFloat{
        return self.frame.origin.y
    }
    
    func getWidth()->CGFloat{
        return self.frame.size.width
    }
    
    func getHeight()->CGFloat{
        return self.frame.size.height
    }
}

extension UIImageView {
    public func imageFromServerURL(urlString: String,setImage:Bool=true,handler:ImageHandler?=nil) {
        
        if let data = GlobalUI.cachedImages[urlString]{
            let image = UIImage(data: data)
            if setImage{
                self.image = image
            }
            if let hndlr = handler{
                hndlr(true,data)
            }
            return
        }
        
        URLSession.shared.dataTask(with: NSURL(string: urlString)! as URL, completionHandler: { (data, response, error) -> Void in
            
            if let error = error {
                if let hndlr = handler{
                    hndlr(false,nil)
                }
                print(error)
                return
            }
            DispatchQueue.main.async(execute: { () -> Void in
                let image = UIImage(data: data!)
                if setImage{
                    self.image = image
                }
                GlobalUI.cachedImages[urlString] = data!
                if let hndlr = handler{
                    hndlr(true,data)
                }
            })
            
        }).resume()
    }
}

extension UIView {
    class func fromNib<T: UIView>() -> T {
        return Bundle.main.loadNibNamed(String(describing: T.self), owner: nil, options: nil)![0] as! T
    }
}
