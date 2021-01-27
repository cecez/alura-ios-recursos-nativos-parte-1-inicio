//
//  AlunoViewController.swift
//  Agenda
//
//  Created by Ândriu Coelho on 24/11/17.
//  Copyright © 2017 Alura. All rights reserved.
//

import UIKit
import CoreData

class AlunoViewController: UIViewController, ImagePickerFotoSelecionada {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var viewImagemAluno: UIView!
    @IBOutlet weak var imageAluno: UIImageView!
    @IBOutlet weak var buttonFoto: UIButton!
    @IBOutlet weak var scrollViewPrincipal: UIScrollView!
    
    @IBOutlet weak var textFieldNome: UITextField!
    @IBOutlet weak var textFieldEndereco: UITextField!
    @IBOutlet weak var textFieldTelefone: UITextField!
    @IBOutlet weak var textFieldSite: UITextField!
    @IBOutlet weak var textFieldNota: UITextField!
    
    // MARK: - Atributos
    
    var contexto:NSManagedObjectContext {
        let appDelegate =   UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    let imagePicker = ImagePicker()
    var aluno:Aluno?
    
    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        self.arredondaView()
        self.setup()
        NotificationCenter.default.addObserver(self, selector: #selector(aumentarScrollView(_:)), name: .UIKeyboardWillShow, object: nil)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
    
    // MARK: - Métodos
    
    func setup() {
        imagePicker.delegate        = self
        guard let alunoSelecionado  = aluno else { return }
        textFieldNome.text          = alunoSelecionado.nome
        textFieldEndereco.text      = alunoSelecionado.endereco
        textFieldTelefone.text      = alunoSelecionado.telefone
        textFieldSite.text          = alunoSelecionado.site
        textFieldNota.text          = "\(alunoSelecionado.nota)"
        
        let gerenciadorDeArquivos   = FileManager.default
        let caminho                 = NSHomeDirectory() as NSString
        let caminhoDaImagem         = caminho.appendingPathComponent(alunoSelecionado.foto!)
        
        if gerenciadorDeArquivos.fileExists(atPath: caminhoDaImagem) {
            imageAluno.image = UIImage(contentsOfFile: caminhoDaImagem)
        }
    }
    
    func arredondaView() {
        self.viewImagemAluno.layer.cornerRadius = self.viewImagemAluno.frame.width / 2
        self.viewImagemAluno.layer.borderWidth = 1
        self.viewImagemAluno.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    @objc func aumentarScrollView(_ notification:Notification) {
        self.scrollViewPrincipal.contentSize = CGSize(width: self.scrollViewPrincipal.frame.width, height: self.scrollViewPrincipal.frame.height + self.scrollViewPrincipal.frame.height/2)
    }
    
    func mostrarMultimidia(_ opcao: MenuOpcoes)
    {
        // cria multimídia
        let multimidia          = UIImagePickerController()
        multimidia.delegate     = imagePicker
        
        // define tipo de multimídia para exibir
        if opcao == .camera && UIImagePickerController.isSourceTypeAvailable(.camera) {
            multimidia.sourceType = .camera
        } else {
            multimidia.sourceType = .photoLibrary
        }
        
        // apresenta multimídia
        self.present(multimidia, animated: true, completion: nil)
    }
    
    // MARK: - Delegate
    
    func imagePickerFotoSelecionada(_ foto: UIImage) {
        imageAluno.image = foto
    }
    
    // MARK: - IBActions
    
    // botão para selecionar foto do contato da agenda
    @IBAction func buttonFoto(_ sender: UIButton) {
        
        // cria e apresenta menu
        let menu = ImagePicker().menuDeOpcoes { (opcao) in
            self.mostrarMultimidia(opcao)
        }
        present(menu, animated: true, completion: nil)
    }
    
    @IBAction func stepperNota(_ sender: UIStepper) {
        self.textFieldNota.text = "\(sender.value)"
    }
    
    @IBAction func buttonSalvar(_ sender: UIButton) {
        
        // novo aluno
        if aluno == nil {
            aluno = Aluno(context: contexto)
        }
        
        // cria caminho do diretório para salvar imagem
        let caminhoDoSistemaDeArquivos  = NSHomeDirectory() as NSString
        let diretorioDeImagens          = "Documents/Images"
        let caminhoCompleto             = caminhoDoSistemaDeArquivos.appendingPathComponent(diretorioDeImagens)
        
        // verifica, e se necessário cria, diretório de imagens
        let gerenciadorDeArquivos = FileManager.default
        if !gerenciadorDeArquivos.fileExists(atPath: caminhoCompleto) {
            do {
                try gerenciadorDeArquivos.createDirectory(atPath: caminhoCompleto, withIntermediateDirectories: false, attributes: nil)
            } catch {
                print(error.localizedDescription)
            }
        }
        
        // cria nome da imagem
        let nomeDaImagem    = String(format: "%@.jpeg", aluno!.objectID.uriRepresentation().lastPathComponent)
        let url             = URL(fileURLWithPath: String(format: "%@/%@", caminhoCompleto, nomeDaImagem))
        
        // transforma de UIImage para Data e a salva
        guard let imagem = imageAluno.image else { return }
        guard let data = UIImagePNGRepresentation(imagem) else { return }
        
        do {
            try data.write(to: url)
        } catch {
            print(error.localizedDescription)
        }
        
        
        
        aluno?.nome      = textFieldNome.text
        aluno?.endereco  = textFieldEndereco.text
        aluno?.telefone  = textFieldTelefone.text
        aluno?.site      = textFieldSite.text
        aluno?.nota      = (textFieldNota.text! as NSString).doubleValue
        aluno?.foto      = String(format: "%@/%@", diretorioDeImagens, nomeDaImagem)
        
        do {
            try contexto.save()
            navigationController?.popViewController(animated: true)
        } catch {
            print(error.localizedDescription)
        }
        
    }
    
}
