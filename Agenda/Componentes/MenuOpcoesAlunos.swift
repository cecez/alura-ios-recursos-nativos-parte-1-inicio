//
//  MenuOpcoesAlunos.swift
//  Agenda
//
//  Created by Cezar Castro Rosa on 28/01/21.
//  Copyright © 2021 Alura. All rights reserved.
//

import UIKit

enum MenuActionSheetAluno {
    case sms
    case ligacao
}

class MenuOpcoesAlunos: NSObject {

    func configuraMenuDeOpcoesDoAluno(completion: @escaping(_ opcao: MenuActionSheetAluno) -> Void) -> UIAlertController {
        let menu        = UIAlertController(title: "Atenção", message: "escolha uma opção", preferredStyle: .actionSheet)
        let sms         = UIAlertAction(title: "enviar SMS", style: .default) { (acao) in completion(.sms) }
        let ligacao     = UIAlertAction(title: "ligar", style: .default) { (acao) in completion(.ligacao) }
        let cancelar    = UIAlertAction(title: "cancelar", style: .cancel, handler: nil)
        
        menu.addAction(sms)
        menu.addAction(ligacao)
        menu.addAction(cancelar)
        
        return menu
    }
    
}