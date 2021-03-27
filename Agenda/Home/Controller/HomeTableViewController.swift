//
//  HomeTableViewController.swift
//  Agenda
//
//  Created by Ândriu Coelho on 24/11/17.
//  Copyright © 2017 Alura. All rights reserved.
//

import UIKit
import CoreData

class HomeTableViewController: UITableViewController, UISearchBarDelegate, NSFetchedResultsControllerDelegate {
    
    //MARK: - Variáveis
    
    var contexto: NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    var gerenciadorDeResultados: NSFetchedResultsController<Aluno>?
    var alunoViewController: AlunoViewController?
    
    var mensagem = Mensagem()
    
    // MARK: - Constantes
    
    let searchController = UISearchController(searchResultsController: nil)

    
    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        self.configuraSearch()
        self.recuperaAluno()
    }
    
    // MARK: - Métodos
    
    func recuperaAluno() {
        let pesquisaAluno:NSFetchRequest = Aluno.fetchRequest()
        let ordenaPorNome = NSSortDescriptor(key: "nome", ascending: true)
        pesquisaAluno.sortDescriptors = [ordenaPorNome]
        
        gerenciadorDeResultados = NSFetchedResultsController(fetchRequest: pesquisaAluno, managedObjectContext: contexto, sectionNameKeyPath: nil, cacheName: nil)
        gerenciadorDeResultados?.delegate = self
        
        do {
            try gerenciadorDeResultados?.performFetch()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func configuraSearch() {
        self.searchController.searchBar.delegate = self
        self.searchController.dimsBackgroundDuringPresentation = false
        self.navigationItem.searchController = searchController
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editar" {
            alunoViewController = segue.destination as? AlunoViewController
        }
    }
    
    // MARK: - NSFetchedResultsControllerDelegate
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .delete:
            guard let indexPath = indexPath else { return }
            tableView.deleteRows(at: [indexPath], with: .fade)
            break
        default:
            tableView.reloadData()
        }
    }
    
    @objc func abrirActionSheet(_ longPress: UILongPressGestureRecognizer) {
        // estado inicial do pressionamento
        if longPress.state == .began {
            
            guard let alunoSelecionado = gerenciadorDeResultados?.fetchedObjects?[(longPress.view?.tag)!] else { return }
            
            let menu = MenuOpcoesAlunos().configuraMenuDeOpcoesDoAluno { (opcao) in
                switch opcao {
                case .sms:
                    if let componenteMensagem = self.mensagem.configuraSMS(alunoSelecionado) {
                        componenteMensagem.messageComposeDelegate = self.mensagem
                        self.present(componenteMensagem, animated: true, completion: nil)
                    }
                    break
                case .ligacao:
                    // desempacota seguramente número do aluno
                    guard let numeroDoAluno = alunoSelecionado.telefone else { return }
                    
                    // testa se é possível e abre URL criada para ligação
                    if let url = URL(string: "tel://\(numeroDoAluno)"), UIApplication.shared.canOpenURL(url) {
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    }
                    break
                case .waze:
                
                    // verifica se usuário tem Waze instalado
                    if (UIApplication.shared.canOpenURL(URL(string: "waze://")!)) {
                        guard let enderecoDoAluno = alunoSelecionado.endereco else { return }
                        Localizacao().converteEnderecoEmCoordenadas(endereco: enderecoDoAluno) { (localizacaoEncontrada) in
                            let latitude    = String(describing: localizacaoEncontrada.location!.coordinate.latitude)
                            let longitude   = String(describing: localizacaoEncontrada.location!.coordinate.longitude)
                            let url: String = "waze://?ll=\(latitude),\(longitude)&navigate=yes"
                            
                            UIApplication.shared.open(URL(string: url)!, options: [:], completionHandler: nil)
                        }
                    }
                
                    break
                case .mapa:
                    
                    if #available(iOS 13.0, *) {
                        let mapa = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "mapa") as! MapaViewController
                        mapa.aluno = alunoSelecionado
                        self.navigationController?.pushViewController(mapa, animated: true)
                    } else {
                        // Fallback on earlier versions
                    }
                    
                    
                    break
                }
            }
            self.present(menu, animated: true, completion: nil)
        }
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let contadorListaDeAlunos = gerenciadorDeResultados?.fetchedObjects?.count else {
            return 0
        }
        return contadorListaDeAlunos
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell            = tableView.dequeueReusableCell(withIdentifier: "celula-aluno", for: indexPath) as! HomeTableViewCell
        let longPress       = UILongPressGestureRecognizer(target: self, action: #selector(abrirActionSheet(_:)))
        
        guard let aluno     = gerenciadorDeResultados?.fetchedObjects![indexPath.row] else { return cell }
        
        cell.configuraCelula(aluno)
        cell.addGestureRecognizer(longPress)
        
        longPress.view?.tag = indexPath.row
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            guard let alunoSelecionado = gerenciadorDeResultados?.fetchedObjects![indexPath.row] else { return }
            contexto.delete(alunoSelecionado)
            
            do {
                try contexto.save()
            } catch {
                print(error.localizedDescription)
            }
            
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let alunoSelecionado = gerenciadorDeResultados?.fetchedObjects![indexPath.row] else { return }
        alunoViewController?.aluno = alunoSelecionado
    }
    
    @IBAction func buttonCalculaMedia(_ sender: UIBarButtonItem) {
        
        guard let listaDeAlunos2 = gerenciadorDeResultados?.fetchedObjects else { return }
        
        
        
        guard let url                                       = URL(string: "https://www.cecez.com.br/ios/api.php") else { return }
        var listaDeAlunos: Array<Dictionary<String, Any>>   = []
        var json: Dictionary<String, Any>                   = [:]
        
        
        for aluno in listaDeAlunos2 {
            
            guard let nome      = aluno.nome else { break }
            guard let endereco  = aluno.endereco else { break }
            guard let telefone  = aluno.telefone else { break }
            guard let site      = aluno.site else { break }
            
            let dicionarioAlunos                                =
            [
                "id":       "\(aluno.objectID)",
                "nome":     nome,
                "endereco": endereco,
                "telefone": telefone,
                "site":     site,
                "nota":     String(aluno.nota),
            ]
            
            listaDeAlunos.append(dicionarioAlunos as [String: Any])
            
        }
        
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
                        let dicionario = try JSONSerialization.jsonObject(with: data!, options: []) as! Dictionary<String, Any>
                        print("ok")
                        
                        
                        if let variavel = dicionario["media"] {
                        
                            let variavel2 = String(describing: variavel)
    
                            print("o valor é de \(variavel2)")
                            print ( type(of: variavel2) )
                            
                            DispatchQueue.main.async {
                              
                                let alerta  = UIAlertController(title: "Atenção", message: "a média geral dos alunos é \(variavel2)", preferredStyle: .alert)
                                let botao   = UIAlertAction(title: "OK", style: .default, handler: nil)
        
                                alerta.addAction(botao)
        
                                self.present(alerta, animated: true, completion: nil)
                                
                            }
    
                            
    
    
                        }
                        
                        
                    } catch {
                        print("erro 1")
                    }
                    
                }
            }
            task.resume()
            
        } catch {
            print("erro 2")
            print(error.localizedDescription)
        }
        
        
        
        
        
//        let constante = CalculaMediaAPI().calculaMediaGeralDosAlunos2(alunos: listaDeAlunos)
//
//        print(constante)
//
//
//        let alerta  = UIAlertController(title: "Atenção", message: "a média geral dos alunos é 11", preferredStyle: .alert)
//        let botao   = UIAlertAction(title: "OK", style: .default, handler: nil)
//
//        alerta.addAction(botao)
//
//        present(alerta, animated: true, completion: nil)
        
        
        
//        CalculaMediaAPI().calculaMediaGeralDosAlunos(
//            alunos: listaDeAlunos,
//            sucesso:
//                { (dicionario) in
//
//                    if let variavel = dicionario["media"] {
//
//                        let variavel2 = String(describing: variavel)
//
//                        print("o valor é de \(variavel2)")
//                        print ( type(of: variavel2) )
//
//                        let alerta  = UIAlertController(title: "Atenção", message: "a média geral dos alunos é \(variavel2)", preferredStyle: .alert)
//                        let botao   = UIAlertAction(title: "OK", style: .default, handler: nil)
//
//                        alerta.addAction(botao)
//
//                        self.present(alerta, animated: true, completion: nil)
//
//
//                    }
//
//
//                   if let alerta = Notificacoes().exibeNotificacaoDeMediaDosAlunos(dicionarioDeMedia: dicionario)
//                    { self.present(alerta, animated: false, completion: nil) }
//                },
//            falha: { (error) in print(error.localizedDescription)}
//        )

    }
    

}
