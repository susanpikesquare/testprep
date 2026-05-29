import Foundation

struct PracticeQuestion: Identifiable, Hashable {
    let id: String
    let subject: SubjectArea
    let skill: String
    let difficulty: DifficultyLevel
    let prompt: String
    let choices: [String]
    let correctChoiceIndex: Int
    let explanation: String
    let encouragement: String
}

enum SubjectArea: String, CaseIterable, Codable {
    case reading = "Reading"
    case writing = "Writing"
    case math = "Math"
    case science = "Science"
    case socialStudies = "Social Studies"

    var iconName: String {
        switch self {
        case .reading: "book.pages.fill"
        case .writing: "pencil.and.scribble"
        case .math: "function"
        case .science: "flask.fill"
        case .socialStudies: "building.columns.fill"
        }
    }

    var focusSkills: [String] {
        switch self {
        case .reading:
            ["Main Idea", "Supporting Details", "Inference", "Author's Purpose", "Vocabulary", "Workplace Documents"]
        case .writing:
            ["Grammar", "Punctuation", "Sentence Structure", "Organization", "Revision", "Essay Basics"]
        case .math:
            ["Fractions", "Decimals", "Percentages", "Ratios", "Equations", "Geometry", "Data"]
        case .science:
            ["Biology", "Physical Science", "Earth Science", "Experiments", "Variables", "Data Analysis"]
        case .socialStudies:
            ["Government", "U.S. History", "Economics", "Geography", "Maps", "Civics"]
        }
    }
}

enum DifficultyLevel: Int, CaseIterable, Hashable, Codable {
    case foundation = 1
    case fundamentals = 2
    case highSchool = 3
    case hisetReady = 4
    case challenge = 5

    var title: String {
        switch self {
        case .foundation: "Level 1"
        case .fundamentals: "Level 2"
        case .highSchool: "Level 3"
        case .hisetReady: "HiSET"
        case .challenge: "Challenge"
        }
    }

    var goal: String {
        switch self {
        case .foundation: "Build confidence"
        case .fundamentals: "Strengthen basics"
        case .highSchool: "High school skills"
        case .hisetReady: "Exam readiness"
        case .challenge: "Stretch confidence"
        }
    }
}

struct PracticeSession: Identifiable {
    var id: String { title }
    let title: String
    let subtitle: String
    let iconName: String
    let estimatedMinutes: Int
    let questions: [PracticeQuestion]
}
