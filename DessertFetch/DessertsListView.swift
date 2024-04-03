//
//  DessertsListView.swift
//  DessertFetch
//
//  Created by Atharva Kulkarni on 03/04/24.
//

import SwiftUI

struct DessertsListView: View {
    
    @StateObject var dessertsVM = DessertsViewModel()

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(spacing: 5) {
                    ForEach(dessertsVM.DessertsArray.sorted(by: { $0.strMeal < $1.strMeal }), id: \.self) { dessert in
                        NavigationLink(destination: DetailView(meal: dessert)) {
                            dessertRow(for: dessert)
                        }
                        .buttonStyle(PlainButtonStyle())
                        .background(Color(UIColor.secondarySystemGroupedBackground))
                        .cornerRadius(10)
                        .shadow(color: .gray, radius: 2, x: 0, y: 2)
                        .scaleEffect(0.95)
                        .animation(.easeInOut, value: dessertsVM.DessertsArray)
                    }
                }
                .padding(.top)
            }
            .navigationTitle("Desserts")
            .background(Color(UIColor.systemGroupedBackground)) 
        }
        .task {
            await dessertsVM.getData()
        }
    }

    private func dessertRow(for dessert: Meal) -> some View {
        HStack {
            dessertImage(for: dessert.strMealThumb)
            Text(dessert.strMeal.capitalized)
                .font(.title3)
                .foregroundColor(.primary)
                .padding(.leading, 10)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private func dessertImage(for url: URL?) -> some View {
        AsyncImage(url: url) { imagePhase in
            switch imagePhase {
            case .empty, .failure:
                placeholderImage
            case .success(let image):
                image.resizable().aspectRatio(contentMode: .fill)
            @unknown default:
                EmptyView()
            }
        }
        .frame(width: 60, height: 60)
        .cornerRadius(10)
    }

    private var placeholderImage: some View {
        Image(systemName: "photo")
            .resizable()
            .scaledToFit()
            .frame(width: 60, height: 60)
            .cornerRadius(10)
            .foregroundColor(.gray)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        DessertsListView()
    }
}
