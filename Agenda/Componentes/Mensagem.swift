//
//  Mensagem.swift
//  Agenda
//
//  Created by Cezar Castro Rosa on 09/02/21.
//  Copyright © 2021 Alura. All rights reserved.
//

import UIKit
import MessageUI

class Mensagem: NSObject, MFMessageComposeViewControllerDelegate {
    
    // MARK: - Métodos
    
    func configuraSMS(_ aluno: Aluno) -> MFMessageComposeViewController? {
        
        if MFMessageComposeViewController.canSendText() {
            let componenteMensagem  = MFMessageComposeViewController()
            guard let numeroDoAluno = aluno.telefone else { return componenteMensagem }
            
            componenteMensagem.recipients               = [numeroDoAluno]
            componenteMensagem.messageComposeDelegate   = self
            
            
            return componenteMensagem
        }
        
        return nil
    }
    
    
    // MARK: - MFMessageComposeViewControllerDelegate
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    
}
