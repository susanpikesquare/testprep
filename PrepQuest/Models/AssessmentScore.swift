import Foundation

struct AssessmentScore: Identifiable {
    var id: SubjectArea { subject }
    let subject: SubjectArea
    let score: Int?
    let possible: Int
    let duration: String?
    let dateText: String?
    let testName: String

    var scoreText: String {
        guard let score else { return "Not taken" }
        return "\(score)/\(possible)"
    }

    var readiness: ReadinessBand {
        guard let score else { return .unknown }
        if score >= 14 { return .strong }
        if score >= 10 { return .nearReady }
        if score >= 8 { return .builder }
        return .rescue
    }

    var progress: Double {
        guard let score else { return 0 }
        return Double(score) / Double(possible)
    }
}

enum ReadinessBand {
    case strong
    case nearReady
    case builder
    case rescue
    case unknown

    var title: String {
        switch self {
        case .strong: "Power zone"
        case .nearReady: "Near ready"
        case .builder: "Builder zone"
        case .rescue: "Rescue zone"
        case .unknown: "Unknown"
        }
    }

    var message: String {
        switch self {
        case .strong:
            "Keep this fresh with short mixed rounds."
        case .nearReady:
            "Close enough to protect confidence and build consistency."
        case .builder:
            "Needs steady practice, but the base is there."
        case .rescue:
            "Start small here. This is where the biggest gains are hiding."
        case .unknown:
            "No score yet. Treat this gently."
        }
    }
}

