//
//  DessertDetailViewModel.swift
//  DessertFetch
//
//  Created by Atharva Kulkarni on 03/04/24.
//

import Foundation

@MainActor
class DessertDetailViewModel: ObservableObject {
    
    @Published var meal: MealDetails?
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    struct MealListResponse: Codable {
        let meals: [MealDetails]?
    }
    
    func fetchMealDetails(byId id: String) async {
        guard let url = URL(string: "https://www.themealdb.com/api/json/v1/1/lookup.php?i=\(id)") else {
            errorMessage = "Invalid URL"
            return
        }
        
        isLoading = true
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            guard let httpResponse = response as? HTTPURLResponse,
                  httpResponse.statusCode == 200 else {
                errorMessage = "Server error"
                return
            }
            
            let mealResponse = try JSONDecoder().decode(MealListResponse.self, from: data)
            if let fetchedMeal = mealResponse.meals?.first {
                self.meal = fetchedMeal
            } else {
                errorMessage = "Error: Unable to fetch meal details."
            }
        } catch {
            errorMessage = "Network error: \(error.localizedDescription)"
        }
        isLoading = false
    }
}

