import SwiftUI

struct OnboardingView: View {
    @Binding var isOnboardingCompleted: Bool
    @State private var currentPage = 0
    
    var body: some View {
        ZStack {
            Theme.background
                .ignoresSafeArea()
            
            TabView(selection: $currentPage) {
                ForEach(OnboardingPage.pages.indices, id: \.self) { index in
                    OnboardingPageView(
                        page: OnboardingPage.pages[index],
                        isLastPage: index == OnboardingPage.pages.count - 1,
                        currentPage: $currentPage,
                        onCompletion: completeOnboarding
                    )
                    .tag(index)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            
            // Custom Page Control
            HStack(spacing: 8) {
                ForEach(0..<OnboardingPage.pages.count, id: \.self) { index in
                    Circle()
                        .fill(index == currentPage ? Theme.primary : Theme.primary.opacity(0.3))
                        .frame(width: 8, height: 8)
                        .scaleEffect(index == currentPage ? 1.2 : 1.0)
                        .animation(.spring(response: 0.3), value: currentPage)
                }
            }
            .padding()
            .offset(y: 160)
        }
    }
    
    private func completeOnboarding() {
        withAnimation {
            isOnboardingCompleted = true
        }
    }
}

struct OnboardingPageView: View {
    let page: OnboardingPage
    let isLastPage: Bool
    @Binding var currentPage: Int
    let onCompletion: () -> Void
    
    @State private var isAnimating = false
    
    var body: some View {
        VStack(spacing: 32) {
            Spacer()
            
            Image(systemName: page.image)
                .font(.system(size: 120))
                .foregroundStyle(Theme.primary)
                .padding()
                .scaleEffect(isAnimating ? 1 : 0.5)
                .opacity(isAnimating ? 1 : 0)
            
            VStack(spacing: 16) {
                Text(page.title)
                    .font(.title.bold())
                    .multilineTextAlignment(.center)
                    .foregroundStyle(Theme.text)
                    .offset(y: isAnimating ? 0 : 20)
                    .opacity(isAnimating ? 1 : 0)
                
                Text(page.description)
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .foregroundStyle(Theme.secondaryText)
                    .padding(.horizontal, 32)
                    .offset(y: isAnimating ? 0 : 20)
                    .opacity(isAnimating ? 1 : 0)
            }
            
            Spacer()
            
            Button {
                if isLastPage {
                    onCompletion()
                } else {
                    withAnimation {
                        currentPage += 1
                    }
                }
            } label: {
                Text(isLastPage ? "Get Started" : "Next")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background(Theme.primary)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .padding(.horizontal, 32)
            }
            .offset(y: isAnimating ? 0 : 20)
            .opacity(isAnimating ? 1 : 0)
            
            Spacer()
                .frame(height: 64)
        }
        .onAppear {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.2)) {
                isAnimating = true
            }
        }
        .onDisappear {
            isAnimating = false
        }
    }
}