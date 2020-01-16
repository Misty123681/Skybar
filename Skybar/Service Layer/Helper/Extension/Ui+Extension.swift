
import UIKit

extension NSLayoutConstraint {
    
    func setMultiplier(multiplier:CGFloat) -> NSLayoutConstraint {
        
        NSLayoutConstraint.deactivate([self])
        
        let newConstraint = NSLayoutConstraint(
            item: firstItem,
            attribute: firstAttribute,
            relatedBy: relation,
            toItem: secondItem,
            attribute: secondAttribute,
            multiplier: multiplier,
            constant: constant)
        
        newConstraint.priority = priority
        newConstraint.shouldBeArchived = self.shouldBeArchived
        newConstraint.identifier = self.identifier
        
        NSLayoutConstraint.activate([newConstraint])
        return newConstraint
    }
}

extension StringProtocol where Index == String.Index {
    var isEmptyField: Bool {
        return trimmingCharacters(in: .whitespaces) == ""
    }
}

extension String {
    func firstCharacterUpperCase() -> String? {
        guard !isEmpty else { return nil }
        let lowerCasedString = self.lowercased()
        return lowerCasedString.replacingCharacters(in: lowerCasedString.startIndex...lowerCasedString.startIndex, with: String(lowerCasedString[lowerCasedString.startIndex]).uppercased())
    }
    
    func removeWhiteSpace()->String{
        return self.trimmingCharacters(in: .whitespaces) 

    }
}

extension UIButton{
     func setGradient() {
        self.setTitleColor(.white, for: .normal)
        let overlayer = UIView(frame: self.bounds)
        overlayer.tag = 10
        overlayer.layer.cornerRadius = self.frame.size.height/2
        
        let gradient = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.colors = gradientColor
        gradient.locations = [0, 1]
        gradient.startPoint = CGPoint(x: 1, y: 0.2)
        gradient.endPoint = CGPoint(x: 0.3, y: 0.67)
        gradient.cornerRadius = self.frame.size.height/2
        overlayer.layer.addSublayer(gradient)
        self.addSubview(overlayer)
        self.sendSubviewToBack(overlayer)
    }
}
