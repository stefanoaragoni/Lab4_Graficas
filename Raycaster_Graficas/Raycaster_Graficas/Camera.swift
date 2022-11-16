//
//  Camera.swift
//  Raycaster_Graficas
//
//  Created by Stefano Aragoni on 14/11/22.
//
import Foundation

class Camera {
    var xR: CGFloat = 0
    var yR: CGFloat = 0
    var xT: CGFloat = 0
    var yT: CGFloat = 0
    var shader: Int = 1
    
    init(x: CGFloat, y: CGFloat, x2: CGFloat, y2: CGFloat) {
        self.xR = x
        self.yR = y
        self.xT = x2
        self.yT = y2
        
    }
    
    func setShader(x: Int) {
        self.shader = x
    }
    
    func getShader() -> Int {
        return self.shader;
    }
    
    
    func setR(x: CGFloat, y: CGFloat) {
        self.yR -= x
        self.xR += y
    }
    
    func setTY(y: CGFloat) {
        self.yT += y
        
        if(self.yT >= 1.4){
            self.yT = 1.4
        }
        
        if(self.yT <= -0.5){
            self.yT = -0.5
        }
    }
    
    func setTX(x: CGFloat) {
        self.xT += x
        
        if(self.xT >= 2.4){
            self.xT = 2.4
        }
        
        if(self.xT <= -2.4){
            self.xT = -2.4
        }
    }
    
    
    func retXR() -> CGFloat{
        return self.xR;
    }
    
    func retYR() -> CGFloat{
        return self.yR;
    }
    
    func retXT() -> CGFloat{
        return self.xT;
    }
    
    func retYT() -> CGFloat{
        return self.yT;
    }
    
}
