//
//  GeneralDetailView.swift
//  DicodingFinalProject
//
//  Created by Ardian Pramudya Alphita on 13/10/22.
//

import SwiftUI

struct GeneralDetailView: View {
    
    @ObservedObject var viewModel: DetailViewModel
    
    var selectedItem: Detail?
    var topGames: [Int]
    
    var body: some View {
        VStack {
            RemoteImageView(url: selectedItem?.backgroundImage)
                .frame(height: 200)
                .aspectRatio(contentMode: .fill)
            
            VStack(alignment: .leading) {
                HStack { Spacer() }
                Text(selectedItem?.name ?? "Unknown")
                    .bold()
                    .font(.title)
                    .padding(.bottom, 2)
                Text("Total Games")
                Text("\(selectedItem?.gamesCount ?? 0)")
                    .bold()
                    .font(.title3)
                    .padding(.bottom, 4)
                Text(selectedItem?.description.htmlToString ?? "Empty description")
                    .multilineTextAlignment(.leading)
            }
            .padding()
            
            ScrollView {
                ForEach(topGames, id: \.self) { item in
                    GameListView(viewModel: viewModel, gameId: item)
                }
            }
            .frame(height: 500)
            .padding(.horizontal)
        }
    }
}

struct GeneralDetailView_Previews: PreviewProvider {
    static let viewModel = DetailViewModel()
    static var previews: some View {
        GeneralDetailView(viewModel: viewModel, topGames: [305])
    }
}
