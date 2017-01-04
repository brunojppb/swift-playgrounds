import UIKit
import XCPlayground
import PlaygroundSupport

class LoadingCircleView: UIView {
    
    private var circleAnimationLayer = CAShapeLayer()
    fileprivate var currentProgress: CGFloat = 0.0
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = self.frame.size.width/2
        self.addAnimationLayer()
    }
    
    private func addAnimationLayer() {
        self.circleAnimationLayer.removeFromSuperlayer()
        let angle: CGFloat = 270 * (.pi / 180.0)
        let circlePath = UIBezierPath(arcCenter: CGPoint(x: self.frame.size.width/2, y: self.frame.size.height/2), radius: self.frame.size.width/4, startAngle: angle, endAngle: 630 * (.pi / 180.0), clockwise: true)
        self.circleAnimationLayer.path = circlePath.cgPath
        self.circleAnimationLayer.fillColor = UIColor.clear.cgColor
        self.circleAnimationLayer.strokeColor = UIColor.white.cgColor
        self.circleAnimationLayer.lineWidth = self.frame.size.width/2
        self.circleAnimationLayer.strokeEnd = 0
        
        self.layer.addSublayer(self.circleAnimationLayer)
    }
    
    func animate(with progress: Double) {
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.duration = 2
        animation.fromValue = currentProgress
        animation.toValue = progress
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        animation.isRemovedOnCompletion = false
        animation.fillMode = kCAFillModeForwards
        animation.delegate = self
        self.circleAnimationLayer.strokeEnd = 1
        self.circleAnimationLayer.add(animation, forKey: "animateCircle")
        self.currentProgress = CGFloat(progress)
    }
}

extension LoadingCircleView: CAAnimationDelegate {
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if self.currentProgress >= 1 {
            UIView.animate(withDuration: 0.3, animations: {
                self.alpha = 0.0
            })
        }
    }
}

let containerView = UIView(frame: CGRect(x: 0, y: 0, width: 500, height: 500))
containerView.backgroundColor = UIColor.black
let circleSize: CGFloat = 100
PlaygroundPage.current.liveView = containerView
PlaygroundPage.current.needsIndefiniteExecution = true

let circleView = LoadingCircleView()
containerView.addSubview(circleView)
circleView.layer.borderColor = UIColor.white.cgColor
circleView.layer.borderWidth = 2
circleView.translatesAutoresizingMaskIntoConstraints = false

var constraints = [NSLayoutConstraint]()

constraints.append(NSLayoutConstraint(item: circleView,
                                      attribute: .centerX,
                                      relatedBy: .equal,
                                      toItem: containerView,
                                      attribute: .centerX,
                                      multiplier: 1,
                                      constant: 0))
constraints.append(NSLayoutConstraint(item: circleView,
                                      attribute: .centerY,
                                      relatedBy: .equal,
                                      toItem: containerView,
                                      attribute: .centerY,
                                      multiplier: 1,
                                      constant: 0))
constraints.append(NSLayoutConstraint(item: circleView,
                                      attribute: .width,
                                      relatedBy: .equal,
                                      toItem: nil,
                                      attribute: .notAnAttribute,
                                      multiplier: 1,
                                      constant: circleSize))
constraints.append(NSLayoutConstraint(item: circleView,
                                      attribute: .height,
                                      relatedBy: .equal,
                                      toItem: nil,
                                      attribute: .notAnAttribute,
                                      multiplier: 1,
                                      constant: circleSize))

NSLayoutConstraint.activate(constraints)

circleView.animate(with: 1)


