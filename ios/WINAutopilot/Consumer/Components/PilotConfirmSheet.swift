import SwiftUI
import UIKit

struct PilotConfirmSheet: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var submitted: Bool
    @State private var businessName: String = ""
    @State private var contact: String = ""
    @State private var didSubmit = false

    var body: some View {
        ZStack {
            ConsumerColors.bgWarm.ignoresSafeArea()

            if didSubmit {
                successView
            } else {
                formView
            }
        }
    }

    private var formView: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(spacing: 6) {
                Image(systemName: "bolt.fill")
                    .font(.system(size: 11, weight: .heavy))
                    .foregroundStyle(ConsumerColors.retailBlue)
                Text("PILOT PROGRAM")
                    .font(.system(size: 9, weight: .heavy))
                    .tracking(1.2)
                    .foregroundStyle(ConsumerColors.retailBlue)
            }
            .padding(.horizontal, 8)
            .padding(.vertical, 5)
            .background(Capsule().fill(ConsumerColors.retailBlueSoft))

            Text("Join the WIN pilot")
                .font(.system(size: 26, weight: .heavy))
                .foregroundStyle(ConsumerColors.textDark)

            Text("WIN fills your slow hours with real customers. You only pay when a customer is generated.")
                .font(.system(size: 14))
                .foregroundStyle(ConsumerColors.textMid)
                .fixedSize(horizontal: false, vertical: true)

            VStack(spacing: 10) {
                inputField(title: "Business name", text: $businessName, placeholder: "Don Pepe Tacos")
                inputField(title: "Phone or email", text: $contact, placeholder: "owner@example.com")
            }
            .padding(.top, 4)

            Spacer()

            Button {
                UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                withAnimation(.spring(response: 0.4, dampingFraction: 0.85)) {
                    didSubmit = true
                    submitted = true
                }
            } label: {
                Text("Submit pilot request")
                    .font(.system(size: 15, weight: .heavy))
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(
                        LinearGradient(
                            colors: [ConsumerColors.retailBlue, ConsumerColors.retailBlue.opacity(0.85)],
                            startPoint: .topLeading, endPoint: .bottomTrailing
                        )
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 14))
                    .opacity(canSubmit ? 1 : 0.5)
            }
            .disabled(!canSubmit)

            Text("Demo only. No real submission is sent.")
                .font(.system(size: 11))
                .foregroundStyle(ConsumerColors.textMuted)
                .frame(maxWidth: .infinity, alignment: .center)
        }
        .padding(.horizontal, 22)
        .padding(.top, 28)
        .padding(.bottom, 18)
    }

    private var successView: some View {
        VStack(spacing: 16) {
            Spacer()
            ZStack {
                Circle().fill(ConsumerColors.greenSoft).frame(width: 76, height: 76)
                Image(systemName: "checkmark")
                    .font(.system(size: 30, weight: .heavy))
                    .foregroundStyle(ConsumerColors.green)
            }

            Text("Pilot request captured")
                .font(.system(size: 22, weight: .heavy))
                .foregroundStyle(ConsumerColors.textDark)

            Text("We'll contact you to set up your slow hours and first AI offers.")
                .font(.system(size: 14))
                .foregroundStyle(ConsumerColors.textMid)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 24)

            Spacer()

            Button {
                dismiss()
            } label: {
                Text("Done")
                    .font(.system(size: 15, weight: .heavy))
                    .foregroundStyle(ConsumerColors.textDark)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(RoundedRectangle(cornerRadius: 14).fill(ConsumerColors.bgCard))
                    .overlay(RoundedRectangle(cornerRadius: 14).strokeBorder(ConsumerColors.borderLight, lineWidth: 1))
            }
        }
        .padding(.horizontal, 22)
        .padding(.bottom, 18)
    }

    private var canSubmit: Bool {
        !businessName.trimmingCharacters(in: .whitespaces).isEmpty
            && !contact.trimmingCharacters(in: .whitespaces).isEmpty
    }

    private func inputField(title: String, text: Binding<String>, placeholder: String) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title.uppercased())
                .font(.system(size: 9, weight: .heavy))
                .tracking(1.0)
                .foregroundStyle(ConsumerColors.textMuted)
            TextField(placeholder, text: text)
                .font(.system(size: 15, weight: .medium))
                .foregroundStyle(ConsumerColors.textDark)
                .padding(.horizontal, 14)
                .padding(.vertical, 12)
                .background(RoundedRectangle(cornerRadius: 12).fill(ConsumerColors.bgCard))
                .overlay(RoundedRectangle(cornerRadius: 12).strokeBorder(ConsumerColors.borderLight, lineWidth: 1))
                .autocorrectionDisabled()
                .textInputAutocapitalization(.words)
        }
    }
}
