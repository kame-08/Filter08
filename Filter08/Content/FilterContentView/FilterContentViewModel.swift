//
//  FilterContentViewModel.swift
//  Filter08
//
//  Created by Ryo on 2022/06/28.
//

import SwiftUI
import Combine

final class FilterContentViewModel: ObservableObject {
    enum Inputs {
        case onAppear
        //(カメラorフォトライブラリーか)
        case tappedActionSheet(selectType: UIImagePickerController.SourceType)
    }
    
    @Published var image: UIImage?
    //UIKitのImage
    @Published var filterdImage: UIImage?
    
    @Published var isShowActionSheet = false
    @Published var isShowImagePickerView = false
    
    @Published var selectedSourceType: UIImagePickerController.SourceType = .camera
    
    //Combineを実行するためのCancellable
    var cancellables:[Cancellable] = []
    
    init() {
        let imageCancellable = $image.sink { [weak self] uiimage in
            guard let self = self, let uiimage = uiimage else{return}
            
            self.filterdImage = uiimage
            
        }
        
        cancellables.append(imageCancellable)
    }
    
    
    func apply(_ inputs: Inputs) {
        switch inputs {
        case .onAppear:
            if image == nil {
                //アクションシートの表示
                isShowActionSheet = true
            }
            
        case .tappedActionSheet(let sourceType):
            
            selectedSourceType = sourceType
            isShowImagePickerView = true
            
        }
    }
}
