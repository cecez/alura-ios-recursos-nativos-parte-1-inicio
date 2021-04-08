//
//  MapaViewController.swift
//  Agenda
//
//  Created by Cezar Castro Rosa on 11/03/21.
//  Copyright © 2021 Alura. All rights reserved.
//

import UIKit
import MapKit

class MapaViewController: UIViewController, CLLocationManagerDelegate {
    
    // MARK: - IBOutlet
    @IBOutlet weak var mapa: MKMapView!
    
    // MARK: - Variável
    var aluno: Aluno?
    lazy var localizacao                = Localizacao()
    lazy var gerenciadorDeLocalizacao   = CLLocationManager()
    
    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Localizar aluno"
        
        mapa.delegate                       = localizacao
        gerenciadorDeLocalizacao.delegate   = self
        
        localizacaoInicial()
        verificaAutorizacaoDeLocalizacaoDoUsuario()
    }
    
    // MARK: - Métodos
    
    func verificaAutorizacaoDeLocalizacaoDoUsuario() {
        if CLLocationManager.locationServicesEnabled() {
            switch CLLocationManager.authorizationStatus() {
                case .authorizedWhenInUse:
                    let botao = Localizacao().configuraBotaoLocalizacaoAtual(mapa: mapa)
                    mapa.addSubview(botao)
                    gerenciadorDeLocalizacao.startUpdatingLocation()
                    break
                    
                case .notDetermined: // primeira vez ao utilizar recurso
                    gerenciadorDeLocalizacao.requestWhenInUseAuthorization()
                    break
                    
                case .denied:
                    break
                    
                default:
                    break
            }
        }
    }
    
    
    // cria pino da localização do aluno
    func localizacaoAluno() {
        if let aluno = aluno {
              Localizacao().converteEnderecoEmCoordenadas(endereco: aluno.endereco!) { (localizacaoEncontrada) in
                let pino = Localizacao().configuraPino(titulo: aluno.nome!, localizacao: localizacaoEncontrada, cor: nil, icone: nil)
                
                self.mapa.addAnnotation(pino)
                self.mapa.showAnnotations(self.mapa.annotations, animated: true)
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
            self.localizacaoAluno()
    
        }
        
    }
    
    // MARK: - CLLocationManagerDelegate
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
            case .authorizedWhenInUse:
                let botao = Localizacao().configuraBotaoLocalizacaoAtual(mapa: mapa)
                mapa.addSubview(botao)
                gerenciadorDeLocalizacao.startUpdatingLocation()
                
            default:
                break
        }
    }


}
