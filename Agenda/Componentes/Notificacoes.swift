//
//  Notificacoes.swift
//  Agenda
//
//  Created by Cezar Castro Rosa on 24/03/21.
//  Copyright © 2021 Alura. All rights reserved.
//

import UIKit

class Notificacoes: NSObject {
    
    func exibeNotificacaoDeMediaDosAlunos(dicionarioDeMedia: Dictionary<String, Any>) -> UIAlertController? {
        
        if let mediaRaw = dicionarioDeMedia["media"] {
            let media   = String(describing: mediaRaw)
            let alerta  = UIAlertController(title: "Atenção", message: "a média geral dos alunos é \(media)", preferredStyle: .alert)
            let botao   = UIAlertAction(title: "OK", style: .default, handler: nil)
            
            alerta.addAction(botao)
            
            return alerta
        } else {
            print("não rolou")
            
            //dump(dicionarioDeMedia["media"])
            if let variavel = dicionarioDeMedia["media"] {
                
                let variavel2 = String(describing: variavel)
                
                print("o valor é de \(variavel2)")
                print ( type(of: variavel2) )
            }
        }
        
        return nil
    }

}
