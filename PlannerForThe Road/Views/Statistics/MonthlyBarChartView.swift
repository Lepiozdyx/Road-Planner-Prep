import SwiftUI
import Charts

struct MonthlyDistanceEntry: Identifiable {
    let id = UUID()
    let month: String
    let distance: Int
    let isHighlighted: Bool
}

struct MonthlyBarChartView: View {
    let entries: [MonthlyDistanceEntry]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Monthly Distance")
                .font(.system(size: 16, weight: .semibold))
                .foregroundStyle(AppTheme.Colors.textPrimary)

            Chart(entries) { entry in
                BarMark(
                    x: .value("Month", entry.month),
                    y: .value("km", entry.distance)
                )
                .foregroundStyle(entry.isHighlighted
                    ? AppTheme.Colors.accentSecondary
                    : AppTheme.Colors.accentPrimary)
                .cornerRadius(4)
            }
            .chartXAxis {
                AxisMarks(values: .automatic) { _ in
                    AxisValueLabel()
                        .foregroundStyle(AppTheme.Colors.textSecondary)
                        .font(.system(size: 12))
                }
            }
            .chartYAxis {
                AxisMarks(values: .automatic) { _ in
                    AxisGridLine()
                        .foregroundStyle(Color.white.opacity(0.14))
                    AxisValueLabel()
                        .foregroundStyle(AppTheme.Colors.textSecondary)
                        .font(.system(size: 12))
                }
            }
            .frame(height: 200)
        }
        .padding(16)
        .background(AppTheme.Colors.surfaceElevated)
        .clipShape(RoundedRectangle(cornerRadius: AppTheme.Radius.card))
    }
}

#Preview {
    AppShell {
        MonthlyBarChartView(entries: [
            MonthlyDistanceEntry(month: "Jan", distance: 800, isHighlighted: false),
            MonthlyDistanceEntry(month: "Feb", distance: 1700, isHighlighted: true),
            MonthlyDistanceEntry(month: "Mar", distance: 450, isHighlighted: false),
            MonthlyDistanceEntry(month: "Apr", distance: 700, isHighlighted: false)
        ])
        .padding()
    }
}
