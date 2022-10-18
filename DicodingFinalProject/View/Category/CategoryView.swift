//
//  CategoryView.swift
//  DicodingFinalProject
//
//  Created by Ardian Pramudya Alphita on 13/10/22.
//

import SwiftUI

struct CategoryView: View {
    
    var data: [GameFilter]
    var selectedFilter: GameFilter
    var onItemTap: (_ filter: GameFilter) -> Void
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color("MainColor").ignoresSafeArea()
                List {
                    ForEach(data, id: \.rawValue) { data in
                        HStack {
                            Text(data.rawValue)
                            Spacer()
                            if data == selectedFilter {
                                Image(systemName: "checkmark")
                            }
                        }
                        .onTapGesture {
                            onItemTap(data)
                        }
                        .listRowBackground(Color("MainColor"))
                        .foregroundColor(.white)
                    }
                }
                .listStyle(.plain)
                .scrollContentBackground(.hidden)
                .navigationTitle("Category")
                .navigationBarTitleDisplayMode(.inline)
            }
        }
    }
}

struct CategoryView_Previews: PreviewProvider {
    static var previews: some View {
        CategoryView(
            data: GameFilter.allCases,
            selectedFilter: .games
        ) { filter in
            //
        }
    }
}
