import SwiftUI

struct SkillMapView: View {
    let progress: LearnerProgress

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                BrandedPageHeroView(
                    title: "World Map",
                    subtitle: "Every subject is a land. Clear the smaller skills inside each zone to open the path forward.",
                    iconName: "map.fill",
                    badgeText: "Skill lands"
                )

                ForEach(NickBaselineScores.hisetPractice) { score in
                    SubjectZoneView(score: score, progress: progress)
                }
            }
            .padding(20)
        }
        .background(AppTheme.background)
    }
}

private struct SubjectZoneView: View {
    let score: AssessmentScore
    let progress: LearnerProgress

    private var subject: SubjectArea { score.subject }
    private var subjectColor: Color { AppTheme.subjectColor(subject) }

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(spacing: 10) {
                Image(systemName: subject.iconName)
                    .font(.title3.bold())
                    .foregroundStyle(.white)
                    .frame(width: 46, height: 46)
                    .background(subjectColor, in: RoundedRectangle(cornerRadius: 10, style: .continuous))
                VStack(alignment: .leading, spacing: 3) {
                    Text(zoneName)
                        .font(.headline)
                        .foregroundStyle(AppTheme.ink)
                    Text(subject.rawValue)
                        .font(.caption.bold())
                        .foregroundStyle(subjectColor)
                }
                Spacer()
                Text(score.scoreText)
                    .font(.caption.monospacedDigit().weight(.bold))
                    .foregroundStyle(AppTheme.navy)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background(AppTheme.gold.opacity(0.28), in: Capsule())
            }

            ProgressView(value: score.progress)
                .tint(subjectColor)
                .scaleEffect(x: 1, y: 1.35, anchor: .center)

            HStack(spacing: 10) {
                Label(score.readiness.title, systemImage: "flag.fill")
                    .font(.subheadline.weight(.bold))
                    .foregroundStyle(subjectColor)
                Spacer()
                Label("\(progress.answeredCount(for: subject)) answered", systemImage: "checkmark.seal.fill")
                    .font(.caption.weight(.bold))
                    .foregroundStyle(.secondary)
            }

            VStack(alignment: .leading, spacing: 8) {
                ForEach(subject.focusSkills, id: \.self) { skill in
                    HStack(spacing: 10) {
                        Image(systemName: "diamond.fill")
                            .font(.caption2)
                            .foregroundStyle(subjectColor)
                        Text(skill)
                            .font(.subheadline)
                    }
                }
            }
            .padding(12)
            .background(AppTheme.background, in: RoundedRectangle(cornerRadius: 10, style: .continuous))

            Text(score.readiness.message)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(16)
        .background(AppTheme.surface, in: RoundedRectangle(cornerRadius: 16, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .stroke(subjectColor.opacity(0.35), lineWidth: 2)
        )
    }

    private var zoneName: String {
        switch subject {
        case .reading:
            return "Storywood"
        case .writing:
            return "Grammar Gate"
        case .math:
            return "Number Peaks"
        case .science:
            return "Data Marsh"
        case .socialStudies:
            return "Civics Keep"
        }
    }
}

#Preview {
    SkillMapView(progress: LearnerProgress())
}
