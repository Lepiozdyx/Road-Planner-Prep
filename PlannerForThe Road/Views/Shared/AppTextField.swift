import SwiftUI

struct AppTextField: View {
    let label: String
    let placeholder: String
    @Binding var text: String
    var keyboardType: UIKeyboardType = .default
    var focus: FocusState<Bool>.Binding? = nil

    var body: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.labelToField) {
            Text(label)
                .font(.system(size: 14, weight: .medium))
                .foregroundStyle(AppTheme.Colors.textSecondary)

            Group {
                if let focus {
                    TextField(placeholder, text: $text)
                        .focused(focus)
                } else {
                    TextField(placeholder, text: $text)
                }
            }
            .font(.system(size: 16, weight: .regular))
            .foregroundStyle(AppTheme.Colors.textPrimary)
            .keyboardType(keyboardType)
            .tint(AppTheme.Colors.accentPrimary)
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .frame(height: AppTheme.Size.inputHeight)
            .background(AppTheme.Colors.surfaceElevated)
            .clipShape(RoundedRectangle(cornerRadius: AppTheme.Radius.input))
        }
    }
}

struct AppTextArea: View {
    let label: String
    let placeholder: String
    @Binding var text: String
    var focus: FocusState<Bool>.Binding? = nil

    var body: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.labelToField) {
            Text(label)
                .font(.system(size: 14, weight: .medium))
                .foregroundStyle(AppTheme.Colors.textSecondary)

            ZStack(alignment: .topLeading) {
                if text.isEmpty {
                    Text(placeholder)
                        .font(.system(size: 16))
                        .foregroundStyle(AppTheme.Colors.textTertiary.opacity(0.5))
                        .padding(.horizontal, 12)
                        .padding(.top, 12)
                }
                Group {
                    if let focus {
                        TextEditor(text: $text)
                            .focused(focus)
                    } else {
                        TextEditor(text: $text)
                    }
                }
                .font(.system(size: 16))
                .foregroundStyle(AppTheme.Colors.textPrimary)
                .tint(AppTheme.Colors.accentPrimary)
                .scrollContentBackground(.hidden)
                .padding(8)
                .frame(height: AppTheme.Size.textAreaHeight)
            }
            .background(AppTheme.Colors.surfaceElevated)
            .clipShape(RoundedRectangle(cornerRadius: AppTheme.Radius.input))
        }
    }
}

#Preview {
    @Previewable @State var text = "Sample input"
    @Previewable @State var notes = ""
    AppShell {
        VStack(spacing: 16) {
            AppTextField(label: "Trip Title", placeholder: "e.g., Paris → Barcelona", text: $text)
            AppTextField(label: "Trip Title", placeholder: "e.g., Paris → Barcelona", text: .constant(""))
            AppTextArea(label: "Description", placeholder: "Add notes here...", text: $notes)
        }
        .padding()
    }
}
