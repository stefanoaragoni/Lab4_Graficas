//
//  ViewController.swift
//  Raycaster_Graficas
//
//  Created by Stefano Aragoni on 14/11/22.
//

import Cocoa
import MetalKit

//controlador de la vista
class ViewController: NSViewController {
    
    var renderer: Renderer?
    @IBOutlet var textField: NSTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        //verifica que se haya instanciado metal en el view
        guard let metalView = view as? MTKView else {
          fatalError("ERROR METALview")
        }
        
        //le manda como parametro a Renderer el metalView
        renderer = Renderer(metalView: metalView)
        addGestureRecognizers(to: metalView)
        
        
        
//        NSEvent.addLocalMonitorForEvents(matching: .flagsChanged) {
//            self.flagsChanged(with: $0)
//            return $0
//        }
        
        NSEvent.addLocalMonitorForEvents(matching: .keyDown) {
            self.keyDown(with: $0)
            return $0
        }
    }
    
    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    

}

