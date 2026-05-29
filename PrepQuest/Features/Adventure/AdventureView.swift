import SwiftUI

struct AdventureView: View {
    @Binding var progress: LearnerProgress

    private let lands = AdventureLand.all

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                AdventureHeroView(progress: progress)

                VStack(alignment: .leading, spacing: 12) {
                    Text("Choose a land")
                        .font(.title2.bold())
                        .foregroundStyle(AppTheme.ink)

                    ForEach(lands) { land in
                        NavigationLink {
                            PracticeSessionView(
                                sessionTitle: land.questTitle,
                                questions: land.questions,
                                progress: $progress
                            )
                        } label: {
                            AdventureLandCard(
                                land: land,
                                isUnlocked: isUnlocked(land),
                                isCurrent: land.index == min(progress.landsCleared + 1, lands.count)
                            )
                        }
                        .buttonStyle(.plain)
                        .disabled(!isUnlocked(land))
                    }
                }
            }
            .padding(20)
        }
        .background(AppTheme.background.ignoresSafeArea())
    }

    private func isUnlocked(_ land: AdventureLand) -> Bool {
        land.index <= progress.landsCleared + 1
    }
}

private struct AdventureHeroView: View {
    let progress: LearnerProgress

    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 6) {
                    Text("PrepQuest")
                        .font(.largeTitle.bold())
                    Text("Answer questions, defeat blockers, and collect gold.")
                        .font(.headline)
                        .foregroundStyle(.white.opacity(0.86))
                        .fixedSize(horizontal: false, vertical: true)
                    Text("Learn / Play / Achieve")
                        .font(.caption.weight(.heavy))
                        .textCase(.uppercase)
                        .foregroundStyle(AppTheme.gold)
                }

                Spacer()

                VStack(spacing: 4) {
                    Image(systemName: "dollarsign.circle.fill")
                        .font(.system(size: 42, weight: .bold))
                        .foregroundStyle(AppTheme.gold)
                    Text("\(progress.coins)")
                        .font(.headline.monospacedDigit())
                    Text("gold")
                        .font(.caption.bold())
                        .foregroundStyle(.white.opacity(0.75))
                }
            }

            HStack(spacing: 12) {
                AdventureStatPill(icon: "shield.lefthalf.filled", value: "\(progress.monstersDefeated)", label: "blockers")
                AdventureStatPill(icon: "flag.checkered", value: "\(progress.landsCleared)", label: "lands")
                AdventureStatPill(icon: "star.fill", value: "\(progress.level)", label: "level")
            }

            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text(progress.rankTitle)
                        .font(.subheadline.bold())
                    Spacer()
                    Text("\(progress.xpInCurrentLevel)/120 XP")
                        .font(.caption.monospacedDigit().weight(.bold))
                }

                GeometryReader { proxy in
                    ZStack(alignment: .leading) {
                        Capsule()
                            .fill(.white.opacity(0.20))
                        Capsule()
                            .fill(AppTheme.gold)
                            .frame(width: proxy.size.width * progress.levelProgress)
                    }
                }
                .frame(height: 10)
            }
        }
        .padding(20)
        .foregroundStyle(.white)
        .background(AppTheme.adventureGradient, in: RoundedRectangle(cornerRadius: 18, style: .continuous))
        .overlay {
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .stroke(AppTheme.gold.opacity(0.75), lineWidth: 2)
        }
        .shadow(color: AppTheme.navy.opacity(0.18), radius: 12, x: 0, y: 8)
    }
}

private struct AdventureStatPill: View {
    let icon: String
    let value: String
    let label: String

    var body: some View {
        HStack(spacing: 7) {
            Image(systemName: icon)
            VStack(alignment: .leading, spacing: 0) {
                Text(value)
                    .font(.subheadline.monospacedDigit().weight(.bold))
                Text(label)
                    .font(.caption2.weight(.semibold))
                    .foregroundStyle(.white.opacity(0.72))
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 10)
        .padding(.vertical, 9)
        .background(.white.opacity(0.14), in: RoundedRectangle(cornerRadius: 8, style: .continuous))
    }
}

private struct AdventureLandCard: View {
    let land: AdventureLand
    let isUnlocked: Bool
    let isCurrent: Bool

    var body: some View {
        HStack(spacing: 14) {
            ZStack {
                Circle()
                    .fill(isUnlocked ? land.color : Color.gray.opacity(0.28))
                Image(systemName: isUnlocked ? land.icon : "lock.fill")
                    .font(.title2.weight(.bold))
                    .foregroundStyle(.white)
            }
            .frame(width: 58, height: 58)

            VStack(alignment: .leading, spacing: 6) {
                HStack(spacing: 7) {
                    Text(land.name)
                        .font(.headline)
                        .foregroundStyle(AppTheme.ink)
                    if isCurrent && isUnlocked {
                        Text("Next")
                            .font(.caption2.bold())
                            .foregroundStyle(AppTheme.ink)
                            .padding(.horizontal, 7)
                            .padding(.vertical, 3)
                            .background(AppTheme.gold, in: Capsule())
                    }
                }

                Text(isUnlocked ? land.story : "Clear the previous land to unlock this path.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)

                HStack(spacing: 10) {
                    Label(land.subject.rawValue, systemImage: land.subject.iconName)
                    Label("\(land.possibleCoins) gold", systemImage: "dollarsign.circle.fill")
                }
                .font(.caption.weight(.bold))
                .foregroundStyle(isUnlocked ? land.color : .secondary)
            }

            Spacer(minLength: 4)

            Image(systemName: "chevron.right")
                .font(.headline.weight(.bold))
                .foregroundStyle(.secondary)
                .opacity(isUnlocked ? 1 : 0)
        }
        .padding(14)
        .background(AppTheme.surface, in: RoundedRectangle(cornerRadius: 12, style: .continuous))
        .overlay {
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .stroke(isCurrent && isUnlocked ? AppTheme.gold : Color.black.opacity(0.05), lineWidth: isCurrent && isUnlocked ? 2 : 1)
        }
        .opacity(isUnlocked ? 1 : 0.58)
    }
}

private struct AdventureLand: Identifiable {
    let index: Int
    let name: String
    let questTitle: String
    let story: String
    let icon: String
    let color: Color
    let subject: SubjectArea
    let questions: [PracticeQuestion]

    var id: Int { index }

    var possibleCoins: Int {
        questions.reduce(0) { total, question in
            total + question.difficulty.rawValue * 5
        }
    }

    static let all: [AdventureLand] = [
        AdventureLand(
            index: 1,
            name: "Storywood",
            questTitle: "Storywood Battle",
            story: "Cut through confusing passages by finding main ideas and clues.",
            icon: "book.pages.fill",
            color: AppTheme.subjectColor(.reading),
            subject: .reading,
            questions: SampleQuestionBank.readingQuest
        ),
        AdventureLand(
            index: 2,
            name: "Number Peaks",
            questTitle: "Number Peaks Battle",
            story: "Climb past fractions, percentages, equations, and data traps.",
            icon: "mountain.2.fill",
            color: AppTheme.subjectColor(.math),
            subject: .math,
            questions: SampleQuestionBank.mathQuest
        ),
        AdventureLand(
            index: 3,
            name: "Data Marsh",
            questTitle: "Data Marsh Battle",
            story: "Use evidence, variables, and graphs to get through the fog.",
            icon: "atom",
            color: AppTheme.subjectColor(.science),
            subject: .science,
            questions: SampleQuestionBank.scienceQuest
        ),
        AdventureLand(
            index: 4,
            name: "Civics Keep",
            questTitle: "Civics Keep Battle",
            story: "Defeat history and government blockers with practical clues.",
            icon: "building.columns.fill",
            color: AppTheme.subjectColor(.socialStudies),
            subject: .socialStudies,
            questions: SampleQuestionBank.socialStudiesRescue
        ),
        AdventureLand(
            index: 5,
            name: "Grammar Gate",
            questTitle: "Grammar Gate Battle",
            story: "Fix sentence traps and build stronger writing moves.",
            icon: "pencil.and.scribble",
            color: AppTheme.subjectColor(.writing),
            subject: .writing,
            questions: SampleQuestionBank.writingQuest
        )
    ]
}

#Preview {
    NavigationStack {
        AdventureView(progress: .constant(LearnerProgress()))
            .navigationTitle("Adventure")
    }
}
