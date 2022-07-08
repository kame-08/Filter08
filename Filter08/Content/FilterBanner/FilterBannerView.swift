//
//  FilterBannerView.swift
//  Filter08
//
//  Created by Ryo on 2022/06/28.
//

import SwiftUI

//部品を組み合わせてFilterBannerViewを作る
struct FilterBannerView: View {
    //親Viewが持つ
    @State var selectedFilter: FilterType? = nil
    @Binding var isShowBanner:Bool
    var body: some View {
        GeometryReader{geometry in
            VStack {
                Spacer()
                VStack{
                    FilterTitleView(title: selectedFilter?.rawValue)
                    FilterIconContainerView(selectedFilter: $selectedFilter)
                    FilterButtonContainerView(isShowBanner: $isShowBanner, selectedFilter: $selectedFilter)
                    
                }
                .background(Color.black.opacity(0.8))
                //白文字
                .foregroundColor(.white)
                .offset(x:0, y: isShowBanner ? 0 : geometry.size.height)
            }
        }
    }
}

struct FilterBannerView_Previews: PreviewProvider {
    static var previews: some View {
        FilterBannerView(isShowBanner: .constant(true))
        //        FilterImage(filterType: .gaussianBlur)
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
    var filterType: FilterType//自分自身のFilterType
    @Binding var selectedFilter: FilterType?//もしかしたら他のFilterTypeかもしれない
    let uiImage: UIImage = UIImage(named: "pig")!
    var body: some View {
        Button {
            selectedFilter = filterType
        } label: {
            image?
                .resizable()
                .aspectRatio(contentMode: .fit)
                .scaledToFit()
        }
        .frame(width: 70, height: 70)
        //選択されているときは太枠
        .border(Color.primary,width: selectedFilter == filterType ? 4:0)
        .border(Color.white)
        .onAppear{
            //フィルターをかける
            if let outputImage = filterType.filter(inputImage: uiImage){
                self.image = Image(uiImage: outputImage)
            }
        }
    }
}

struct FilterIconContainerView: View {
    @Binding var selectedFilter: FilterType?
    var body: some View {
        //スクロールバー非表示
        ScrollView(.horizontal,showsIndicators: false){
            HStack{
                //アイコンを並べる
                //モザイク
                FilterImage(filterType: .pixellate,
                            selectedFilter: $selectedFilter)
                //セピア
                FilterImage(filterType: .sepiaTone,
                            selectedFilter: $selectedFilter)
                //シャープ
                FilterImage(filterType: .sharpenLuminance,
                            selectedFilter: $selectedFilter)
                //モノクロ
                FilterImage(filterType: .photoEffectMono,
                            selectedFilter: $selectedFilter)
                //ぼかし
                FilterImage(filterType: .gaussianBlur,
                            selectedFilter: $selectedFilter)
            }
            //左右にpadding
            //padding([.leading,.trailing],16)でも可
            .padding(.horizontal, 16.0)
        }
    }
}

struct FilterButtonContainerView:View {
    @Binding var isShowBanner: Bool
    @Binding var selectedFilter: FilterType?
    var body: some View {
        HStack{
            Button {
                //閉じる処理
                withAnimation {
                    isShowBanner = false
                    selectedFilter = nil
                }
                
            } label: {
                Image(systemName: "xmark")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 20)
                    .padding()
            }
            
            Spacer()
            Button {
                //確定する処理
                isShowBanner = false
                selectedFilter = nil
            } label: {
                Image(systemName: "checkmark")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 20)
                    .padding()
            }
            
        }
    }
}
