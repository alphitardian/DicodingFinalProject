//
//  RemoteImageView.swift
//  DicodingFinalProject
//
//  Created by Ardian Pramudya Alphita on 17/10/22.
//

import SwiftUI
import Kingfisher

struct RemoteImageView: View {
    
    var url: URL?
    
    var body: some View {
        KFImage.url(url ?? URL(string: "https://storage.googleapis.com/proudcity/mebanenc/uploads/2021/03/placeholder-image.png"))
            .placeholder { progress in
                ProgressView().tint(.white)
            }
            .cacheMemoryOnly()
            .fade(duration: 0.25)
            .resizable()
    }
}

struct RemoteImageView_Previews: PreviewProvider {
    static var previews: some View {
        RemoteImageView()
    }
}
