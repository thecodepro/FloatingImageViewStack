//
//  ViewController.swift
//  FloatingImageViewStackExample
//
//  Created by Zephaniah Cohen on 2/11/17.
//  Copyright © 2017 CodePro. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var floatingImageStack: FloatingImageViewStack!
    
    
    fileprivate let initialDataSource = [UIImage(named: "one")!,UIImage(named: "two")!]
    fileprivate var imagestoAdd = [UIImage(named:"three")!, UIImage(named:"four")!, UIImage(named: "five")!]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        floatingImageStack.delegate = self
              floatingImageStack.addImagesToStack(imageSet: initialDataSource)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
  
    }
    
    
    func addtoStack() {
        if let imageToAdd = imagestoAdd.first {
            floatingImageStack.addImageToStack(imageToAdd: imageToAdd)
            imagestoAdd.removeFirst()
        }
    }
    
    @IBAction func removeImage(_ sender: Any) {
        floatingImageStack.removeFloatingView(at: 0)
    }
}

extension ViewController : FloatingImageViewContainerDelegate {
    func didSelectFloatingTop() {
        addtoStack()
    }
    
    func didSelectFloatingImage(selectedView: FloatingImageView) {
        print("Selected a view from the stack")
    }
}

