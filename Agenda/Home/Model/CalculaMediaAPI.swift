//
//  CalculaMediaAPI.swift
//  Agenda
//
//  Created by Cezar Castro Rosa on 18/03/21.
//  Copyright © 2021 Alura. All rights reserved.
//

import UIKit

class CalculaMediaAPI: NSObject {
    
    func calculaMediaGeralDosAlunos() {
        
        guard let url                                       = URL(string: "https://www.caelum.com.br/mobile") else { return }
        var listaDeAlunos: Array<Dictionary<String, Any>>   = []
        var json: Dictionary<String, Any>                   = [:]
        var dicionarioAlunos                                =
        [
            "id":       "1",
            "nome":     "Nome 1",
            "endereco": "Endereco 1",
            "telefone": "111111",
            "site":     "www.um.com",
            "nota":     "1",
        ]
        
        listaDeAlunos.append(dicionarioAlunos as [String: Any])
        
        json = [
            "list": [
                [ "aluno": listaDeAlunos ]
            ]
        ]
        
        do {
            var requisicao          = URLRequest(url: url)
            let data                = try JSONSerialization.data(withJSONObject: json, options: [])
            requisicao.httpBody     = data
            requisicao.httpMethod   = "POST"
            
            requisicao.addValue("application/json", forHTTPHeaderField: "Content-Type")
            
            let task = URLSession.shared.dataTask(with: requisicao) { (data, response, error) in
                if error == nil {
                    do {
                        let dicionario = try JSONSerialization.jsonObject(with: data!, options: [])
                        print(dicionario)
                    } catch {
                        print("erro 1")
                        print(error.localizedDescription)
                    }
                    
                }
            }
            task.resume()
            
        } catch {
            print("erro 2")
            print(error.localizedDescription)
        }
        
    }

}
