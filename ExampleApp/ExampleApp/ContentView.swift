//
//  ContentView.swift
//  ExampleApp
//
//  Created by Raymond Donkemezuo on 7/12/25.
//

import SwiftUI
import AutoSearchField

struct ContentView: View {
    var viewModel = ViewModel()
    var body: some View {
        VStack {
            Text("Auto Search Field Demo App")
                .font(.headline)
                .padding(.top, 20)
            AutoSearchField<String>(
                viewModel: AutoSearchFieldViewModel<String>(
                    allEntries: viewModel.searchableWords,
                    placeHolder: "Search something...",
                    isCaseSensitive: false
                )
            )
            .padding([.top, .horizontal], 20)
            Spacer()
        }
    }
    
    final class ViewModel: Observable {
        var searchedWord = ""
        let searchableWords = [
            "apple",
            "amazon",
            "android",
            "airpods",
            "adidas",
            "abstract art",
            "algebra help",
            "audi cars",
            "avocado recipes",
            "anime streaming",
            "bitcoin",
            "best laptops",
            "boston weather",
            "barcelona travel guide",
            "banana bread",
            "berlin wall history",
            "basketball rules",
            "burger places near me",
            "cheap flights",
            "coding bootcamps",
            "car maintenance tips",
            "c++ tutorial",
            "cooking classes",
            "coca cola",
            "cloud storage options",
            "coffee shops nearby",
            "dell monitors",
            "dog breeds",
            "daily affirmations",
            "design inspiration",
            "discount codes",
            "electric cars",
            "elon musk",
            "early retirement plan",
            "exercise routines",
            "english grammar",
            "event venues",
            "europe travel checklist",
            "fifa highlights",
            "funny cat videos",
            "flights to lagos",
            "french recipes",
            "finance podcasts",
            "football scores",
            "google maps",
            "graphic design",
            "guitar lessons",
            "gardening tips",
            "gaming laptops",
            "good morning quotes",
            "harvard courses",
            "how to start a blog",
            "health insurance",
            "hiking trails near me",
            "hotels in new york",
            "history of nigeria",
            "how to make money online",
            "iphone 15",
            "ice cream flavors",
            "interview questions",
            "investment tips",
            "jackets for winter",
            "javascript tutorial",
            "jollof rice recipe",
            "jeep wrangler",
            "job interview tips",
            "karaoke songs",
            "kanye west",
            "kitchen appliances",
            "keto snacks",
            "london attractions",
            "linkedin profile tips",
            "laptop bags",
            "latest movies",
            "lego sets",
            "macbook pro",
            "mango health benefits",
            "microsoft excel",
            "minimalist design",
            "music festivals",
            "news headlines",
            "nintendo switch",
            "netflix series",
            "nike sneakers",
            "nba draft",
            "online courses",
            "open source projects",
            "offices for rent",
            "olympics schedule",
            "pizza delivery",
            "python tutorial",
            "paris weather",
            "project management",
            "quotes on success",
            "quran verses",
            "quick lunch ideas",
            "remote jobs",
            "resume builder",
            "rugby rules",
            "restaurant reservations"
        ]

    }
}

#Preview {
    ContentView()
}
