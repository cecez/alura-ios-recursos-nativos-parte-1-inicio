//
//  MapaViewController.swift
//  Agenda
//
//  Created by Cezar Castro Rosa on 11/03/21.
//  Copyright © 2021 Alura. All rights reserved.
//

import UIKit
import MapKit

class MapaViewController: UIViewController {
    
    // MARK: - IBOutlet
    @IBOutlet weak var mapa: MKMapView!
    
    // MARK: - Variável
    var aluno: Aluno?
    
    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        localizacaoInicial()

        self.navigationItem.title = getTitulo()
    }
    
    func getTitulo() -> String {
        return "Localizar aluno"
    }
    
    // cria pino da localização do aluno
    func localizacaoAluno() {
        if let aluno = aluno {
            Localizacao().converteEnderecoEmCoordenadas(endereco: aluno.endereco!) { (localizacaoEncontrada) in
                let pino = self.configuraPino(titulo: aluno.nome!, localizacao: localizacaoEncontrada)
                
                self.mapa.addAnnotation(pino)
            }
        }
        
    }
    
    // cria pino e região inicial do mapa
    func localizacaoInicial() {
        Localizacao().converteEnderecoEmCoordenadas(endereco: "Av. Taquara, 146 - Porto Alegre") { (localizacaoEncontrada) in
            let pino = self.configuraPino(titulo: "Nitrodev", localizacao: localizacaoEncontrada)
            let regiao = MKCoordinateRegionMakeWithDistance(pino.coordinate, 5000, 5000)
            
            self.mapa.setRegion(regiao, animated: true)
            self.mapa.addAnnotation(pino)
        }
        
    }
    
    func configuraPino(titulo: String, localizacao: CLPlacemark) -> MKPointAnnotation {
        let pino        = MKPointAnnotation()
        pino.title      = titulo
        pino.coordinate = localizacao.location!.coordinate
        
        return pino
    }


}
