//
//  FilterContentView.swift
//  Filter08
//
//  Created by Ryo on 2022/06/28.
//

import SwiftUI

struct FilterContentView: View {
    
    @StateObject private var viewModel = FilterContentViewModel()
    
    var body: some View {
        NavigationView {
            ZStack {
                if let filterdImage = viewModel.filterdImage {
                    Image(uiImage: filterdImage)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .onTapGesture {
                            withAnimation {
                                viewModel.isShowBanner.toggle()
                            }
                        }
                } else {
                    EmptyView()
                }
                FilterBannerView(isShowBanner: $viewModel.isShowBanner, applyingFilter: $viewModel.applyingFilter)
            }
            .navigationTitle("Filter App")
            .navigationBarItems(trailing: HStack {
                Button {
                    viewModel.apply(.tappedSaveIcon)
                } label: {
                    Image(systemName: "square.and.arrow.down")
                }
                Button {} label: {
                    Image(systemName: "photo")
                }
            })
            .onAppear(){
                //画面表示時の処理
                viewModel.apply(.onAppear)
            }
            .actionSheet(isPresented: $viewModel.isShowActionSheet) {
                actionSheet
            }
            
            .sheet(isPresented: $viewModel.isShowImagePickerView) {
                ImagePicker(isShown: $viewModel.isShowImagePickerView, image: $viewModel.image, sourceType: viewModel.selectedSourceType)
            }
            .alert( isPresented: $viewModel.isShowAlert) {
                Alert(title: Text(viewModel.alertTitle))
            }
        }
    
    }
    
    var actionSheet: ActionSheet {
        var buttons: [ActionSheet.Button] = []
        //カメラ使えるか確認
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            //利用できる場合はボタン表示
            let cameraButton = ActionSheet.Button.default(Text("写真を撮る")){
                viewModel.apply(.tappedActionSheet(selectType: .camera))
            }
            buttons.append(cameraButton)
        }
        
        //フォトライブラリー使えるか確認
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            //利用できる場合はボタン表示
            let photoLibraryButton = ActionSheet.Button.default(Text("アルバムから選択")){
                viewModel.apply(.tappedActionSheet(selectType: .photoLibrary))
            }
            buttons.append(photoLibraryButton)
        }
        //キャンセルボタン
        let cancelButton = ActionSheet.Button.cancel(Text("キャンセル"))
        buttons.append(cancelButton)
        
        let actionSheat = ActionSheet(title: Text("画像選択"),message: nil,buttons: buttons)
        
        return actionSheat
        
    }
}

struct FilterContentView_Previews: PreviewProvider {
    static var previews: some View {
        FilterContentView()
    }
}
