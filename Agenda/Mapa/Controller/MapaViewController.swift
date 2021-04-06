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
    lazy var localizacao = Localizacao()
    
    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = getTitulo()
        localizacaoInicial()
        localizacaoAluno()
        mapa.delegate = localizacao
        
    }
    
    func getTitulo() -> String {
        return "Localizar aluno"
    }
    
    // cria pino da localização do aluno
    func localizacaoAluno() {
        if let aluno = aluno {
              Localizacao().converteEnderecoEmCoordenadas(endereco: aluno.endereco!) { (localizacaoEncontrada) in
                let pino = Localizacao().configuraPino(titulo: aluno.nome!, localizacao: localizacaoEncontrada, cor: nil, icone: nil)
                self.mapa.addAnnotation(pino)
            }
        }
        
    }
    
    // cria pino e região inicial do mapa
    func localizacaoInicial() {
        Localizacao().converteEnderecoEmCoordenadas(endereco: "Av. Taquara, 146 - Porto Alegre") { (localizacaoEncontrada) in
            let pinoImage   = #imageLiteral(resourceName: "icone_nitro")
            let pino        = Localizacao().configuraPino(titulo: "Nitro", localizacao: localizacaoEncontrada, cor: .green, icone: pinoImage)
            let regiao      = MKCoordinateRegionMakeWithDistance(pino.coordinate, 5000, 5000)
            
            self.mapa.setRegion(regiao, animated: true)
            self.mapa.addAnnotation(pino)
        }
        
    }


}
