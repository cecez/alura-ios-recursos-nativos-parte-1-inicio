//
//  ImagePicker.swift
//  Agenda
//
//  Created by Cezar Castro Rosa on 13/01/21.
//  Copyright © 2021 Alura. All rights reserved.
//

import UIKit

protocol ImagePickerFotoSelecionada {
    func imagePickerFotoSelecionada(_ foto: UIImage)
}

class ImagePicker: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // MARK: - Atributos
    
    var delegate: ImagePickerFotoSelecionada?
    
    // MARK: - Métodos
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let foto = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        picker.dismiss(animated: true, completion: nil)
    }

}
