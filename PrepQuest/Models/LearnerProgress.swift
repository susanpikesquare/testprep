import Foundation

struct LearnerProgress: Codable, Equatable {
    var sessionsCompleted = 0
    var questionsAnswered = 0
    var correctAnswers = 0
    var subjectAttempts: [SubjectArea: Int] = [:]
    var subjectCorrect: [SubjectArea: Int] = [:]
    var skillAttempts: [String: Int] = [:]
    var skillCorrect: [String: Int] = [:]
    var difficultyAttempts: [DifficultyLevel: Int] = [:]
    var difficultyCorrect: [DifficultyLevel: Int] = [:]
    var coins = 0
    var lifetimeCoins = 0
    var monstersDefeated = 0
    var landsCleared = 0
    var learnerCode = LearnerProgress.generateLearnerCode()
    var bankers: [RewardBanker] = []
    var rewardRequests: [RewardRedemption] = []
    var recentWins: [String] = [
        "You showed up. That is the first rep."
    ]

    var accuracyText: String {
        guard questionsAnswered > 0 else { return "Not started" }
        let accuracy = Double(correctAnswers) / Double(questionsAnswered)
        return accuracy.formatted(.percent.precision(.fractionLength(0)))
    }

    var xp: Int {
        sessionsCompleted * 30 + questionsAnswered * 8 + correctAnswers * 14 + monstersDefeated * 10
    }

    var level: Int {
        max(1, xp / 120 + 1)
    }

    var xpInCurrentLevel: Int {
        xp % 120
    }

    var levelProgress: Double {
        Double(xpInCurrentLevel) / 120.0
    }

    var coinCashValueText: String {
        let dollars = Double(coins) / 100.0
        return dollars.formatted(.currency(code: "USD"))
    }

    var rankTitle: String {
        switch level {
        case 1:
            return "Trail Starter"
        case 2:
            return "Clue Finder"
        case 3:
            return "Skill Builder"
        default:
            return "Quest Climber"
        }
    }

    func accuracyText(for subject: SubjectArea) -> String {
        guard let attempts = subjectAttempts[subject], attempts > 0 else {
            return "Not started"
        }

        let correct = subjectCorrect[subject, default: 0]
        let accuracy = Double(correct) / Double(attempts)
        return accuracy.formatted(.percent.precision(.fractionLength(0)))
    }

    func answeredCount(for subject: SubjectArea) -> Int {
        subjectAttempts[subject, default: 0]
    }

    mutating func record(session: SessionResult) {
        sessionsCompleted += 1
        questionsAnswered += session.totalQuestions
        correctAnswers += session.correctAnswers
        coins += session.coinsEarned
        lifetimeCoins += session.coinsEarned
        monstersDefeated += session.monstersDefeated
        if session.correctAnswers == session.totalQuestions {
            landsCleared += 1
        }

        for result in session.questionResults {
            subjectAttempts[result.subject, default: 0] += 1
            skillAttempts[result.skill, default: 0] += 1
            difficultyAttempts[result.difficulty, default: 0] += 1
            if result.wasCorrect {
                subjectCorrect[result.subject, default: 0] += 1
                skillCorrect[result.skill, default: 0] += 1
                difficultyCorrect[result.difficulty, default: 0] += 1
            }
        }

        if session.correctAnswers == session.totalQuestions {
            recentWins.insert("You cleared the land and earned \(session.coinsEarned) coins.", at: 0)
        } else if session.correctAnswers > 0 {
            recentWins.insert("You defeated \(session.monstersDefeated) blockers and earned \(session.coinsEarned) coins.", at: 0)
        } else {
            recentWins.insert("You finished the round even when it was hard.", at: 0)
        }

        recentWins = Array(recentWins.prefix(5))
    }

    mutating func requestReward(title: String, cost: Int) {
        guard coins >= cost else { return }

        coins -= cost
        rewardRequests.insert(
            RewardRedemption(
                title: title,
                cost: cost,
                requestedAt: Date(),
                status: .pending
            ),
            at: 0
        )
        recentWins.insert("Reward requested: \(title).", at: 0)
        recentWins = Array(recentWins.prefix(5))
    }

    mutating func addBanker(name: String) {
        let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedName.isEmpty else { return }

        bankers.removeAll { $0.name.caseInsensitiveCompare(trimmedName) == .orderedSame }
        bankers.insert(
            RewardBanker(
                name: trimmedName,
                pairedAt: Date()
            ),
            at: 0
        )
    }

    mutating func markRewardFulfilled(_ redemptionID: RewardRedemption.ID) {
        guard let index = rewardRequests.firstIndex(where: { $0.id == redemptionID }) else { return }
        rewardRequests[index].status = .fulfilled
        rewardRequests[index].fulfilledAt = Date()
        recentWins.insert("Reward paid: \(rewardRequests[index].title).", at: 0)
        recentWins = Array(recentWins.prefix(5))
    }

    mutating func cancelRewardRequest(_ redemptionID: RewardRedemption.ID) {
        guard let index = rewardRequests.firstIndex(where: { $0.id == redemptionID }) else { return }
        let request = rewardRequests.remove(at: index)
        if request.status == .pending {
            coins += request.cost
        }
    }

    static func generateLearnerCode() -> String {
        let letters = "ABCDEFGHJKLMNPQRSTUVWXYZ23456789"
        let chunks = (0..<2).map { _ in
            String((0..<3).compactMap { _ in letters.randomElement() })
        }
        return chunks.joined(separator: "-")
    }
}

struct RewardBanker: Identifiable, Codable, Equatable {
    let id: UUID
    let name: String
    let pairedAt: Date
    var notificationsEnabled: Bool

    init(
        id: UUID = UUID(),
        name: String,
        pairedAt: Date,
        notificationsEnabled: Bool = true
    ) {
        self.id = id
        self.name = name
        self.pairedAt = pairedAt
        self.notificationsEnabled = notificationsEnabled
    }
}

struct RewardRedemption: Identifiable, Codable, Equatable {
    enum Status: String, Codable {
        case pending
        case fulfilled
    }

    let id: UUID
    let title: String
    let cost: Int
    let requestedAt: Date
    var fulfilledAt: Date?
    var status: Status

    init(
        id: UUID = UUID(),
        title: String,
        cost: Int,
        requestedAt: Date,
        fulfilledAt: Date? = nil,
        status: Status
    ) {
        self.id = id
        self.title = title
        self.cost = cost
        self.requestedAt = requestedAt
        self.fulfilledAt = fulfilledAt
        self.status = status
    }
}

struct SessionResult {
    let totalQuestions: Int
    let correctAnswers: Int
    let coinsEarned: Int
    let monstersDefeated: Int
    let questionResults: [QuestionResult]
}

struct QuestionResult {
    let subject: SubjectArea
    let skill: String
    let difficulty: DifficultyLevel
    let wasCorrect: Bool
}
