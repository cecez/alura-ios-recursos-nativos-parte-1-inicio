//
//  Pino.swift
//  Agenda
//
//  Created by Cezar Castro Rosa on 05/04/21.
//  Copyright © 2021 Alura. All rights reserved.
//

import UIKit
import MapKit

class Pino: NSObject, MKAnnotation {
    
    var title: String?
    var icone: UIImage?
    var color: UIColor?
    var coordinate: CLLocationCoordinate2D
    
    init(coordenada: CLLocationCoordinate2D) {
        self.coordinate = coordenada
    }

}
