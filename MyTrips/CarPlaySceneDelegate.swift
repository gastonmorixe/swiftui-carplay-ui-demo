//
//  CarPlaySceneDelegate.swift
//  CPHelloWorld
//
//  Created by Paul Wilkinson on 16/5/2023.
//  https://github.com/paulw11/CPHelloWorld/blob/main/CPHelloWorld/CarPlaySceneDelegate.swift

import Foundation
import CarPlay

class CarPlaySceneDelegate: UIResponder, CPTemplateApplicationSceneDelegate {
    
    var interfaceController: CPInterfaceController?
    var carWindow: CPWindow?

    var mapTemplate: CPMapTemplate?
    var mapView: CarPlayMapView?
    

    func templateApplicationScene(_ templateApplicationScene: CPTemplateApplicationScene, didConnect interfaceController: CPInterfaceController, to window: CPWindow) {
        
        self.interfaceController = interfaceController
//        self.carWindow = window

//        let template = CarPlayHelloWorld().template
//        self.interfaceController?.setRootTemplate(template, animated: false, completion: nil)
        
        self.mapTemplate = CPMapTemplate()
        self.mapTemplate?.automaticallyHidesNavigationBar = false
        self.mapTemplate?.trailingNavigationBarButtons.append(contentsOf: getMapBarButtons())
        self.mapTemplate?.showPanningInterface(animated: true)
        self.mapTemplate?.mapDelegate = self.mapView
        
                
        self.mapView = CarPlayMapView()
        window.rootViewController = self.mapView
        self.carWindow = window
        self.carWindow?.isUserInteractionEnabled = true
        self.carWindow?.isMultipleTouchEnabled = true
        self.interfaceController?.setRootTemplate(self.mapTemplate!, animated: true, completion: {_, _ in })

    }
    
    
    private func getMapBarButtons() -> [CPBarButton] {
        return [
            CPBarButton(image: UIImage(systemName: "location")!, handler: { _ in
                print("🚙🚙🚙🚙🚙 Tapped locate me")
            })
        ]
    }
    
    
    func templateApplicationScene(_ templateApplicationScene: CPTemplateApplicationScene, didDisconnectInterfaceController interfaceController: CPInterfaceController) {
        self.interfaceController = nil
    }
}
