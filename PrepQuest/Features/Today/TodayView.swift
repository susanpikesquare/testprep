import SwiftUI

struct TodayView: View {
    @Binding var progress: LearnerProgress

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                CalmHeaderView(
                    title: "PrepQuest",
                    subtitle: "Build skill, earn XP, and clear one small quest at a time."
                )

                LevelBanner(progress: progress)

                TodayMissionCard(progress: $progress)

                ReadinessSnapshotView(scores: NickBaselineScores.hisetPractice)

                ProgressSummaryView(progress: progress)

                NextStepsView()

                RecentWinsList(wins: progress.recentWins)
            }
            .padding(20)
        }
        .background(AppTheme.background)
    }
}

private struct TodayMissionCard: View {
    @Binding var progress: LearnerProgress

    var body: some View {
        NavigationLink {
            PracticeSessionView(
                sessionTitle: "Daily HiSET mix",
                questions: SampleQuestionBank.dailyPractice,
                progress: $progress
            )
        } label: {
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    Image(systemName: "shield.lefthalf.filled.badge.checkmark")
                        .font(.title)
                    Spacer()
                    Text("15 min")
                        .font(.caption.weight(.semibold))
                        .padding(.horizontal, 10)
                        .padding(.vertical, 6)
                        .background(.white.opacity(0.18), in: Capsule())
                }

                VStack(alignment: .leading, spacing: 8) {
                    Text("Daily quest")
                        .font(.title2.bold())
                    Text("5 Reading, 5 Math, 3 Science, 3 Social Studies, 2 Writing.")
                        .font(.subheadline)
                        .foregroundStyle(.white.opacity(0.85))
                }

                HStack {
                    Text("Start quest")
                        .font(.headline)
                    Spacer()
                    Image(systemName: "arrow.right.circle.fill")
                        .font(.title2)
                }
            }
            .padding(20)
            .foregroundStyle(.white)
            .background(AppTheme.questGradient, in: RoundedRectangle(cornerRadius: 18, style: .continuous))
        }
        .buttonStyle(.plain)
    }
}

private struct LevelBanner: View {
    let progress: LearnerProgress

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(spacing: 12) {
                ZStack {
                    Circle()
                        .fill(AppTheme.gold.opacity(0.22))
                    Image(systemName: "star.fill")
                        .foregroundStyle(AppTheme.gold)
                        .font(.title2)
                }
                .frame(width: 52, height: 52)

                VStack(alignment: .leading, spacing: 4) {
                    Text("Level \(progress.level)")
                        .font(.title3.bold())
                    Text(progress.rankTitle)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }

                Spacer()

                Text("\(progress.xp) XP")
                    .font(.headline.monospacedDigit())
                    .foregroundStyle(AppTheme.primary)
            }

            ProgressView(value: progress.levelProgress)
                .tint(AppTheme.gold)

            Text("\(120 - progress.xpInCurrentLevel) XP to the next level")
                .font(.caption.weight(.semibold))
                .foregroundStyle(.secondary)
        }
        .padding(16)
        .background(AppTheme.surface, in: RoundedRectangle(cornerRadius: 16, style: .continuous))
    }
}

private struct ReadinessSnapshotView: View {
    let scores: [AssessmentScore]

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack {
                Text("HiSET readiness")
                    .font(.headline)
                Spacer()
                Text("Baseline")
                    .font(.caption.weight(.bold))
                    .foregroundStyle(AppTheme.primary)
            }

            ForEach(scores) { score in
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Label(score.subject.rawValue, systemImage: score.subject.iconName)
                            .font(.subheadline.weight(.semibold))
                            .foregroundStyle(AppTheme.subjectColor(score.subject))
                        Spacer()
                        Text(score.scoreText)
                            .font(.subheadline.monospacedDigit().weight(.bold))
                    }

                    ProgressView(value: score.progress)
                        .tint(AppTheme.subjectColor(score.subject))

                    Text(score.readiness.title)
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(.secondary)
                }
            }

            HStack(alignment: .top, spacing: 10) {
                Image(systemName: "scope")
                    .foregroundStyle(AppTheme.coral)
                Text("First target: Social Studies. It has the most room for fast improvement.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(16)
        .background(AppTheme.surface, in: RoundedRectangle(cornerRadius: 16, style: .continuous))
    }
}

private struct ProgressSummaryView: View {
    let progress: LearnerProgress

    var body: some View {
        VStack(spacing: 12) {
            HStack(spacing: 12) {
                StatTile(title: "Sessions", value: "\(progress.sessionsCompleted)")
                StatTile(title: "Answered", value: "\(progress.questionsAnswered)")
            }

            HStack(spacing: 12) {
                StatTile(title: "Accuracy", value: progress.accuracyText)
                StatTile(title: "Level", value: "\(progress.level)")
            }
        }
    }
}

private struct StatTile: View {
    let title: String
    let value: String

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(value)
                .font(.title2.bold())
                .fontDesign(.rounded)
                .minimumScaleFactor(0.76)
                .lineLimit(1)
            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(14)
        .background(AppTheme.surface, in: RoundedRectangle(cornerRadius: 10, style: .continuous))
    }
}

private struct NextStepsView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("When it gets hard")
                .font(.headline)
            HStack(alignment: .top, spacing: 10) {
                Image(systemName: "pause.circle.fill")
                    .foregroundStyle(AppTheme.coral)
                Text("Stop after one question if that is what today has room for. Coming back matters more than forcing a long session.")
                    .foregroundStyle(.secondary)
            }
        }
        .padding(16)
        .background(AppTheme.surface, in: RoundedRectangle(cornerRadius: 12, style: .continuous))
    }
}

struct RecentWinsList: View {
    let wins: [String]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Recent wins")
                .font(.headline)
            ForEach(wins, id: \.self) { win in
                Label(win, systemImage: "checkmark.circle.fill")
                    .foregroundStyle(.primary)
            }
        }
    }
}

#Preview {
    NavigationStack {
        TodayView(progress: .constant(LearnerProgress()))
    }
}
