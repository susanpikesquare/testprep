import AudioToolbox
import UIKit

enum RewardFeedback {
    static func coinEarned() {
        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
        AudioServicesPlaySystemSound(1107)
    }

    static func monsterHit() {
        UINotificationFeedbackGenerator().notificationOccurred(.success)
    }

    static func wrongTurn() {
        UINotificationFeedbackGenerator().notificationOccurred(.warning)
    }
}

