//
//  GameListView.swift
//  DicodingFinalProject
//
//  Created by Ardian Pramudya Alphita on 13/10/22.
//

import SwiftUI

struct GameListView: View {
    
    @ObservedObject var viewModel: DetailViewModel
    var gameId: Int
    
    @State private var selectedItem: Detail?
    
    var body: some View {
        HStack {
            RemoteImageView(url: selectedItem?.backgroundImage)
                .frame(width: 72, height: 72)
                .aspectRatio(contentMode: .fill)
                .cornerRadius(20)
            
            VStack(alignment: .leading) {
                Text(selectedItem?.name ?? "Game Title")
                    .bold()
                    .font(.title2)
                    .lineLimit(1)
                Text(selectedItem?.releasedDate ?? "Released Date")
            }
            .padding()
            Spacer()
            Text(String(format: "%.2f", selectedItem?.rating ?? 0.0))
                .bold()
                .font(.title3)
                .foregroundColor(.white)
                .background {
                    Circle()
                        .foregroundColor(.blue)
                        .frame(width: 54, height: 54)
                }
                .padding()
        }
        .task {
            selectedItem = await viewModel.getDetail(
                id: gameId,
                selectedFilter: .games
            )
        }
    }
}

struct GameListView_Previews: PreviewProvider {
    static let viewModel = DetailViewModel()
    static var previews: some View {
        GameListView(viewModel: viewModel, gameId: 304)
            .previewLayout(.sizeThatFits)
    }
}
