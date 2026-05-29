import SwiftUI

struct PracticeSessionView: View {
    let sessionTitle: String
    let questions: [PracticeQuestion]
    @Binding var progress: LearnerProgress

    @Environment(\.dismiss) private var dismiss
    @State private var currentIndex = 0
    @State private var selectedChoiceIndex: Int?
    @State private var correctAnswers = 0
    @State private var questionResults: [QuestionResult] = []
    @State private var missionCompleted = false
    @State private var coinsEarned = 0
    @State private var monstersDefeated = 0
    @State private var heroStep = 0

    private var currentQuestion: PracticeQuestion {
        questions[currentIndex]
    }

    private var currentEncounter: Encounter {
        Encounter.forQuestion(currentQuestion)
    }

    var body: some View {
        Group {
            if missionCompleted {
                MissionCompleteView(
                    sessionTitle: sessionTitle,
                    correctAnswers: correctAnswers,
                    totalQuestions: questions.count,
                    coinsEarned: coinsEarned,
                    monstersDefeated: monstersDefeated
                ) {
                    dismiss()
                }
            } else {
                ScrollView {
                    VStack(alignment: .leading, spacing: 22) {
                        AdventureProgressView(
                            currentIndex: currentIndex,
                            total: questions.count,
                            coinsEarned: coinsEarned,
                            heroStep: heroStep
                        )

                        HStack {
                            Text("Encounter \(currentIndex + 1) of \(questions.count)")
                                .font(.subheadline.weight(.semibold))
                                .foregroundStyle(.secondary)
                            Spacer()
                            VStack(alignment: .trailing, spacing: 4) {
                                Label(currentQuestion.subject.rawValue, systemImage: currentQuestion.subject.iconName)
                                    .font(.caption.weight(.semibold))
                                    .foregroundStyle(AppTheme.subjectColor(currentQuestion.subject))
                                Text(currentQuestion.difficulty.title)
                                    .font(.caption2.weight(.bold))
                                    .foregroundStyle(.secondary)
                            }
                        }

                        EncounterSceneView(
                            encounter: currentEncounter,
                            hasAnswered: selectedChoiceIndex != nil,
                            answeredCorrectly: selectedChoiceIndex == currentQuestion.correctChoiceIndex
                        )

                        VStack(alignment: .leading, spacing: 8) {
                            Text(currentQuestion.skill)
                                .font(.caption.weight(.semibold))
                                .foregroundStyle(.secondary)
                            Text(currentQuestion.prompt)
                                .font(.title2.weight(.semibold))
                        }

                        VStack(spacing: 12) {
                            ForEach(currentQuestion.choices.indices, id: \.self) { index in
                                ChoiceButton(
                                    title: currentQuestion.choices[index],
                                    isSelected: selectedChoiceIndex == index,
                                    isCorrect: index == currentQuestion.correctChoiceIndex,
                                    hasAnswered: selectedChoiceIndex != nil
                                ) {
                                    guard selectedChoiceIndex == nil else { return }
                                    selectedChoiceIndex = index
                                    let wasCorrect = index == currentQuestion.correctChoiceIndex
                                    questionResults.append(
                                        QuestionResult(
                                            subject: currentQuestion.subject,
                                            skill: currentQuestion.skill,
                                            difficulty: currentQuestion.difficulty,
                                            wasCorrect: wasCorrect
                                        )
                                    )
                                    if wasCorrect {
                                        correctAnswers += 1
                                        monstersDefeated += 1
                                        let reward = coinReward(for: currentQuestion)
                                        coinsEarned += reward
                                        RewardFeedback.monsterHit()
                                        RewardFeedback.coinEarned()
                                    } else {
                                        RewardFeedback.wrongTurn()
                                    }
                                }
                            }
                        }

                        if selectedChoiceIndex != nil {
                            FeedbackView(
                                question: currentQuestion,
                                selectedChoiceIndex: selectedChoiceIndex,
                                coinReward: selectedChoiceIndex == currentQuestion.correctChoiceIndex ? coinReward(for: currentQuestion) : 0
                            )

                            Button(currentIndex == questions.count - 1 ? "Complete mission" : "Next question") {
                                advance()
                            }
                            .buttonStyle(.borderedProminent)
                            .controlSize(.large)
                        }
                    }
                    .padding(20)
                }
            }
        }
        .background(AppTheme.background.ignoresSafeArea())
        .navigationTitle(sessionTitle)
        .navigationBarTitleDisplayMode(.inline)
    }

    private var completionMessage: String {
        if correctAnswers == questions.count {
            return "You cleared all \(questions.count). That is real progress."
        }
        return "You finished \(questions.count) questions and got \(correctAnswers) right. The next step is clearer now."
    }

    private func advance() {
        if currentIndex == questions.count - 1 {
            progress.record(
                session: SessionResult(
                    totalQuestions: questions.count,
                    correctAnswers: correctAnswers,
                    coinsEarned: coinsEarned,
                    monstersDefeated: monstersDefeated,
                    questionResults: questionResults
                )
            )
            withAnimation(.spring(response: 0.6, dampingFraction: 0.82)) {
                missionCompleted = true
            }
        } else {
            currentIndex += 1
            heroStep += 1
            selectedChoiceIndex = nil
        }
    }

    private func coinReward(for question: PracticeQuestion) -> Int {
        question.difficulty.rawValue * 5
    }
}

private struct MissionCompleteView: View {
    let sessionTitle: String
    let correctAnswers: Int
    let totalQuestions: Int
    let coinsEarned: Int
    let monstersDefeated: Int
    let continueAction: () -> Void

    @State private var heroAdvanced = false
    @State private var coinsDropped = false
    @State private var summaryVisible = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 22) {
                VStack(alignment: .leading, spacing: 6) {
                    Text("Mission complete")
                        .font(.largeTitle.bold())
                        .foregroundStyle(AppTheme.ink)
                    Text(sessionTitle)
                        .font(.headline)
                        .foregroundStyle(.secondary)
                }

                VStack(alignment: .leading, spacing: 18) {
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Path cleared")
                                .font(.title2.bold())
                            Text("The hero advances to the next stretch of the map.")
                                .font(.subheadline)
                                .foregroundStyle(.white.opacity(0.84))
                        }
                        Spacer()
                        Image(systemName: "flag.checkered")
                            .font(.system(size: 42, weight: .bold))
                            .symbolEffect(.bounce, value: heroAdvanced)
                    }

                    GeometryReader { proxy in
                        ZStack(alignment: .leading) {
                            Capsule()
                                .fill(.white.opacity(0.24))
                                .frame(height: 8)

                            Capsule()
                                .fill(AppTheme.gold)
                                .frame(width: proxy.size.width * (heroAdvanced ? 1 : 0.08), height: 8)

                            Image(systemName: "figure.walk.circle.fill")
                                .font(.system(size: 44, weight: .bold))
                                .foregroundStyle(AppTheme.gold)
                                .background(AppTheme.ink, in: Circle())
                                .offset(x: heroAdvanced ? proxy.size.width - 44 : 0)
                                .symbolEffect(.bounce, value: heroAdvanced)

                            Image(systemName: "flag.fill")
                                .font(.title2)
                                .foregroundStyle(.white)
                                .offset(x: proxy.size.width - 22, y: -28)
                        }
                    }
                    .frame(height: 64)

                    HStack(spacing: 10) {
                        ForEach(0..<5, id: \.self) { index in
                            Image(systemName: "dollarsign.circle.fill")
                                .font(.title)
                                .foregroundStyle(AppTheme.gold)
                                .scaleEffect(coinsDropped ? 1 : 0.2)
                                .opacity(coinsDropped ? 1 : 0)
                                .offset(y: coinsDropped ? 0 : -22)
                                .animation(
                                    .spring(response: 0.5, dampingFraction: 0.62)
                                    .delay(Double(index) * 0.08),
                                    value: coinsDropped
                                )
                        }
                        Spacer()
                        Text("+\(coinsEarned) gold")
                            .font(.title3.monospacedDigit().weight(.heavy))
                    }
                }
                .padding(20)
                .foregroundStyle(.white)
                .background(AppTheme.questGradient, in: RoundedRectangle(cornerRadius: 18, style: .continuous))

                HStack(spacing: 12) {
                    MissionStatCard(icon: "checkmark.seal.fill", value: "\(correctAnswers)/\(totalQuestions)", label: "answered")
                    MissionStatCard(icon: "shield.lefthalf.filled", value: "\(monstersDefeated)", label: "blockers")
                    MissionStatCard(icon: "dollarsign.circle.fill", value: "\(coinsEarned)", label: "gold")
                }
                .opacity(summaryVisible ? 1 : 0)
                .offset(y: summaryVisible ? 0 : 12)

                Text(completionMessage)
                    .font(.headline)
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
                    .opacity(summaryVisible ? 1 : 0)

                Button(action: continueAction) {
                    Label("Back to adventure", systemImage: "map.circle.fill")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
                .opacity(summaryVisible ? 1 : 0)
            }
            .padding(20)
        }
        .onAppear {
            RewardFeedback.coinEarned()
            withAnimation(.easeInOut(duration: 1.1)) {
                heroAdvanced = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.45) {
                coinsDropped = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.9) {
                withAnimation(.spring(response: 0.5, dampingFraction: 0.82)) {
                    summaryVisible = true
                }
            }
        }
    }

    private var completionMessage: String {
        if correctAnswers == totalQuestions {
            return "Perfect clear. That land is defeated, and the next path is open."
        }
        if correctAnswers > 0 {
            return "You moved the hero forward. Missed questions become clues for the next run."
        }
        return "You finished the mission. Showing up still counts, and the next attempt starts clearer."
    }
}

private struct MissionStatCard: View {
    let icon: String
    let value: String
    let label: String

    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundStyle(AppTheme.gold)
            Text(value)
                .font(.headline.monospacedDigit())
                .foregroundStyle(AppTheme.ink)
                .lineLimit(1)
                .minimumScaleFactor(0.72)
            Text(label)
                .font(.caption.weight(.bold))
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 14)
        .background(AppTheme.surface, in: RoundedRectangle(cornerRadius: 10, style: .continuous))
    }
}

private struct AdventureProgressView: View {
    let currentIndex: Int
    let total: Int
    let coinsEarned: Int
    let heroStep: Int

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Label("\(coinsEarned)", systemImage: "dollarsign.circle.fill")
                    .font(.headline.monospacedDigit())
                    .foregroundStyle(AppTheme.gold)
                Spacer()
                Text("Path \(min(currentIndex + 1, total))/\(total)")
                    .font(.caption.weight(.bold))
                    .foregroundStyle(.secondary)
            }

            GeometryReader { proxy in
                ZStack(alignment: .leading) {
                    Capsule()
                        .fill(Color.black.opacity(0.08))
                    Capsule()
                        .fill(AppTheme.questGradient)
                        .frame(width: proxy.size.width * (Double(currentIndex) / Double(max(total - 1, 1))))
                    Image(systemName: "figure.walk")
                        .font(.title3)
                        .foregroundStyle(.white)
                        .padding(8)
                        .background(AppTheme.coral, in: Circle())
                        .offset(x: max(0, min(proxy.size.width - 34, proxy.size.width * (Double(heroStep) / Double(max(total - 1, 1))) - 17)))
                }
            }
            .frame(height: 34)
        }
    }
}

private struct Encounter {
    let landName: String
    let enemyName: String
    let enemyIcon: String
    let sceneColor: Color

    static func forQuestion(_ question: PracticeQuestion) -> Encounter {
        switch question.subject {
        case .reading:
            Encounter(landName: "Storywood", enemyName: "Confusion Fog", enemyIcon: "cloud.fill", sceneColor: AppTheme.subjectColor(.reading))
        case .writing:
            Encounter(landName: "Grammar Gate", enemyName: "Run-On Raider", enemyIcon: "scribble.variable", sceneColor: AppTheme.subjectColor(.writing))
        case .math:
            Encounter(landName: "Number Peaks", enemyName: "Mistake Boulder", enemyIcon: "mountain.2.fill", sceneColor: AppTheme.subjectColor(.math))
        case .science:
            Encounter(landName: "Data Marsh", enemyName: "False Clue", enemyIcon: "aqi.medium", sceneColor: AppTheme.subjectColor(.science))
        case .socialStudies:
            Encounter(landName: "Civics Keep", enemyName: "Memory Bandit", enemyIcon: "building.columns.fill", sceneColor: AppTheme.subjectColor(.socialStudies))
        }
    }
}

private struct EncounterSceneView: View {
    let encounter: Encounter
    let hasAnswered: Bool
    let answeredCorrectly: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(encounter.landName)
                        .font(.headline)
                    Text(hasAnswered ? resultText : "A blocker appears. Answer to advance.")
                        .font(.subheadline)
                        .foregroundStyle(.white.opacity(0.86))
                }
                Spacer()
                Image(systemName: hasAnswered && answeredCorrectly ? "checkmark.seal.fill" : encounter.enemyIcon)
                    .font(.system(size: 42, weight: .bold))
                    .symbolEffect(.bounce, value: hasAnswered)
            }

            HStack(spacing: 12) {
                Image(systemName: "person.fill")
                    .font(.title2)
                    .padding(12)
                    .background(.white.opacity(0.20), in: Circle())
                Rectangle()
                    .fill(.white.opacity(0.55))
                    .frame(height: 3)
                    .overlay(alignment: answeredCorrectly ? .trailing : .leading) {
                        Image(systemName: "sparkle")
                            .foregroundStyle(AppTheme.gold)
                    }
                Image(systemName: hasAnswered && answeredCorrectly ? "burst.fill" : encounter.enemyIcon)
                    .font(.title2)
                    .padding(12)
                    .background(.white.opacity(0.20), in: Circle())
            }
        }
        .padding(18)
        .foregroundStyle(.white)
        .background(encounter.sceneColor, in: RoundedRectangle(cornerRadius: 18, style: .continuous))
    }

    private var resultText: String {
        answeredCorrectly ? "\(encounter.enemyName) defeated. Coins earned." : "\(encounter.enemyName) blocked this path. Learn the clue and keep moving."
    }
}

private struct ChoiceButton: View {
    let title: String
    let isSelected: Bool
    let isCorrect: Bool
    let hasAnswered: Bool
    let action: () -> Void

    private var backgroundColor: Color {
        guard hasAnswered else { return AppTheme.surface }
        if isSelected && isCorrect { return .green.opacity(0.18) }
        if isSelected { return .orange.opacity(0.18) }
        return AppTheme.surface
    }

    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                Image(systemName: iconName)
                    .foregroundStyle(iconColor)
                Text(title)
                    .foregroundStyle(.primary)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(16)
            .background(backgroundColor, in: RoundedRectangle(cornerRadius: 10, style: .continuous))
        }
        .buttonStyle(.plain)
    }

    private var iconName: String {
        guard hasAnswered else { return "circle" }
        if isSelected && isCorrect { return "checkmark.circle.fill" }
        if isSelected { return "arrow.triangle.2.circlepath.circle.fill" }
        return "circle"
    }

    private var iconColor: Color {
        guard hasAnswered else { return .secondary }
        if isSelected && isCorrect { return .green }
        if isSelected { return .orange }
        return .secondary
    }
}

private struct FeedbackView: View {
    let question: PracticeQuestion
    let selectedChoiceIndex: Int?
    let coinReward: Int

    private var answeredCorrectly: Bool {
        selectedChoiceIndex == question.correctChoiceIndex
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(answeredCorrectly ? "Nice. You got it." : "Good try. Here's the move.")
                .font(.headline)
            if coinReward > 0 {
                Label("+\(coinReward) coins deposited", systemImage: "dollarsign.circle.fill")
                    .font(.subheadline.weight(.bold))
                    .foregroundStyle(AppTheme.gold)
            }
            Text("\(question.difficulty.title): \(question.difficulty.goal)")
                .font(.caption.weight(.semibold))
                .foregroundStyle(AppTheme.subjectColor(question.subject))
            Text(question.explanation)
                .foregroundStyle(.primary)
            Text(question.encouragement)
                .foregroundStyle(.secondary)
        }
        .padding(16)
        .background(AppTheme.surface, in: RoundedRectangle(cornerRadius: 10, style: .continuous))
    }
}

#Preview {
    NavigationStack {
        PracticeSessionView(
            sessionTitle: "Preview",
            questions: SampleQuestionBank.todaySession,
            progress: .constant(LearnerProgress())
        )
    }
}
