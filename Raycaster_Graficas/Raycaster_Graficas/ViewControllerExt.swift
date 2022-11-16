//
//  ViewControllerExt.swift
//  Raycaster_Graficas
//
//  Created by Stefano Aragoni on 14/11/22.
//

import Cocoa

extension ViewController {
    
    override func keyDown(with event: NSEvent) {
        let key = (event.keyCode)
        print(key)
        
        if (key == 126){
            renderer?.camera.setTY(y: -0.08)
        }
        if (key == 125){
            renderer?.camera.setTY(y: 0.08)
        }
        if (key == 124){
            renderer?.camera.setTX(x: -0.08)
        }
        if (key == 123){
            renderer?.camera.setTX(x: 0.08)
        }
        
        if (key == 18){
            renderer?.camera.setShader(x: 1)
        }
        
        if (key == 19){
            renderer?.camera.setShader(x: 2)
        }
        
        if (key == 20){
            renderer?.camera.setShader(x: 3)
        }
                
    }


    
    func addGestureRecognizers(to view: NSView) {
        let pan = NSPanGestureRecognizer(target: self, action: #selector(handlePan(gesture:)))
        view.addGestureRecognizer(pan)
    }

    @objc func handlePan(gesture: NSPanGestureRecognizer) {
        let translation = gesture.translation(in: gesture.view)
        renderer?.camera.setR(x:translation.x, y:translation.y)
        gesture.setTranslation(.zero, in: gesture.view)
    }
  
}
