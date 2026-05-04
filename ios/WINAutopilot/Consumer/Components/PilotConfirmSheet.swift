import SwiftUI
import UIKit

struct PilotConfirmSheet: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var submitted: Bool
    @State private var businessName: String = ""
    @State private var ownerName: String = ""
    @State private var phone: String = ""
    @State private var slowHours: String = ""
    @State private var offerIdea: String = ""
    @State private var didSubmit = false
    @State private var copyConfirmed = false

    var body: some View {
        ZStack {
            ConsumerColors.bgWarm.ignoresSafeArea()

            if didSubmit {
                successView
            } else {
                ScrollView {
                    formView
                }
            }
        }
    }

    private var formView: some View {
        VStack(alignment: .leading, spacing: 14) {
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

            Text("WIN helps fill slow hours. You only pay when a real customer is generated.")
                .font(.system(size: 14))
                .foregroundStyle(ConsumerColors.textMid)
                .fixedSize(horizontal: false, vertical: true)

            VStack(spacing: 10) {
                inputField(title: "Business name", text: $businessName, placeholder: "Don Pepe Tacos")
                inputField(title: "Owner name", text: $ownerName, placeholder: "Maria Lopez")
                inputField(title: "Phone", text: $phone, placeholder: "(956) 555-0123", keyboard: .phonePad)
                inputField(title: "Best slow hours", text: $slowHours, placeholder: "Tue 2-4 PM, Sun 8-9 PM")
                inputField(title: "Offer idea", text: $offerIdea, placeholder: "2x1 tacos, free drink with combo…")
            }
            .padding(.top, 4)

            Button(action: submit) {
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

            HStack(spacing: 10) {
                Button(action: copyPilotInfo) {
                    HStack(spacing: 6) {
                        Image(systemName: copyConfirmed ? "checkmark" : "doc.on.doc")
                        Text(copyConfirmed ? "Copied" : "Copy Pilot Info")
                    }
                    .font(.system(size: 13, weight: .heavy))
                    .foregroundStyle(ConsumerColors.textDark)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(RoundedRectangle(cornerRadius: 12).fill(ConsumerColors.bgCard))
                    .overlay(RoundedRectangle(cornerRadius: 12).strokeBorder(ConsumerColors.borderLight, lineWidth: 1))
                }

                Button(action: textPilotInfo) {
                    HStack(spacing: 6) {
                        Image(systemName: "message.fill")
                        Text("Text Pilot Info")
                    }
                    .font(.system(size: 13, weight: .heavy))
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(RoundedRectangle(cornerRadius: 12).fill(ConsumerColors.green))
                }
            }

            Text("Demo only. Info stays on this device until you copy or text it.")
                .font(.system(size: 11))
                .foregroundStyle(ConsumerColors.textMuted)
                .frame(maxWidth: .infinity, alignment: .center)
        }
        .padding(.horizontal, 22)
        .padding(.top, 28)
        .padding(.bottom, 22)
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

            VStack(spacing: 10) {
                Button(action: copyPilotInfo) {
                    HStack(spacing: 6) {
                        Image(systemName: copyConfirmed ? "checkmark" : "doc.on.doc")
                        Text(copyConfirmed ? "Copied" : "Copy Pilot Info")
                    }
                    .font(.system(size: 14, weight: .heavy))
                    .foregroundStyle(ConsumerColors.textDark)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 13)
                    .background(RoundedRectangle(cornerRadius: 12).fill(ConsumerColors.bgCard))
                    .overlay(RoundedRectangle(cornerRadius: 12).strokeBorder(ConsumerColors.borderLight, lineWidth: 1))
                }

                Button(action: textPilotInfo) {
                    HStack(spacing: 6) {
                        Image(systemName: "message.fill")
                        Text("Text Pilot Info")
                    }
                    .font(.system(size: 14, weight: .heavy))
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 13)
                    .background(RoundedRectangle(cornerRadius: 12).fill(ConsumerColors.green))
                }
            }
            .padding(.horizontal, 22)

            Spacer()

            Button { dismiss() } label: {
                Text("Done")
                    .font(.system(size: 15, weight: .heavy))
                    .foregroundStyle(ConsumerColors.textDark)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(RoundedRectangle(cornerRadius: 14).fill(ConsumerColors.bgCard))
                    .overlay(RoundedRectangle(cornerRadius: 14).strokeBorder(ConsumerColors.borderLight, lineWidth: 1))
            }
            .padding(.horizontal, 22)
        }
        .padding(.bottom, 18)
    }

    private var canSubmit: Bool {
        !businessName.trimmingCharacters(in: .whitespaces).isEmpty
            && !phone.trimmingCharacters(in: .whitespaces).isEmpty
    }

    private func submit() {
        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
        withAnimation(.spring(response: 0.4, dampingFraction: 0.85)) {
            didSubmit = true
            submitted = true
        }
    }

    private func pilotInfoText() -> String {
        let trimmedOffer = offerIdea.trimmingCharacters(in: .whitespaces)
        let trimmedSlow = slowHours.trimmingCharacters(in: .whitespaces)
        let trimmedOwner = ownerName.trimmingCharacters(in: .whitespaces)
        return """
        WIN Pilot Request
        Business: \(businessName.isEmpty ? "—" : businessName)
        Owner: \(trimmedOwner.isEmpty ? "—" : trimmedOwner)
        Phone: \(phone.isEmpty ? "—" : phone)
        Slow hours: \(trimmedSlow.isEmpty ? "—" : trimmedSlow)
        Offer idea: \(trimmedOffer.isEmpty ? "—" : trimmedOffer)

        WIN helps fill slow hours. You only pay when a real customer is generated.
        """
    }

    private func copyPilotInfo() {
        UIPasteboard.general.string = pilotInfoText()
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
        withAnimation { copyConfirmed = true }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.6) {
            withAnimation { copyConfirmed = false }
        }
    }

    private func textPilotInfo() {
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
        let body = pilotInfoText()
        let encoded = body.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let digits = phone.filter { $0.isNumber || $0 == "+" }
        let urlString: String
        if digits.isEmpty {
            urlString = "sms:&body=\(encoded)"
        } else {
            urlString = "sms:\(digits)&body=\(encoded)"
        }
        if let url = URL(string: urlString) {
            UIApplication.shared.open(url)
        }
    }

    private func inputField(
        title: String,
        text: Binding<String>,
        placeholder: String,
        keyboard: UIKeyboardType = .default
    ) -> some View {
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
                .keyboardType(keyboard)
                .autocorrectionDisabled()
                .textInputAutocapitalization(keyboard == .phonePad ? .never : .words)
        }
    }
}
