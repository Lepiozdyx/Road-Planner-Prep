import SwiftUI

private struct OnboardingPage {
    let image: String
    let title: String
    let description: String
}

private let pages: [OnboardingPage] = [
    OnboardingPage(
        image: "bgimage1",
        title: "Plan your road in\n5 minutes",
        description: "Create detailed trip routes\nwith stops and time estimates"
    ),
    OnboardingPage(
        image: "bgimage2",
        title: "Add stops &\ndiscover beautiful places",
        description: "Find amazing locations along\nyour route with ratings and photos"
    ),
    OnboardingPage(
        image: "bgimage3",
        title: "Smart packing\nby trip type",
        description: "Get customized checklists based\non your destination and travel style"
    ),
    OnboardingPage(
        image: "bgimage4",
        title: "Track your\ntravel progress",
        description: "See your journey statistics\nand memorable places"
    )
]

struct OnboardingView: View {
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false
    @State private var currentPage = 0

    private var isLastPage: Bool { currentPage == pages.count - 1 }

    var body: some View {
        ZStack(alignment: .top) {
            AppTheme.Colors.backgroundGradient
                .ignoresSafeArea()

            TabView(selection: $currentPage) {
                ForEach(Array(pages.enumerated()), id: \.offset) { index, page in
                    OnboardingPageView(page: page)
                        .tag(index)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .animation(.easeInOut, value: currentPage)

            VStack {
                HStack {
                    Spacer()
                    Button("Skip") {
                        hasCompletedOnboarding = true
                    }
                    .font(.system(size: 15, weight: .medium))
                    .foregroundStyle(AppTheme.Colors.textSecondary)
                    .padding(.horizontal, AppTheme.Spacing.screenHorizontal)
                }
                .frame(height: AppTheme.Size.topBarHeight)

                Spacer()

                VStack(spacing: 24) {
                    PageIndicator(total: pages.count, current: currentPage)

                    PrimaryButton(title: isLastPage ? "Start Planning" : "Next") {
                        if isLastPage {
                            hasCompletedOnboarding = true
                        } else {
                            withAnimation(.easeInOut) {
                                currentPage += 1
                            }
                        }
                    }
                    .padding(.horizontal, AppTheme.Spacing.screenHorizontal)
                }
                .padding(.bottom, 48)
            }
        }
    }
}

private struct OnboardingPageView: View {
    let page: OnboardingPage

    var body: some View {
        VStack(spacing: 0) {
            Spacer()
                .frame(height: AppTheme.Size.topBarHeight)

            Image(page.image)
                .resizable()
                .scaledToFill()
                .frame(maxWidth: .infinity)
                .frame(height: UIScreen.main.bounds.height * 0.42)
                .clipShape(RoundedRectangle(cornerRadius: AppTheme.Radius.card))
                .padding(.horizontal, AppTheme.Spacing.screenHorizontal)

            Spacer()
                .frame(height: 36)

            Text(page.title)
                .font(.system(size: 28, weight: .bold))
                .foregroundStyle(AppTheme.Colors.textPrimary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, AppTheme.Spacing.screenHorizontal)

            Spacer()
                .frame(height: 12)

            Text(page.description)
                .font(.system(size: 15, weight: .regular))
                .foregroundStyle(AppTheme.Colors.textSecondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)

            Spacer()
                .frame(height: 80)

            Spacer()
        }
    }
}

private struct PageIndicator: View {
    let total: Int
    let current: Int

    var body: some View {
        HStack(spacing: 6) {
            ForEach(0..<total, id: \.self) { index in
                Capsule()
                    .fill(index == current ? AppTheme.Colors.accentPrimary : Color(hex: "3A3F52"))
                    .frame(width: index == current ? 24 : 8, height: 8)
                    .animation(.easeInOut(duration: 0.25), value: current)
            }
        }
    }
}

#Preview {
    OnboardingView()
}
