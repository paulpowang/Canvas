//
//  CanvasViewController.swift
//  Canvas
//
//  Created by paul on 10/11/18.
//  Copyright © 2018 PoHung Wang. All rights reserved.
//

import UIKit

class CanvasViewController: UIViewController {

    @IBOutlet weak var trayView: UIView!
    
    //to store the coordinates of the tray's original position
    var trayOriginalCenter: CGPoint!
    var trayDownOffset: CGFloat! = 0
    var trayUp: CGPoint!
    var trayDown: CGPoint!
    var newlyCreatedFace: UIImageView!
    var newlyCreatedFaceOriginalCenter: CGPoint!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        trayDownOffset = 160
        // The initial position of the tray
        trayUp = trayView.center
        // The position of the tray transposed down
        trayDown = CGPoint(x: trayView.center.x ,y: trayView.center.y + trayDownOffset)
        
    }
    

    @IBAction func didPanTray(_ sender: UIPanGestureRecognizer) {
        
        //let location = sender.location(in: view)
        let velocity = sender.velocity(in: view)
        let translation = sender.translation(in: view)
        
        
        if sender.state == .began {
            //print("Gesture began")
            trayOriginalCenter = trayView.center
        } else if sender.state == .changed {
            //print("Gesture is changing")
            trayView.center = CGPoint(x: trayOriginalCenter.x, y: trayOriginalCenter.y + translation.y)
        } else if sender.state == .ended {
            //print("Gesture ended")
            if velocity.y > 0{
                UIView.animate(withDuration: 0.3){
                    self.trayView.center = self.trayDown
                }
            }
            else{
                UIView.animate(withDuration: 0.3)
                {
                    self.trayView.center = self.trayUp
                }
            }
        }
        
    }//end of didPanTray
    
    
    @IBAction func didPanFace(_ sender: UIPanGestureRecognizer) {
        let location = sender.location(in: view)
        let translation = sender.translation(in: view)
        let velocity = sender.velocity(in: view)
        
        if sender.state == .began{
            
            let imageView = sender.view as! UIImageView
            newlyCreatedFace = UIImageView(image: imageView.image)
            view.addSubview(newlyCreatedFace)
            newlyCreatedFace.center = imageView.center
            newlyCreatedFace.center.y += trayView.frame.origin.y
            newlyCreatedFaceOriginalCenter = newlyCreatedFace.center
            
            // add a UIPanGestureRecognizer to the newly created face
            let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(didPanOriginalFace(sender:)))
            
            newlyCreatedFace.isUserInteractionEnabled = true
            newlyCreatedFace.addGestureRecognizer(panGestureRecognizer)
            
            // add a UIPinchGestreRecognizer to the newly created face
            let pinchGestureRecognizer = UIPinchGestureRecognizer(target: self, action: #selector(didPinchOriginalFace(sender:)))
            
            newlyCreatedFace.addGestureRecognizer(pinchGestureRecognizer)
            
            // add a UIRotationGestreRecognizer to the newly created face
            let rotationGestureRecognizer = UIRotationGestureRecognizer(target: self, action: #selector(didRotationOriginalFace(sender:)))
            
            newlyCreatedFace.addGestureRecognizer(rotationGestureRecognizer)
            
        }else if sender.state == .changed{
            newlyCreatedFace.center = CGPoint(x: newlyCreatedFaceOriginalCenter.x + translation.x, y: newlyCreatedFaceOriginalCenter.y + translation.y)
            
            // the animate when moving the face
            UIView.animate(withDuration: 0.2) {
                self.newlyCreatedFace.transform = CGAffineTransform(scaleX: 2.0, y: 2.0)
            }
            
        } else if sender.state == .ended{
            // ending Spring animation
            UIView.animate(withDuration: 0.8, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: [], animations: { () -> Void in
                self.newlyCreatedFace.transform = CGAffineTransform(scaleX: 1, y: 1)
            }, completion: nil)
            
            
        }
        
        
        
        
    }//end of didPanFace
    
    
    @objc func didPanOriginalFace(sender: UIPanGestureRecognizer) {
        
        let translation = sender.translation(in: view)
        
        if sender.state == .began {
            print("Gesture began")
            // to get the face that we panned on.
            newlyCreatedFace = sender.view as? UIImageView
            // so we can offset by translation later.
            newlyCreatedFaceOriginalCenter = newlyCreatedFace.center
        } else if sender.state == .changed {
            print("Gesture is changing")
            newlyCreatedFace.center = CGPoint(x: newlyCreatedFaceOriginalCenter.x + translation.x, y: newlyCreatedFaceOriginalCenter.y + translation.y)
            
            // the animate when moving the face
            UIView.animate(withDuration: 0.2) {
                self.newlyCreatedFace.transform = CGAffineTransform(scaleX: 2.0, y: 2.0)
            }
        } else if sender.state == .ended {
            print("Gesture ended")
            
            // ending Spring animation
            UIView.animate(withDuration: 0.8, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: [], animations: { () -> Void in
                self.newlyCreatedFace.transform = CGAffineTransform(scaleX: 1, y: 1)
            }, completion: nil)
        }
    }
    
    
    @objc func didPinchOriginalFace(sender: UIPinchGestureRecognizer) {
        
        let scale = sender.scale
        
        if sender.state == .began {
            newlyCreatedFace = sender.view as? UIImageView
            newlyCreatedFaceOriginalCenter = newlyCreatedFace.center
        } else if sender.state == .changed {
            newlyCreatedFace.transform = CGAffineTransform(scaleX: scale, y: scale)
        } else if sender.state == .ended {
            newlyCreatedFace.transform = CGAffineTransform(scaleX: scale, y: scale)
        }
    }
    
    @objc func didRotationOriginalFace(sender: UIRotationGestureRecognizer) {
        let rotation = sender.rotation
        
        if sender.state == .began {
            newlyCreatedFace = sender.view as? UIImageView
            newlyCreatedFaceOriginalCenter = newlyCreatedFace.center
        } else if sender.state == .changed {
            newlyCreatedFace.transform = CGAffineTransform(rotationAngle: rotation)
        } else if sender.state == .ended {
            //newlyCreatedFace.transform = CGAffineTransform(rotationAngle: rotation)
        }
    }
    
    
}
