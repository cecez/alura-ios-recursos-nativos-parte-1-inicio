//
//  Localizacao.swift
//  Agenda
//
//  Created by Cezar Castro Rosa on 09/03/21.
//  Copyright © 2021 Alura. All rights reserved.
//

import UIKit
import MapKit

class Localizacao: NSObject, MKMapViewDelegate {
    
    func converteEnderecoEmCoordenadas(endereco: String, local: @escaping(_ local:CLPlacemark) -> Void) {
        let conversor = CLGeocoder()
        conversor.geocodeAddressString(endereco) { (listaDeLocalizacoes, error) in
            if let localizacao = listaDeLocalizacoes?.first {
                local(localizacao)
            }
        }
    }
    
    func configuraPino(titulo: String, localizacao: CLPlacemark, cor: UIColor?, icone: UIImage?) -> Pino {
        let pino        = Pino(coordenada: localizacao.location!.coordinate)
        pino.title      = titulo
        pino.icone      = icone
        pino.color      = cor
        
        return pino
    }
    
    func configuraBotaoLocalizacaoAtual(mapa: MKMapView) -> MKUserTrackingButton {
        let botao               = MKUserTrackingButton(mapView: mapa)
        botao.frame.origin.x    = 10
        botao.frame.origin.y    = 10
        
        return botao
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is Pino {
            let annotatioView           = annotation as! Pino
            var pinoView                = mapView.dequeueReusableAnnotationView(withIdentifier: annotatioView.title!) as? MKMarkerAnnotationView
            pinoView                    = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: annotation.title!)
            pinoView?.annotation        = annotatioView
            pinoView?.glyphImage        = annotatioView.icone
            pinoView?.markerTintColor   = annotatioView.color
            
            
            
            return pinoView
        }
        
        return nil
    }

}
