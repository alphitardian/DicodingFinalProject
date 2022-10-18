//
//  GameDetailView.swift
//  DicodingFinalProject
//
//  Created by Ardian Pramudya Alphita on 13/10/22.
//

import SwiftUI

struct GameDetailView: View {
    
    var selectedGame: Detail?
    
    var body: some View {
        VStack {
            RemoteImageView(url: selectedGame?.backgroundImage)
                .frame(height: 200)
                .aspectRatio(contentMode: .fill)

            HStack {
                VStack(alignment: .leading) {
                    Text(selectedGame?.name ?? "Unknown")
                        .bold()
                        .font(.title)
                    Text(selectedGame?.releasedDate ?? "2021-09-20")
                        .padding(.bottom)
                }
                Spacer()
                Text(String(format: "%.2f", selectedGame?.rating ?? 0.0))
                    .bold()
                    .font(.title2)
                    .foregroundColor(.white)
                    .background {
                        Circle()
                            .foregroundColor(.blue)
                            .frame(width: 64, height: 64)
                    }
                    .padding()
            }
            .padding()
            Text(selectedGame?.description.htmlToString ?? "Empty description")
                .multilineTextAlignment(.leading)
                .padding()
        }
    }
}

struct GameDetailView_Previews: PreviewProvider {
    static var previews: some View {
        GameDetailView()
    }
}
