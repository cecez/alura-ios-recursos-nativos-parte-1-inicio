//
//  MapaViewController.swift
//  Agenda
//
//  Created by Cezar Castro Rosa on 11/03/21.
//  Copyright © 2021 Alura. All rights reserved.
//

import UIKit

class MapaViewController: UIViewController {
    
    // MARK: - Variável
    var aluno: Aluno?
    
    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = getTitulo()
    }
    
    func getTitulo() -> String {
        return "Localizar aluno"
    }
    



}
