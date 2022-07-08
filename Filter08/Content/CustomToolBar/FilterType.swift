//
//  FilterType.swift
//  Filter08
//
//  Created by Ryo on 2022/07/05.
//

import UIKit
import CoreImage
import CoreImage.CIFilterBuiltins

enum FilterType: String {
    case pixellate = "モザイク"
    case sepiaTone = "セピア"
    case sharpenLuminance = "シャープ"
    case photoEffectMono = "モノクロ"
    case gaussianBlur = "ブラー"
    
    private func makeFilter(inputImage: CIImage?) -> CIFilter {
        //自分自身のインスタンスの値
        switch self{
            case .pixellate:
                let currentFilter = CIFilter.pixellate()
                currentFilter.inputImage = inputImage
                //モザイクのピクセルサイズ
                currentFilter.scale = 40
                return currentFilter
            case .sepiaTone:
                let currentFilter = CIFilter.sepiaTone()
                currentFilter.inputImage = inputImage
                //セピアの強さ(1が最大)
                currentFilter.intensity = 1
                return currentFilter
            case .sharpenLuminance:
                let currentFilter = CIFilter.sharpenLuminance()
                currentFilter.inputImage = inputImage
                currentFilter.sharpness = 1
                //シャープの半径
                currentFilter.radius = 100
                return currentFilter
            case .photoEffectMono:
                let currentFilter = CIFilter.photoEffectMono()
                currentFilter.inputImage = inputImage
                return currentFilter
            case.gaussianBlur:
                let currentFilter = CIFilter.gaussianBlur()
                currentFilter.inputImage = inputImage
                //ぼかしの半径(画像の大きさによる)
                currentFilter.radius = 10
                return currentFilter
        }
    }
    
    //UIImageを受け取って、加工したUIImageを返すメソッド
    func filter(inputImage: UIImage) -> UIImage? {
        let beginImage = CIImage(image: inputImage)
        let context = CIContext()
        let currentFilter = makeFilter(inputImage: beginImage)
        //フィルター加工されたCIImageを取り出す
        guard let outputImage = currentFilter.outputImage else { return nil }
        //CIImageからCGImageを取得する
        if let cgimage = context.createCGImage(outputImage, from: outputImage.extent){
            //うまく取り出せなかったらCGImageからUIImageを作成する
            //CGImageは向きが消失しているので、元のUIImageから向き情報を使ってUIImageを作成する
            return UIImage(cgImage: cgimage, scale: 0,orientation: inputImage.imageOrientation)
        } else {
            return nil
        }
    }
}

