import Foundation
import UserNotifications

enum NativeNotificationManager {
    static func requestAuthorization() async -> Bool {
        do {
            return try await UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound])
        } catch {
            return false
        }
    }

    static func scheduleRewardDue(
        rewardTitle: String,
        cost: Int,
        learnerCode: String,
        coinsRemaining: Int
    ) {
        let content = UNMutableNotificationContent()
        content.title = "PrepQuest reward due"
        content.body = "\(rewardTitle) requested for \(cost) coins. Student code \(learnerCode). \(coinsRemaining) coins remain."
        content.sound = .default

        let request = UNNotificationRequest(
            identifier: "reward-\(UUID().uuidString)",
            content: content,
            trigger: UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        )

        UNUserNotificationCenter.current().add(request)
    }
}
