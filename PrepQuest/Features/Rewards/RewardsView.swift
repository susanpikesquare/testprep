import SwiftUI

struct RewardsView: View {
    @Binding var progress: LearnerProgress
    @State private var selectedReward: RewardItem?
    @State private var showingRewardRequest = false
    @State private var completedRewardTitle = ""
    @State private var showingFulfilledAlert = false
    @State private var bankerName = ""
    @State private var pairingCode = ""
    @State private var setupMessage = ""
    @State private var notificationsMessage = ""

    private let rewards = [
        RewardItem(title: "$0.50 Apple Cash", cost: 50, iconName: "centsign.circle.fill", detail: "Fast first payout"),
        RewardItem(title: "$1 Apple Cash", cost: 100, iconName: "dollarsign.circle.fill", detail: "A quick win payout"),
        RewardItem(title: "$5 Apple Cash", cost: 500, iconName: "banknote.fill", detail: "Manual transfer after approval"),
        RewardItem(title: "$10 Apple Cash", cost: 1000, iconName: "creditcard.fill", detail: "Bigger cash-out goal"),
        RewardItem(title: "Snack run", cost: 750, iconName: "takeoutbag.and.cup.and.straw.fill", detail: "Pick a favorite snack"),
        RewardItem(title: "Game time bonus", cost: 400, iconName: "gamecontroller.fill", detail: "Extra guilt-free play time")
    ]

    private var pendingRequests: [RewardRedemption] {
        progress.rewardRequests.filter { $0.status == .pending }
    }

    private var fulfilledRequests: [RewardRedemption] {
        progress.rewardRequests.filter { $0.status == .fulfilled }
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                BrandedPageHeroView(
                    title: "Coin Vault",
                    subtitle: "Gold earned in quests can be cashed in through a trusted banker when rewards are due.",
                    iconName: "dollarsign.circle.fill",
                    badgeText: "Gold / Rewards"
                )

                VStack(alignment: .leading, spacing: 12) {
                    HStack(alignment: .center, spacing: 14) {
                        ZStack {
                            Circle()
                                .fill(AppTheme.gold)
                            Image(systemName: "star.fill")
                                .font(.title.bold())
                                .foregroundStyle(.white)
                        }
                        .frame(width: 68, height: 68)

                        VStack(alignment: .leading, spacing: 4) {
                            Text("\(progress.coins) gold")
                                .font(.largeTitle.bold())
                                .foregroundStyle(.white)
                                .lineLimit(1)
                                .minimumScaleFactor(0.75)
                            Text("Available cash value: \(progress.coinCashValueText)")
                                .font(.headline)
                                .foregroundStyle(.white.opacity(0.82))
                        }
                    }

                    Text("100 gold = $1.00. The student requests rewards here; the banker approves and pays them manually.")
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(.white.opacity(0.80))
                }
                .padding(18)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(AppTheme.adventureGradient, in: RoundedRectangle(cornerRadius: 18, style: .continuous))
                .overlay(
                    RoundedRectangle(cornerRadius: 18, style: .continuous)
                        .stroke(AppTheme.gold, lineWidth: 3)
                )

                PairingCodeCard(code: progress.learnerCode)

                BankerSetupCard(
                    bankerName: $bankerName,
                    pairingCode: $pairingCode,
                    setupMessage: setupMessage,
                    notificationsMessage: notificationsMessage,
                    connectedBankers: progress.bankers,
                    expectedCode: progress.learnerCode,
                    saveAction: saveBanker,
                    enableNotificationsAction: enableNotifications
                )

                if !pendingRequests.isEmpty {
                    VStack(alignment: .leading, spacing: 12) {
                        SectionTitle(iconName: "hourglass.circle.fill", title: "Pending payout")

                        ForEach(pendingRequests) { request in
                            PendingRewardCard(
                                request: request,
                                markPaidAction: {
                                    progress.markRewardFulfilled(request.id)
                                    completedRewardTitle = request.title
                                    showingFulfilledAlert = true
                                    RewardFeedback.coinEarned()
                                },
                                cancelAction: {
                                    progress.cancelRewardRequest(request.id)
                                    RewardFeedback.wrongTurn()
                                }
                            )
                        }
                    }
                }

                VStack(alignment: .leading, spacing: 12) {
                    SectionTitle(iconName: "gift.fill", title: "Reward shop")

                    ForEach(rewards) { reward in
                        Button {
                            if progress.coins >= reward.cost {
                                selectedReward = reward
                                showingRewardRequest = true
                            } else {
                                RewardFeedback.wrongTurn()
                            }
                        } label: {
                            RewardShopRow(reward: reward, canAfford: progress.coins >= reward.cost)
                        }
                        .buttonStyle(.plain)
                    }
                }

                if !fulfilledRequests.isEmpty {
                    VStack(alignment: .leading, spacing: 12) {
                        SectionTitle(iconName: "checkmark.seal.fill", title: "Paid rewards")

                        ForEach(fulfilledRequests.prefix(5)) { request in
                            FulfilledRewardRow(request: request)
                        }
                    }
                }
            }
            .padding(20)
        }
        .background(AppTheme.background)
        .confirmationDialog("Request reward?", isPresented: $showingRewardRequest) {
            if let selectedReward {
                Button("Request \(selectedReward.title)") {
                    progress.requestReward(title: selectedReward.title, cost: selectedReward.cost)
                    notifyBankers(reward: selectedReward)
                    RewardFeedback.coinEarned()
                    self.selectedReward = nil
                }
            }
            Button("Cancel", role: .cancel) {
                selectedReward = nil
            }
        } message: {
            if let selectedReward {
                Text("\(selectedReward.cost) coins will move into pending payout. You can mark it paid after sending the real reward.")
            } else {
                Text("Coins will move into pending payout. You can mark it paid after sending the real reward.")
            }
        }
        .alert("Reward marked paid", isPresented: $showingFulfilledAlert) {
            Button("OK") {}
        } message: {
            Text("\(completedRewardTitle) is now in the paid rewards history.")
        }
    }

    private func saveBanker() {
        let enteredCode = pairingCode.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        guard enteredCode == progress.learnerCode else {
            setupMessage = "Code does not match this student."
            RewardFeedback.wrongTurn()
            return
        }

        progress.addBanker(name: bankerName)
        bankerName = ""
        pairingCode = ""
        setupMessage = "Banker connected."
        RewardFeedback.coinEarned()
    }

    private func notifyBankers(reward: RewardItem) {
        guard progress.bankers.contains(where: \.notificationsEnabled) else { return }

        NativeNotificationManager.scheduleRewardDue(
            rewardTitle: reward.title,
            cost: reward.cost,
            learnerCode: progress.learnerCode,
            coinsRemaining: progress.coins
        )
    }

    private func enableNotifications() {
        Task {
            let allowed = await NativeNotificationManager.requestAuthorization()
            await MainActor.run {
                notificationsMessage = allowed ? "Native iOS notifications enabled." : "Notifications were not enabled. Check iOS Settings."
                if allowed {
                    RewardFeedback.coinEarned()
                } else {
                    RewardFeedback.wrongTurn()
                }
            }
        }
    }
}

private struct RewardItem: Identifiable {
    var id: String { title }
    let title: String
    let cost: Int
    let iconName: String
    let detail: String
}

private struct PairingCodeCard: View {
    let code: String

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                SectionTitle(iconName: "key.fill", title: "Student banking code")
                Spacer()
            }
            Text(code)
                .font(.system(size: 34, weight: .heavy, design: .monospaced))
                .foregroundStyle(AppTheme.navy)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .background(AppTheme.gold.opacity(0.18), in: RoundedRectangle(cornerRadius: 10, style: .continuous))
            Text("Give this code to a banker so they can connect progress alerts and reward payouts.")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .padding(16)
        .background(AppTheme.surface, in: RoundedRectangle(cornerRadius: 14, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .stroke(AppTheme.gold.opacity(0.45), lineWidth: 2)
        )
    }
}

private struct BankerSetupCard: View {
    @Binding var bankerName: String
    @Binding var pairingCode: String
    let setupMessage: String
    let notificationsMessage: String
    let connectedBankers: [RewardBanker]
    let expectedCode: String
    let saveAction: () -> Void
    let enableNotificationsAction: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack {
                SectionTitle(iconName: "person.2.fill", title: "Banker setup")
                Spacer()
                Label("\(connectedBankers.count)", systemImage: "person.2.fill")
                    .font(.caption.weight(.bold))
                    .foregroundStyle(AppTheme.royalBlue)
            }

            VStack(spacing: 10) {
                TextField("Banker name", text: $bankerName)
                    .textInputAutocapitalization(.words)
                    .textFieldStyle(.roundedBorder)
                TextField("Student code", text: $pairingCode)
                    .textInputAutocapitalization(.characters)
                    .textFieldStyle(.roundedBorder)
            }

            Button(action: saveAction) {
                Label("Connect banker", systemImage: "bell.badge.fill")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .tint(AppTheme.primary)
            .disabled(!canSave)

            if !setupMessage.isEmpty {
                Text(setupMessage)
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(setupMessage.contains("connected") ? AppTheme.mint : AppTheme.coral)
            }

            Button(action: enableNotificationsAction) {
                Label("Enable iOS notifications", systemImage: "iphone.radiowaves.left.and.right")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.bordered)
            .tint(AppTheme.primary)

            if !notificationsMessage.isEmpty {
                Text(notificationsMessage)
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(notificationsMessage.contains("enabled") ? AppTheme.mint : AppTheme.coral)
            }

            if !connectedBankers.isEmpty {
                VStack(alignment: .leading, spacing: 8) {
                    ForEach(connectedBankers) { banker in
                        HStack(spacing: 10) {
                            Image(systemName: "bell.fill")
                                .foregroundStyle(AppTheme.gold)
                            VStack(alignment: .leading, spacing: 2) {
                                Text(banker.name)
                                    .font(.subheadline.weight(.semibold))
                                Text("Native alerts connected \(banker.pairedAt.formatted(date: .abbreviated, time: .omitted))")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                            Spacer()
                        }
                    }
                }
                .padding(12)
                .background(AppTheme.background, in: RoundedRectangle(cornerRadius: 10, style: .continuous))
            }
        }
        .padding(16)
        .background(AppTheme.surface, in: RoundedRectangle(cornerRadius: 14, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .stroke(AppTheme.royalBlue.opacity(0.28), lineWidth: 2)
        )
    }

    private var canSave: Bool {
        !bankerName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        pairingCode.trimmingCharacters(in: .whitespacesAndNewlines).uppercased() == expectedCode
    }
}

private struct RewardShopRow: View {
    let reward: RewardItem
    let canAfford: Bool

    var body: some View {
        HStack(spacing: 14) {
            Image(systemName: reward.iconName)
                .font(.title2)
                .foregroundStyle(.white)
                .frame(width: 44, height: 44)
                .background(canAfford ? AppTheme.gold : Color.gray.opacity(0.45), in: RoundedRectangle(cornerRadius: 10, style: .continuous))
            VStack(alignment: .leading, spacing: 4) {
                Text(reward.title)
                    .font(.headline)
                    .foregroundStyle(AppTheme.ink)
                Text("\(reward.cost) coins · \(reward.detail)")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
            Spacer()
            Image(systemName: canAfford ? "arrow.up.circle.fill" : "lock.fill")
                .foregroundStyle(canAfford ? AppTheme.green : .secondary)
        }
        .padding(14)
        .background(AppTheme.surface, in: RoundedRectangle(cornerRadius: 12, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .stroke(canAfford ? AppTheme.gold.opacity(0.45) : Color.gray.opacity(0.16), lineWidth: 2)
        )
    }
}

private struct PendingRewardCard: View {
    let request: RewardRedemption
    let markPaidAction: () -> Void
    let cancelAction: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 12) {
                Image(systemName: "hourglass.circle.fill")
                    .font(.title2)
                    .foregroundStyle(AppTheme.gold)
                VStack(alignment: .leading, spacing: 4) {
                    Text(request.title)
                        .font(.headline)
                        .foregroundStyle(AppTheme.ink)
                    Text("\(request.cost) coins requested \(request.requestedAt.formatted(date: .abbreviated, time: .shortened))")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                Spacer()
            }

            HStack(spacing: 10) {
                Button(action: markPaidAction) {
                    Label("Mark paid", systemImage: "checkmark.circle.fill")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)

                Button(action: cancelAction) {
                    Label("Refund", systemImage: "arrow.uturn.backward.circle.fill")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.bordered)
            }
        }
        .padding(14)
        .background(AppTheme.surface, in: RoundedRectangle(cornerRadius: 12, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .stroke(AppTheme.gold.opacity(0.45), lineWidth: 2)
        )
    }
}

private struct FulfilledRewardRow: View {
    let request: RewardRedemption

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "checkmark.seal.fill")
                .foregroundStyle(AppTheme.mint)
            VStack(alignment: .leading, spacing: 2) {
                Text(request.title)
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(AppTheme.ink)
                if let fulfilledAt = request.fulfilledAt {
                    Text("Paid \(fulfilledAt.formatted(date: .abbreviated, time: .shortened))")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
            Spacer()
            Text("\(request.cost)")
                .font(.caption.monospacedDigit().weight(.bold))
                .foregroundStyle(.secondary)
        }
        .padding(12)
        .background(AppTheme.surface, in: RoundedRectangle(cornerRadius: 10, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .stroke(AppTheme.green.opacity(0.25), lineWidth: 1)
        )
    }
}

private struct SectionTitle: View {
    let iconName: String
    let title: String

    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: iconName)
                .foregroundStyle(AppTheme.gold)
            Text(title)
                .font(.headline)
                .foregroundStyle(AppTheme.ink)
        }
    }
}

#Preview {
    RewardsView(progress: .constant(LearnerProgress()))
}
