import SwiftUI

struct OnboardingPage: Identifiable {
    let id = UUID()
    let image: String
    let title: String
    let description: String
    
    static let pages: [OnboardingPage] = [
        OnboardingPage(
            image: "film",
            title: "Track Your Movies",
            description: "Keep a personal journal of all the movies you watch. Add titles, dates, and ratings to build your movie collection."
        ),
        OnboardingPage(
            image: "star.bubble",
            title: "Share Your Thoughts",
            description: "Write down your thoughts, favorite scenes, and memorable quotes. Create a meaningful record of your movie experiences."
        ),
        OnboardingPage(
            image: "chart.bar",
            title: "Track Your Stats",
            description: "See your watching patterns, favorite genres, and rating statistics. Get insights into your movie preferences."
        )
    ]
}