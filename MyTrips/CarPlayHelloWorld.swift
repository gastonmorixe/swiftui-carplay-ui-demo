//
//  CarPlayHelloWorldTemplate.swift
//  CPHelloWorld
//
//  Created by Paul Wilkinson on 16/5/2023.
//  https://github.com/paulw11/CPHelloWorld/blob/main/CPHelloWorld/CarPlayHelloWorld.swift

import Foundation
import CarPlay

class CarPlayHelloWorld {
    var template: CPTemplate {
//        return CPListTemplate(title: "Hello world", sections: [self.section])
        let rootTemplate = CPMapTemplate()
//        self.interfaceController?.setRootTemplate(rootTemplate, animated: false)
        return rootTemplate
    }
    
    
//    var items: [CPListItem] {
//        return [CPListItem(text:"Hello world", detailText: "The world of CarPlay", image: UIImage(systemName: "globe"))]
//    }
//    
//    private var section: CPListSection {
//        return CPListSection(items: items)
//    }
    
}
