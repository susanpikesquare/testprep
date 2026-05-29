import Foundation

enum NickBaselineScores {
    static let hisetPractice: [AssessmentScore] = [
        AssessmentScore(
            subject: .reading,
            score: 11,
            possible: 20,
            duration: "34m 25s",
            dateText: "08/16/2025",
            testName: "HiSET Reading Practice Test 2"
        ),
        AssessmentScore(
            subject: .socialStudies,
            score: 5,
            possible: 20,
            duration: "29m 56s",
            dateText: "08/29/2025",
            testName: "Social Studies HiSET Practice Test 1"
        ),
        AssessmentScore(
            subject: .math,
            score: 10,
            possible: 20,
            duration: "72m 44s",
            dateText: "09/29/2025",
            testName: "Math HiSET Practice Test 1"
        ),
        AssessmentScore(
            subject: .science,
            score: 15,
            possible: 20,
            duration: "48m",
            dateText: "08/28/2025",
            testName: "HiSET Science Practice Test 1"
        ),
        AssessmentScore(
            subject: .writing,
            score: nil,
            possible: 20,
            duration: nil,
            dateText: nil,
            testName: "HiSET Writing Practice Test"
        )
    ]

    static var prioritySubject: AssessmentScore {
        hisetPractice.first { $0.subject == .socialStudies } ?? hisetPractice[0]
    }
}

