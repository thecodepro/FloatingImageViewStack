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
    
    fileprivate var imageDataSource = [UIImage(named: "one")!,UIImage(named: "two")!,UIImage(named:"three")!, UIImage(named:"four")!, UIImage(named: "five")!]

    
    override func viewDidLoad() {
        super.viewDidLoad()
        floatingImageStack.delegate = self
    }
        
    func addtoStack() {
        if let imageToAdd = imageDataSource.first {
            floatingImageStack.addImageToStack(imageToAdd: imageToAdd)
            imageDataSource.removeFirst()
        }
    }
    
    @IBAction func addImage(_ sender: Any) {
        addtoStack()
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

