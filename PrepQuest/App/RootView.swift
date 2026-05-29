import SwiftUI

struct RootView: View {
    @State private var progress = LearnerProgress()
    @AppStorage("learnerProgressData") private var learnerProgressData = Data()

    var body: some View {
        TabView {
            NavigationStack {
                AdventureView(progress: $progress)
                    .navigationTitle("Adventure")
            }
            .tabItem {
                Label("Adventure", systemImage: "map.circle.fill")
            }

            NavigationStack {
                PracticeMenuView(progress: $progress)
                    .navigationTitle("Practice")
            }
            .tabItem {
                Label("Quests", systemImage: "play.circle.fill")
            }

            NavigationStack {
                SkillMapView(progress: progress)
                    .navigationTitle("World Map")
            }
            .tabItem {
                Label("Map", systemImage: "map.fill")
            }

            NavigationStack {
                RewardsView(progress: $progress)
                    .navigationTitle("Rewards")
            }
            .tabItem {
                Label("Rewards", systemImage: "dollarsign.circle.fill")
            }

            NavigationStack {
                WinsView(progress: progress)
                    .navigationTitle("Trophies")
            }
            .tabItem {
                Label("Trophies", systemImage: "sparkles")
            }
        }
        .onAppear(perform: loadProgress)
        .onChange(of: progress) { _, newValue in
            saveProgress(newValue)
        }
    }

    private func loadProgress() {
        guard !learnerProgressData.isEmpty else { return }
        guard let storedProgress = try? JSONDecoder().decode(LearnerProgress.self, from: learnerProgressData) else { return }
        progress = storedProgress
    }

    private func saveProgress(_ progress: LearnerProgress) {
        guard let encodedProgress = try? JSONEncoder().encode(progress) else { return }
        learnerProgressData = encodedProgress
    }
}

#Preview {
    RootView()
}
