//
//  FloatingImageViewStack.swift
//
//  Created by Zephaniah Cohen on 2/5/17.
//  Copyright © 2017 Zeph Cohen. All rights reserved.
//

import Foundation
import UIKit

//MARK: - Floating Image View Container Delegate

protocol FloatingImageViewContainerDelegate {
    func didSelectFloatingImage(selectedView : FloatingImageView)
    func didSelectFloatingTop()
}

@IBDesignable class FloatingImageViewStack : UIView {
    
    //MARK: - Properties
    
    var delegate : FloatingImageViewContainerDelegate?
    
    private var floatingViewStack : [UIView] = []
    private var bottomConstraintConstant : CGFloat = -45
    private var imageWidth : CGFloat = 0
    private var imageHeight : CGFloat = 0
    private var stackTopView : FloatingTopView?
    private var verticalConstraints : [NSLayoutConstraint] = []
    private let constraintIdentifier = "bottomConstraint"
    
    private let scaleFactor : CGFloat = 0.70
    
    @IBInspectable var verticalSpacing : CGFloat = 35
    @IBInspectable var borderColor : UIColor = UIColor.clear
    @IBInspectable var topBorderColor : UIColor = UIColor.black
    @IBInspectable var topColor : UIColor = UIColor.clear
    @IBInspectable var topOpacity : Float = 1.0
    @IBInspectable var angle : CGFloat = -45
    @IBInspectable var color : UIColor  = UIColor.clear
    @IBInspectable var selectedBorderWidth : CGFloat = 3.0
    @IBInspectable var animationDuration : CGFloat = 0.7
    
    //MARK: - Init
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureUserInterface()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUserInterface()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    //MARK: - Interface Managemenet
    
    override func prepareForInterfaceBuilder() {
        configureUserInterface()
    }
    
    /// Configures all of the user interface elements of the control.
    private func configureUserInterface() {
    
        backgroundColor = color
    }
    
    /// Adds a single image to the floating image stack. Computes the image
    /// width and image height as a product of the parent frame width adjusted
    /// by a scale factor.
    ///
    /// - Parameter image: The image to add to the stack.
    func addImageToStack(imageToAdd image : UIImage) {
        
        if stackTopView == nil {
            addStackTopView()
        }
        
        buildAndAddFloatingImageview(with: image)
    }
    
    /// Removes a floating image view from the stack if it is found at the
    /// specified index. Will check to make sure that only FloatingImageViews
    /// are removed and the top is preserved.
    ///
    /// - Parameter index: The index of the view to remove from the stack.
    func removeFloatingView(at index : Int) {
        
        if let viewToRemove = floatingViewStack[safe:index], viewToRemove is FloatingImageView {
            viewToRemove.removeFromSuperview()
            floatingViewStack.remove(at: index)
            updateFloatingLayoutConstraints()
        }
    }
    
    /// Attemps to remove a selected floating image view by locating the index
    /// for this view. If found, the view is removed from the data source
    /// array and from the subviews. The auto layout is adjusted accordingly
    /// for these changes.
    ///
    /// - Parameter viewToRemove: The floating view to remove.
    func removeSelectedFloatingView(viewToRemove : FloatingImageView) {
        
        guard let indexToRemove = subviews.index(where: { $0 == viewToRemove }) else { return }
        
        let viewToRemove = floatingViewStack[indexToRemove]
        viewToRemove.removeFromSuperview()
        floatingViewStack.remove(at: indexToRemove)
        
        updateFloatingLayoutConstraints()
    }
    
    /// Builds a floating image view with the necessary configurations and adds
    /// it to the floating view stack. The auto layout is then applied after
    /// the floating view has been added.
    ///
    /// - Parameter image: The image to be used for the floating mage view to
    /// create.
    private func buildAndAddFloatingImageview(with image : UIImage) {
        
        imageWidth = frame.size.width * scaleFactor
        imageHeight = imageWidth
        
        let floatingImageView = FloatingImageView(frame: CGRect(x:0, y:0, width:imageWidth, height: imageHeight), image: image, borderColor: borderColor, isSelected: false, rotationAngle: angle, selectedBorderWidth: selectedBorderWidth)
        
        floatingImageView.tappedHandler = { selectedView in
            self.resetStackSelection()
            selectedView.selectFloatingView()
            self.delegate?.didSelectFloatingImage(selectedView: selectedView)
        }
        
        floatingImageView.translatesAutoresizingMaskIntoConstraints = false
        
        floatingImageView.performTransformRotation()
        
        floatingViewStack.insert(floatingImageView, at: 0)
        insertSubview(floatingImageView, at: 0)
        
        let constraints = buildLayoutFor(floatingView: floatingImageView)
        
        floatingImageView.bottomConstraint = constraints.first(where: { $0.identifier == constraintIdentifier})
        
        NSLayoutConstraint.activate(constraints)
        
        updateFloatingLayoutConstraints()
    }
    
    /// Iterates through each floating view in the stack and computes their
    /// updated constraint constants based upon the vertical spacing. These changes
    /// are then animated to accurately reflect additions or subtractions
    /// to the floating image stack.
    private func updateFloatingLayoutConstraints() {
        
        layoutIfNeeded()
        
        for index in 0..<floatingViewStack.count {
            
            let floatingView = floatingViewStack[index]
        
            var updatedConstraintConstant = -(CGFloat(index) * verticalSpacing)
            updatedConstraintConstant += bottomConstraintConstant
            
            if floatingView is FloatingTopView {
                
                let floatingTopView = floatingView as! FloatingTopView
                floatingTopView.bottomConstraint?.constant = updatedConstraintConstant
            } else if floatingView is FloatingImageView {
                let floatingImageView = floatingView as! FloatingImageView
                floatingImageView.bottomConstraint?.constant = updatedConstraintConstant
            }
        }
        
        UIView.animate(withDuration: TimeInterval(animationDuration)) {
            self.layoutIfNeeded()
        }
    }
    
    //MARK: - Stack Top View Management
    
    /// Builds and adds the stack top view. Applies the necessary auto layout to
    /// the view.
    private func addStackTopView() {
        
        imageWidth = bounds.size.width * scaleFactor
        imageHeight = imageWidth
        
        stackTopView = FloatingTopView(frame: CGRect(x: 0, y: 0, width: imageWidth, height: imageHeight),
                                       rotationAngle: angle,
                                       topBorderColor: topBorderColor,
                                       layerBackgroundColor:topColor,
                                       layerOpacity: topOpacity)
        
        stackTopView?.tappedHandler = {
            self.delegate?.didSelectFloatingTop()
        }
        
        stackTopView?.performTransformRotation()
        
        stackTopView?.translatesAutoresizingMaskIntoConstraints = false
        floatingViewStack.append(stackTopView!)
        addSubview(stackTopView!)
        
        //Apply the auto layout.
        let constraints = buildLayoutFor(floatingView: stackTopView!)
        
        stackTopView?.bottomConstraint = constraints.first(where: { $0.identifier == constraintIdentifier})
        
        NSLayoutConstraint.activate(constraints)
        
        updateFloatingLayoutConstraints()
    }
    
    /// Iterates through through each floating view in the stack resetting the 
    /// selected state back to unselected.
    func resetStackSelection() {
        for view in floatingViewStack {
            if view is FloatingImageView {
                let stackImageView = view as! FloatingImageView
                stackImageView.resetSelection()
            }
        }
    }
    
    //MARK: - Layout Management
    
    
    /// Builds the appropriate auto layout constraints for the floating view.
    /// Adjusts the bottom constraint constants for rotation angles that are 
    /// multiples of 90 degrees.
    ///
    /// - Parameter floatingView: The view that needs layout constraints.
    /// - Returns: An array of constraints configured for the source floating
    /// view.
    func buildLayoutFor(floatingView : UIView) -> [NSLayoutConstraint] {
        
        var constraintContainer : [NSLayoutConstraint] = []
        
        let metrics : [String:Any] = [
            "imageWidth" : imageWidth,
            "imageHeight" : imageHeight,
        ]
        
        constraintContainer += NSLayoutConstraint.constraints(withVisualFormat: "H:[floatingView(imageWidth)]", options: [], metrics: metrics, views: ["floatingView" : floatingView])
        constraintContainer += NSLayoutConstraint.constraints(withVisualFormat: "V:[floatingView(imageHeight)]", options: [], metrics: metrics, views: ["floatingView" : floatingView])
        
        let horizontalCenter = NSLayoutConstraint(item: floatingView, attribute: .centerX, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0)
        
        if Int(angle) % 90 == 0 {
            bottomConstraintConstant = -15
        }
        
        
        let bottomConstraint = NSLayoutConstraint(item: floatingView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: bottomConstraintConstant)
        
        bottomConstraint.identifier = constraintIdentifier
        
        constraintContainer.append(horizontalCenter)
        constraintContainer.append(bottomConstraint)
        
        return constraintContainer
    }
}

//MARK: - Floating Image View

class FloatingImageView : UIImageView {
    
    //MARK: - Properties
    
    private let displayBorderColor : UIColor
    private var isSelected : Bool
    private var selectedOpacity : CGFloat = 1.0
    private var unselectedOpacity : CGFloat = 0.07
    private let roundedCornerRadius : CGFloat = 6
    private var displayedBorderWidth : CGFloat = 3.0
    private let displayImage : UIImage
    private let imageRotationAngle : CGFloat
    private var nonRotatedAngle : CGFloat = 0
    private var wasRotated = false
    
    fileprivate var bottomConstraint : NSLayoutConstraint?
    fileprivate var tappedHandler : ((FloatingImageView) -> Void)?
    
    //MARK: - Init
    
    init(frame: CGRect, image : UIImage, borderColor : UIColor, isSelected : Bool, rotationAngle : CGFloat, selectedBorderWidth : CGFloat) {
        
        self.displayBorderColor = borderColor
        self.isSelected = isSelected
        self.displayImage = image
        self.displayedBorderWidth = selectedBorderWidth
        self.imageRotationAngle = rotationAngle
        
        super.init(frame: frame)
        
        prepareUserInterface()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - User Interface Management
    
    /// Configures and adds all the user interface elements.
    private func prepareUserInterface() {
        image = displayImage
        layer.borderWidth = displayedBorderWidth
        
        toggleVisualStateForSelection(isSelected: isSelected)
        
        isUserInteractionEnabled = true
        clipsToBounds = true
        contentMode = .scaleAspectFill
        layer.masksToBounds = true
        layer.cornerRadius = roundedCornerRadius
    }
    
    //MARK: - Rotation Management
    
    
    /// Rotates the transform of the floating view and marks the view as being
    /// rotated.
    func performTransformRotation() {
        if wasRotated == false {
            wasRotated = true
            transform = CGAffineTransform.init(rotationAngle: CGFloat(imageRotationAngle).degreesToRadians)
        }
    }
    
    /// Rotates the transform of the floating view back to the default starting 
    /// angle of 0 degrees. Marks the view as not being rotated.
    func undoTransformRotation() {
        if wasRotated {
            transform = CGAffineTransform.init(rotationAngle: CGFloat(nonRotatedAngle).degreesToRadians)
            wasRotated = false
        }
    }
    
    //MARK: - Selection Management
    
    /// Resets all UI that indicated that the floating view was actively 
    /// selected.
    fileprivate func resetSelection() {
        isSelected = false
        self.alpha = self.unselectedOpacity
        self.layer.borderColor = UIColor.black.cgColor
    }
    
    /// Updates the UI for the floating view indicating that is has been selected.
    fileprivate func selectFloatingView() {
        isSelected = true
        toggleVisualStateForSelection(isSelected: isSelected)
    }
    
    /// Changes the visual state indicating active selection.
    private func toggleVisualStateForSelection(isSelected :Bool) {
        if isSelected == false {
            resetSelection()
        } else {
            alpha = selectedOpacity
            layer.borderColor = displayBorderColor.cgColor
        }
    }
    
    //MARK: - Touch Management
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if isSelected == false {
            isSelected = true
        } else {
            isSelected = false
        }
        toggleVisualStateForSelection(isSelected: isSelected)
        tappedHandler?(self)
    }
}

//MARK: - Floating Top View

private class FloatingTopView : UIView {
    
    //MARK: - Properties
    
    private var wasRotated = false
    private let imageRotationAngle : CGFloat
    private var nonRotatedAngle : CGFloat = 0
    private let topBorderColor : UIColor
    private let layerBackgroundColor : UIColor
    private let layerOpacity : Float
    var tappedHandler : (() -> Void)?
    var bottomConstraint : NSLayoutConstraint?
    
    //MARK: - Init
    
    init(frame: CGRect, rotationAngle : CGFloat, topBorderColor : UIColor, layerBackgroundColor : UIColor, layerOpacity : Float) {
        self.imageRotationAngle = rotationAngle
        self.topBorderColor = topBorderColor
        self.layerOpacity = layerOpacity
        self.layerBackgroundColor = layerBackgroundColor
        super.init(frame: frame)
        buildInterface()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Builder User Interface
    
    /// Configures and builds the user interface adding the shape layer with the 
    /// defined settings and attributes.
    private func buildInterface() {
        
        let shapeLayer = CAShapeLayer()
        let frameSize = self.frame.size
        let shapeRect = CGRect(x: 0, y: 0, width: frameSize.width, height: frameSize.height)
        
        shapeLayer.bounds = shapeRect
        shapeLayer.position = CGPoint(x: frameSize.width/2, y: frameSize.height/2)
        shapeLayer.fillColor = layerBackgroundColor.cgColor
        shapeLayer.opacity = layerOpacity
        shapeLayer.strokeColor = topBorderColor.cgColor
        shapeLayer.lineWidth = 1
        shapeLayer.lineJoin = kCALineJoinRound
        shapeLayer.lineDashPattern = [5,3]
        shapeLayer.path = UIBezierPath(roundedRect: shapeRect, cornerRadius: 6).cgPath
        
        layer.addSublayer(shapeLayer)
        
        let centerPoint = CGPoint(x: frame.size.width/2, y: frame.size.height/2)
        let horizontalStart = CGPoint(x: centerPoint.x-10, y: centerPoint.y)
        let horizontalEnd = CGPoint(x: centerPoint.x+10, y: centerPoint.y)
        let verticalStart = CGPoint(x: centerPoint.x, y: centerPoint.y+10)
        let verticalEnd = CGPoint(x: centerPoint.x, y: centerPoint.y-10)
        
        drawLineFromPoint(start: horizontalStart, toPoint: horizontalEnd, ofColor: UIColor.black, inView: self, lineWidth:4.0)
        
        drawLineFromPoint(start: verticalStart, toPoint: verticalEnd, ofColor: UIColor.black, inView: self, lineWidth: 4.0)
    }
    
    /// Paths a line and then sets this to a shape layer that is added as a 
    /// sublayer of the view.
    ///
    /// - Parameters:
    ///   - start: The starting point for the line.
    ///   - end: The ending point for the line.
    ///   - lineColor: The stroke color for the line.
    ///   - view: The source view to draw the line into.
    ///   - width: The width of the line to draw.
    private func drawLineFromPoint(start : CGPoint, toPoint end:CGPoint, ofColor lineColor: UIColor, inView view:UIView, lineWidth width : CGFloat) {
        
        let path = UIBezierPath()
        path.move(to: start)
        path.addLine(to: end)
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.frame = frame
        shapeLayer.path = path.cgPath
        shapeLayer.strokeColor = lineColor.cgColor
        shapeLayer.lineWidth = width
        
        shapeLayer.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        shapeLayer.transform = CATransform3DRotate(shapeLayer.transform, CGFloat(imageRotationAngle).degreesToRadians, 0.0, 0.0, 1.0)
        shapeLayer.position = CGPoint(x: frame.size.width/2, y: frame.size.height/2)
        
        view.layer.addSublayer(shapeLayer)
    }
    
    //MARK: - Touch Management
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        tappedHandler?()
    }
    
    //MARK: - Rotation Management
    
    /// Rotates the floating view to the specified rotation angle. Marks the 
    /// view as having been rotated.
    func performTransformRotation() {
        if wasRotated == false {
            wasRotated = true
            transform = CGAffineTransform.init(rotationAngle: CGFloat(imageRotationAngle).degreesToRadians)
        }
    }
    
    /// Rotates the floating view back to an un-rotated state and marks the view
    /// as not being rotated.
    func undoTransformRotation() {
        if wasRotated {
            transform = CGAffineTransform.init(rotationAngle: CGFloat(nonRotatedAngle).degreesToRadians)
            wasRotated = false
        }
    }
}

//MARK: - Safe Array Indexing

fileprivate extension Collection where Indices.Iterator.Element == Index {
    
    /// Returns the element at the specified index iff it is within bounds, otherwise nil.
    subscript (safe index: Index) -> Generator.Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

//MARK: - Degrees <---> Radians Management

fileprivate extension FloatingPoint {
     var degreesToRadians: Self { return self * .pi / 180 }
     var radiansToDegrees: Self { return self * 180 / .pi }
}


