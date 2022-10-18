//
//  BrowseGridView.swift
//  DicodingFinalProject
//
//  Created by Ardian Pramudya Alphita on 11/10/22.
//

import SwiftUI
import Kingfisher

struct BrowseGridView: View {
    
    var game: Game?
    var general: General?
    var state: GameFilter = .genres
    
    var body: some View {
        VStack {
            switch state {
            case .games:
                GameGridView(game: game)
            default:
                GeneralGridView(general: general)
            }
        }
    }
}

struct GameGridView: View {
    
    var game: Game?
    
    var body: some View {
        VStack {
            RemoteImageView(url: game?.backgroundImage)
                .frame(width: UIScreen.main.bounds.width / 2 - 18, height: 100)
                .aspectRatio(contentMode: .fill)
                .cornerRadius(20)
            HStack {
                VStack(alignment: .leading) {
                    Text(game?.name ?? "Unknown")
                        .bold()
                        .font(.title3)
                        .lineLimit(1)
                        .padding(.bottom, 4)
                    Text("Released Date")
                        .font(.callout)
                    Text(game?.releaseDate ?? "2021-01-01")
                        .italic()
                        .font(.callout)
                }
                Text(String(format: "%.2f", game?.rating ?? 0.0))
                    .bold()
                    .font(.title2)
                    .foregroundColor(.white)
                    .background {
                        Circle()
                            .foregroundColor(.gray)
                            .frame(width: 50, height: 50)
                    }
            }
            .foregroundColor(.white)
        }
    }
}

struct GeneralGridView: View {
    
    var general: General?
    
    var body: some View {
        VStack(alignment: .leading) {
            RemoteImageView(url: general?.backgroundImage)
                .frame(width: UIScreen.main.bounds.width / 2 - 18, height: 100)
                .aspectRatio(contentMode: .fill)
                .cornerRadius(20)
            Text(general?.name ?? "Unknown")
                .bold()
                .font(.title)
                .lineLimit(1)
                .padding(.bottom, 4)
            Text("Game count")
                .font(.callout)
            Text("\(general?.gamesCount ?? 0)")
                .bold()
        }
        .foregroundColor(.white)
    }
}

struct BrowseGridView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            BrowseGridView()
            
            GameGridView()
        }
    }
}
