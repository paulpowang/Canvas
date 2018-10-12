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
        trayUp = trayView.center // The initial position of the tray
        trayDown = CGPoint(x: trayView.center.x ,y: trayView.center.y + trayDownOffset) // The position of the tray transposed down
        
        
        
    }
    

    @IBAction func didPanTray(_ sender: UIPanGestureRecognizer) {
        
        //let location = sender.location(in: view)
        var velocity = sender.velocity(in: view)
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
            
            var imageView = sender.view as! UIImageView
            newlyCreatedFace = UIImageView(image: imageView.image)
            view.addSubview(newlyCreatedFace)
            newlyCreatedFace.center = imageView.center
            newlyCreatedFace.center.y += trayView.frame.origin.y
            newlyCreatedFaceOriginalCenter = newlyCreatedFace.center
            
        }else if sender.state == .changed{
            newlyCreatedFace.center = CGPoint(x: newlyCreatedFaceOriginalCenter.x + translation.x, y: newlyCreatedFaceOriginalCenter.y + translation.y)
            
        } else if sender.state == .ended{
            
            
            
        }
        
        
    }
    
}
