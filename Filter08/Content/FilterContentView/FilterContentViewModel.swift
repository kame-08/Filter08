//
//  FilterContentViewModel.swift
//  Filter08
//
//  Created by Ryo on 2022/06/28.
//

import SwiftUI
import Combine

final class FilterContentViewModel: NSObject, ObservableObject {
    enum Inputs {
        case onAppear
        //(カメラorフォトライブラリーか)
        case tappedActionSheet(selectType: UIImagePickerController.SourceType)
        
        case tappedSaveIcon
    }
    
    @Published var image: UIImage?
    //UIKitのImage
    @Published var filterdImage: UIImage?
    
    @Published var isShowActionSheet = false
    @Published var isShowImagePickerView = false
    
    @Published var selectedSourceType: UIImagePickerController.SourceType = .camera
    
    //フィルターバナー表示用フラグ
    @Published var isShowBanner = false
    
    //フィルターを適応するFilterType
    @Published var applyingFilter: FilterType? = nil
    
    //Combineを実行するためのCancellable
    var cancellables:[Cancellable] = []
    
    var alertTitle: String = ""
    //アラートを表示するためのフラグ
    @Published var isShowAlert = false
    
    override init() {
        super.init()
        let imageCancellable = $image.sink { [weak self] uiimage in
            guard let self = self, let uiimage = uiimage else{return}
            
            self.filterdImage = uiimage
            
        }
        //applyingFilterが更新されたら?
        let filterCancellable = $applyingFilter.sink { [weak self] FilterType in
            guard let self = self,
                  let filterType = FilterType,
                  let image = self.image else {
                return
            }
            //画像加工
            guard let fillterdUIImage = self.updataImage(with: image, type: filterType) else {return}
            self.filterdImage = fillterdUIImage
        }
        
        cancellables.append(imageCancellable)
        cancellables.append(filterCancellable)
    }
    
    private func updataImage(with image: UIImage, type filter: FilterType) -> UIImage? {
        return filter.filter(inputImage: image)
    }
    
    
    func apply(_ inputs: Inputs) {
        switch inputs {
            case .onAppear:
                if image == nil {
                    //アクションシートの表示
                    isShowActionSheet = true
                }
                
            case .tappedActionSheet(let sourceType):
                //フォトライブラリを起動する
                selectedSourceType = sourceType
                isShowImagePickerView = true
                
            case .tappedSaveIcon:
                //画像を保存
                UIImageWriteToSavedPhotosAlbum(filterdImage!, self, #selector(imageSaveCompletion(_:didFinishSaveingWithError:contextInfo:)), nil)
                
        }
    }
    
    @objc func imageSaveCompletion(_ image: UIImage,didFinishSaveingWithError error: Error?,contextInfo: UnsafeRawPointer) {
        alertTitle = error == nil ? "画像が保存されました" : error?.localizedDescription ?? ""
        isShowAlert = true
    }
}
