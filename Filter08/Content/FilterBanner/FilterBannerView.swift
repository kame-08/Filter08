//
//  FilterBannerView.swift
//  Filter08
//
//  Created by Ryo on 2022/06/28.
//

import SwiftUI

struct FilterBannerView: View {
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct FilterBannerView_Previews: PreviewProvider {
    static var previews: some View {
        FilterImage(filterType: .gaussianBlur)
    }
}

struct FilterTitleView: View {
    let title: String?
    var body: some View {
        Text("\(title ?? "フィルターを選択")")
            .font(.title)
            .fontWeight(.bold)
            .padding(.top)
    }
}

struct FilterImage: View {
    //フィルターのかかった画像を作る
    @State private var image: Image?
    //何のフィルターか
    let filterType : FilterType
    
    let uiImage: UIImage = UIImage(named: "pig")!
    var body: some View {
        Button {
            //TODO: -処理
        } label: {
            image?
                .resizable()
                .aspectRatio(contentMode: .fit)
                .scaledToFit()
        }
        .frame(width: 70, height: 70)
        .border(Color.white)
        .onAppear{
            //フィルターをかける
            if let outputImage = filterType.filter(inputImage: uiImage){
                self.image = Image(uiImage: outputImage)
            }
        }
    }
}
