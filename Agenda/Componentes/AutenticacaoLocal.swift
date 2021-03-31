//
//  AutenticacaoLocal.swift
//  Agenda
//
//  Created by Cezar Castro Rosa on 31/03/21.
//  Copyright © 2021 Alura. All rights reserved.
//

import UIKit
import LocalAuthentication

class AutenticacaoLocal: NSObject {
    
    func autorizaUsuario(completion: @escaping(_ autenticado: Bool) -> Void) {
        let contexto = LAContext()
        var error: NSError?
        
        // verifica se dispositivo possui recurso de autenticação local
        if (contexto.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error)) {
            contexto.evaluatePolicy(
                .deviceOwnerAuthentication,
                localizedReason: "Precisamos que você se autentique para excluir um aluno.",
                reply: { (resposta, erro) in
                    completion(resposta)
                })
        }
    }

}
