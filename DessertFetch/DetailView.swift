//
//  DetailView.swift
//  DessertFetch
//
//  Created by Atharva Kulkarni on 03/04/24.
//

import SwiftUI

struct DetailView: View {
    
    @ObservedObject var viewModel = DessertDetailViewModel()
    var meal: Meal
   
    @Environment(\.colorScheme) var colorScheme
    
    let headingColor = Color.blue
    let lightModeRecipeBackground = Color(UIColor.systemGray6)
    let darkModeRecipeBackground = Color(UIColor.systemGray)

    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                
                mealImage
                    .padding(.vertical, 10)
                
                mealTitle
                
                if let area = viewModel.meal?.area, !area.isEmpty {
                    DetailRow(label: "Country of Origin", content: area)
                }
                
                Divider().background(Color.secondary.opacity(0.5))
                
                ingredientsAndMeasurementsSection
                
                Divider().background(Color.secondary.opacity(0.5))
                
                recipeInstructionsSection
            }
            .padding(.horizontal)
            .foregroundColor(.primary)
        }
        .navigationTitle(meal.strMeal)
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await viewModel.fetchMealDetails(byId: meal.idMeal)
        }
    }

    private var mealTitle: some View {
        Text(meal.strMeal.capitalized)
            .font(.custom("Georgia", size: 24))
            .italic()
            .foregroundColor(headingColor)
            .padding(.bottom, 5)
            .frame(maxWidth: .infinity, alignment: .center)
    }

    private var mealImage: some View {
        AsyncImage(url: viewModel.meal?.imageURL) { phase in
            switch phase {
            case .empty:
                ProgressView()
            case .success(let image):
                image.resizable()
                     .aspectRatio(contentMode: .fit) 
                     .clipped()
            case .failure:
                Image(systemName: "photo")
                    .foregroundColor(.secondary)
                    .frame(width: 300, height: 300)
            @unknown default:
                EmptyView()
            }
        }
        
        .frame(maxWidth: .infinity)
    }
    
    private var ingredientsAndMeasurementsSection: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text("Ingredients and Measurements:")
                .font(.headline)
                .foregroundColor(headingColor)
                .bold()
            
            ForEach(Array(viewModel.meal?.ingredientsAndMeasurements.enumerated() ?? [].enumerated()), id: \.offset) { _, ingredientMeasurement in
                HStack {
                    Circle()
                        .frame(width: 5, height: 5)
                        .foregroundColor(.accentColor)
                    Text("\(ingredientMeasurement.ingredient):")
                        .fontWeight(.semibold)
                    Text(ingredientMeasurement.measurement)
                }
                .padding(.vertical, 2)
            }
        }
    }
    
    private var recipeInstructionsSection: some View {
        VStack(alignment: .leading, spacing: 5) {
            if let instructions = viewModel.meal?.instructions, !instructions.isEmpty {
                Text("Recipe:")
                    .font(.headline)
                    .foregroundColor(.primary) // or use your custom heading color
                    .bold()
                    .padding(.vertical, 2)

                Text(instructions)
                    .padding([.top, .bottom])
                    .background(recipeBackground) // Use the computed background color
                    .cornerRadius(10)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
    }
    
    private var recipeBackground: Color {
         colorScheme == .dark ? darkModeRecipeBackground : lightModeRecipeBackground
     }
    
}

struct DetailRow: View {
    var label: String
    var content: String

    var body: some View {
        HStack {
            Text("\(label):")
                .bold()
            Text(content)
            Spacer()
        }
        .font(.subheadline)
        .padding(.vertical, 1)
        .foregroundColor(.secondary)
    }
}
