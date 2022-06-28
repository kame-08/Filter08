//
//  FilterContentViewModel.swift
//  Filter08
//
//  Created by Ryo on 2022/06/28.
//

import SwiftUI

final class FilterContentViewModel: ObservableObject {
    enum Inputs {
        case onAppear
        //(カメラorフォトライブラリーか)
        case tappedActionSheet(selectType: UIImagePickerController.SourceType)
    }
    
    @Published var image: UIImage?
    @Published var isShowActionSheet = false
    @Published var isShowImagePickerView = false
    
    @Published var selectedSourceType: UIImagePickerController.SourceType = .camera
    
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
