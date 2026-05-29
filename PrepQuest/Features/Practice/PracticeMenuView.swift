import SwiftUI

struct PracticeMenuView: View {
    @Binding var progress: LearnerProgress

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                BrandedPageHeroView(
                    title: "Quest Board",
                    subtitle: "Pick a short round, defeat blockers, and collect gold on the way to exam readiness.",
                    iconName: "play.fill",
                    badgeText: "Learn / Play / Achieve"
                )

                RescueQuestCard(progress: $progress)

                ForEach(Array(SampleQuestionBank.allSessions.enumerated()), id: \.element.id) { index, session in
                    NavigationLink {
                        PracticeSessionView(
                            sessionTitle: session.title,
                            questions: session.questions,
                            progress: $progress
                        )
                    } label: {
                        QuestCard(session: session, index: index)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(20)
        }
        .background(AppTheme.background)
    }
}

private struct RescueQuestCard: View {
    @Binding var progress: LearnerProgress

    private let score = NickBaselineScores.prioritySubject

    var body: some View {
        NavigationLink {
            PracticeSessionView(
                sessionTitle: "Social Studies rescue",
                questions: SampleQuestionBank.socialStudiesRescue,
                progress: $progress
            )
        } label: {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    ZStack {
                        Circle()
                            .fill(AppTheme.gold)
                        Image(systemName: "target")
                            .font(.title2.bold())
                            .foregroundStyle(AppTheme.navy)
                    }
                    .frame(width: 50, height: 50)
                    Spacer()
                    Text(score.scoreText)
                        .font(.caption.monospacedDigit().weight(.bold))
                        .padding(.horizontal, 10)
                        .padding(.vertical, 6)
                        .background(.white.opacity(0.18), in: Capsule())
                }

                Text("Priority quest")
                    .font(.title3.bold())
                Text("Social Studies is the fastest place to gain points. Start with maps, civics, and evidence clues.")
                    .font(.subheadline)
                    .foregroundStyle(.white.opacity(0.88))

                HStack {
                Text("+60 possible XP")
                        .font(.headline)
                    Spacer()
                    Image(systemName: "arrow.right.circle.fill")
                        .font(.title2)
                }
            }
            .padding(18)
            .foregroundStyle(.white)
            .background(AppTheme.adventureGradient, in: RoundedRectangle(cornerRadius: 18, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .stroke(AppTheme.gold, lineWidth: 3)
            )
        }
        .buttonStyle(.plain)
    }
}

private struct QuestCard: View {
    let session: PracticeSession
    let index: Int

    private var color: Color {
        guard let subject = session.questions.first?.subject else {
            let colors = [AppTheme.primary, AppTheme.red, AppTheme.teal, AppTheme.gold]
            return colors[index % colors.count]
        }
        return AppTheme.subjectColor(subject)
    }

    var body: some View {
        HStack(spacing: 14) {
            ZStack {
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .fill(color.opacity(0.18))
                Image(systemName: session.iconName)
                    .font(.title2)
                    .foregroundStyle(color)
            }
            .frame(width: 54, height: 54)

            VStack(alignment: .leading, spacing: 6) {
                Text(session.title)
                    .font(.headline)
                    .foregroundStyle(AppTheme.ink)
                Text(session.subtitle)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                Text("+\(session.questions.count * 20) possible XP")
                    .font(.caption.weight(.bold))
                    .foregroundStyle(color)
                HStack(spacing: 8) {
                    Label("\(session.estimatedMinutes) min", systemImage: "clock.fill")
                    Label(difficultyRange, systemImage: "star.fill")
                }
                .font(.caption.weight(.semibold))
                .foregroundStyle(.secondary)
            }

            Spacer()

            Image(systemName: "play.fill")
                .font(.caption.weight(.bold))
                .foregroundStyle(.white)
                .padding(10)
                .background(color, in: Circle())
        }
        .padding(16)
        .background(AppTheme.surface, in: RoundedRectangle(cornerRadius: 16, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .stroke(color.opacity(0.35), lineWidth: 2)
        )
    }

    private var difficultyRange: String {
        let levels = session.questions.map(\.difficulty.rawValue)
        guard let min = levels.min(), let max = levels.max() else { return "Levels 1-4" }
        return min == max ? "Level \(min)" : "Levels \(min)-\(max)"
    }
}

#Preview {
    NavigationStack {
        PracticeMenuView(progress: .constant(LearnerProgress()))
    }
}
