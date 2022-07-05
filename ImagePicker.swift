//
//  ImagePicker.swift
//  Filter08
//
//  Created by Ryo on 2022/07/01.
//

import SwiftUI

struct ImagePicker {
    @Binding var isShown:Bool
    @Binding var image:UIImage?
    
    var sourceType:UIImagePickerController.SourceType
}

extension ImagePicker: UIViewControllerRepresentable {
    typealias UIViewControllerType = UIImagePickerController
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {
        //UIImagePickerControllerは参照型のクラス
        let imagePicker = UIImagePickerController()
        
        //UIViewControllerにはDelegateがある
        imagePicker.delegate = context.coordinator
        
        return imagePicker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {
        
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
    
}

//Coordinator
final class Coordinator:NSObject,UINavigationControllerDelegate, UIImagePickerControllerDelegate{
    
    let parent: ImagePicker
    
    init(parent: ImagePicker){
        self.parent = parent
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let originalImage = info[.originalImage] as? UIImage else {return}
        parent.image = originalImage
        parent.isShown = false
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        parent.isShown = false
    }
    
}
