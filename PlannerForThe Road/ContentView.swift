import SwiftUI

struct ContentView: View {
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false
    @State private var store = AppDetails()
    
    var body: some View {
        if hasCompletedOnboarding {
            RootTabView()
                .environment(store)
                .preferredColorScheme(.dark)
        } else {
            OnboardingView()
                .preferredColorScheme(.dark)
        }
    }
}

#Preview {
    ContentView()
}
