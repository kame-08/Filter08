//
//  FilterContentView.swift
//  Filter08
//
//  Created by Ryo on 2022/06/28.
//

import SwiftUI

struct FilterContentView: View {
    //UIKitのImage
    @State private var filterdImage: UIImage?
    @StateObject private var ViewModel = FilterContentViewModel()
    var body: some View {
        NavigationView {
            ZStack {
                if let filterdImage = filterdImage {
                    Image(uiImage: filterdImage)
                } else {
                    EmptyView()
                }
                FilterBannerView()
            }
            .navigationTitle("Filter App")
            .navigationBarItems(trailing: HStack {
                Button {} label: {
                    Image(systemName: "square.and.arrow.down")
                }
                Button {} label: {
                    Image(systemName: "photo")
                }
            })
            .onAppear(){
                //画面表示時の処理
                ViewModel.apply(.onAppear)
            }
            .actionSheet(isPresented: $ViewModel.isShowActionSheet) {
                actiomSheet
            }
            
        }
        
    }
    
    var actiomSheet: ActionSheet {
        var buttons: [ActionSheet.Button] = []
        //カメラ使えるか確認
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            //利用できる場合はボタン表示
            let cameraButton = ActionSheet.Button.default(Text("写真を撮る")){
                ViewModel.apply(.tappedActionSheet(selectType: .camera))
            }
            buttons.append(cameraButton)
        }
        
        //フォトライブラリー使えるか確認
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            //利用できる場合はボタン表示
            let photoLibraryButton = ActionSheet.Button.default(Text("アルバムから選択")){
                ViewModel.apply(.tappedActionSheet(selectType: .photoLibrary))
            }
            buttons.append(photoLibraryButton)
        }
        //キャンセルボタン
        let canselButton = ActionSheet.Button.cancel(Text("キャンセル"))
        buttons.append(canselButton)
        
        let actionSheat = ActionSheet(title: Text("画像選択"),message: nil,buttons: buttons)
        
        return actionSheat
        
    }
}

struct FilterContentView_Previews: PreviewProvider {
    static var previews: some View {
        FilterContentView()
    }
}
