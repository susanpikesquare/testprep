import SwiftUI

struct WinsView: View {
    let progress: LearnerProgress

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                TrophyHeroView(progress: progress)

                TrophyStatsGrid(progress: progress)

                BrandedRecentWinsView(wins: progress.recentWins)
            }
            .padding(20)
        }
        .background(AppTheme.background)
    }
}

private struct TrophyHeroView: View {
    let progress: LearnerProgress

    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            HStack(alignment: .top, spacing: 14) {
                ZStack {
                    Circle()
                        .fill(AppTheme.gold)
                    Image(systemName: "sparkles")
                        .font(.system(size: 34, weight: .black))
                        .foregroundStyle(.white)
                }
                .frame(width: 72, height: 72)
                .shadow(color: AppTheme.gold.opacity(0.35), radius: 12, y: 6)

                VStack(alignment: .leading, spacing: 6) {
                    Text("Trophy Room")
                        .font(.largeTitle.bold())
                        .foregroundStyle(.white)
                    Text("Every coin, blocker, and cleared land proves the quest is moving.")
                        .font(.body.weight(.semibold))
                        .foregroundStyle(.white.opacity(0.82))
                        .fixedSize(horizontal: false, vertical: true)
                }
            }

            HStack(spacing: 12) {
                TrophyPill(icon: "star.fill", title: "Level", value: "\(progress.level)")
                TrophyPill(icon: "crown.fill", title: "Rank", value: progress.rankTitle)
            }
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(AppTheme.adventureGradient, in: RoundedRectangle(cornerRadius: 18, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .stroke(AppTheme.gold, lineWidth: 3)
        )
        .shadow(color: AppTheme.primary.opacity(0.20), radius: 16, y: 8)
    }
}

private struct TrophyPill: View {
    let icon: String
    let title: String
    let value: String

    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: icon)
                .foregroundStyle(AppTheme.gold)
            VStack(alignment: .leading, spacing: 1) {
                Text(title.uppercased())
                    .font(.caption2.bold())
                    .foregroundStyle(.white.opacity(0.70))
                Text(value)
                    .font(.subheadline.bold())
                    .foregroundStyle(.white)
                    .lineLimit(1)
                    .minimumScaleFactor(0.75)
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 10)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.white.opacity(0.15), in: RoundedRectangle(cornerRadius: 10, style: .continuous))
    }
}

private struct TrophyStatsGrid: View {
    let progress: LearnerProgress

    private var stats: [TrophyStat] {
        [
            TrophyStat(title: "Lifetime Gold", value: "\(progress.lifetimeCoins)", icon: "dollarsign.circle.fill", color: AppTheme.gold),
            TrophyStat(title: "XP Earned", value: "\(progress.xp)", icon: "bolt.fill", color: AppTheme.sky),
            TrophyStat(title: "Blockers", value: "\(progress.monstersDefeated)", icon: "shield.lefthalf.filled", color: AppTheme.royalBlue),
            TrophyStat(title: "Lands", value: "\(progress.landsCleared)", icon: "map.fill", color: AppTheme.green),
            TrophyStat(title: "Sessions", value: "\(progress.sessionsCompleted)", icon: "flag.checkered", color: AppTheme.orange),
            TrophyStat(title: "Correct", value: "\(progress.correctAnswers)", icon: "checkmark.seal.fill", color: AppTheme.purple)
        ]
    }

    var body: some View {
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
            ForEach(stats) { stat in
                TrophyStatTile(stat: stat)
            }
        }
    }
}

private struct TrophyStat: Identifiable {
    let id = UUID()
    let title: String
    let value: String
    let icon: String
    let color: Color
}

private struct TrophyStatTile: View {
    let stat: TrophyStat

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Image(systemName: stat.icon)
                .font(.title2.bold())
                .foregroundStyle(.white)
                .frame(width: 42, height: 42)
                .background(stat.color, in: RoundedRectangle(cornerRadius: 10, style: .continuous))

            VStack(alignment: .leading, spacing: 2) {
                Text(stat.value)
                    .font(.title.bold())
                    .foregroundStyle(AppTheme.ink)
                    .lineLimit(1)
                    .minimumScaleFactor(0.75)
                Text(stat.title)
                    .font(.caption.bold())
                    .foregroundStyle(.secondary)
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity, minHeight: 138, alignment: .leading)
        .background(AppTheme.surface, in: RoundedRectangle(cornerRadius: 14, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .stroke(stat.color.opacity(0.35), lineWidth: 2)
        )
    }
}

private struct BrandedRecentWinsView: View {
    let wins: [String]

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack {
                Image(systemName: "trophy.fill")
                    .foregroundStyle(AppTheme.gold)
                Text("Recent wins")
                    .font(.headline)
                    .foregroundStyle(AppTheme.ink)
            }

            ForEach(Array(wins.enumerated()), id: \.offset) { index, win in
                HStack(alignment: .top, spacing: 12) {
                    Text("\(index + 1)")
                        .font(.caption.bold())
                        .foregroundStyle(AppTheme.navy)
                        .frame(width: 28, height: 28)
                        .background(AppTheme.gold, in: Circle())

                    Text(win)
                        .font(.body.weight(.medium))
                        .foregroundStyle(AppTheme.ink)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .padding(12)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(AppTheme.background, in: RoundedRectangle(cornerRadius: 10, style: .continuous))
            }
        }
        .padding(16)
        .background(AppTheme.surface, in: RoundedRectangle(cornerRadius: 14, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .stroke(AppTheme.gold.opacity(0.45), lineWidth: 2)
        )
    }
}

#Preview {
    WinsView(progress: LearnerProgress())
}
