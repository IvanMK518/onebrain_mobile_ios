//
//  PatientView.swift
//  OneBrain_Mobile
//
//  Created by Ivan Martinez-Kay on 6/24/26.
//
//  The clinical vignette — clinicians read the case first. A "View" button then opens the
//  imaging + grounded evidence report (ReportView).
//

import SwiftUI

struct PatientView: View {
    let demo: Demo

    var body: some View {
        ZStack(alignment: .bottom) {
            ScrollView {
                VStack(alignment: .leading, spacing: 14) {
                    // header
                    HStack(alignment: .firstTextBaseline) {
                        VStack(alignment: .leading, spacing: 3) {
                            Text(demo.label)
                                .font(.title3.weight(.semibold))
                                .foregroundStyle(RP.ink)
                            Text(demo.patientLine)
                                .font(.subheadline)
                                .foregroundStyle(RP.muted)
                        }
                        Spacer()
                        Text(RP.pathwayBadge(demo.pathway).uppercased())
                            .font(.caption2.weight(.semibold))
                            .foregroundStyle(RP.pathwayColor(demo.pathway))
                            .padding(.horizontal, 8).padding(.vertical, 3)
                            .background(RP.pathwayColor(demo.pathway).opacity(0.14), in: Capsule())
                    }

                    Label("Clinical vignette", systemImage: "doc.text")
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(RP.faint)
                        .textCase(.uppercase)
                        .padding(.top, 4)

                    VignetteText(demo.vignette)
                        .padding(16)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(RP.surface, in: RoundedRectangle(cornerRadius: 16))
                        .overlay(RoundedRectangle(cornerRadius: 16).stroke(RP.border, lineWidth: 0.5))
                }
                .padding(20)
                .padding(.bottom, 90)   // clear the floating button
            }

            // View → the evidence report
            NavigationLink {
                ReportView(demo: demo)
            } label: {
                HStack {
                    Text("View evidence report")
                        .font(.headline)
                    Image(systemName: "arrow.right")
                        .font(.subheadline.weight(.semibold))
                }
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 15)
                .background(RP.accent, in: RoundedRectangle(cornerRadius: 14))
                .shadow(color: .black.opacity(0.12), radius: 8, y: 2)
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 12)
        }
        .background(RP.page.ignoresSafeArea())
        .navigationTitle(demo.label)
        .navigationBarTitleDisplayMode(.inline)
    }
}

/// Lightweight renderer for the clinical note: Markdown-ish `#`/`##` lines become headings, blank
/// lines become spacing, everything else is body text. Keeps the vignette readable without a full
/// Markdown engine.
struct VignetteText: View {
    let text: String
    init(_ text: String) { self.text = text }

    var body: some View {
        VStack(alignment: .leading, spacing: 7) {
            ForEach(Array(lines.enumerated()), id: \.offset) { _, line in
                let trimmed = line.trimmingCharacters(in: .whitespaces)
                if trimmed.isEmpty {
                    Color.clear.frame(height: 4)
                } else if trimmed.hasPrefix("##") {
                    Text(strip(trimmed, "#"))
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(RP.ink)
                        .padding(.top, 4)
                } else if trimmed.hasPrefix("#") {
                    Text(strip(trimmed, "#"))
                        .font(.headline)
                        .foregroundStyle(RP.ink)
                        .padding(.top, 4)
                } else {
                    Text(trimmed)
                        .font(.callout)
                        .foregroundStyle(RP.ink)
                        .lineSpacing(2)
                }
            }
        }
    }

    private var lines: [String] { text.components(separatedBy: "\n") }
    private func strip(_ s: String, _ ch: Character) -> String {
        String(s.drop(while: { $0 == ch || $0 == " " }))
    }
}

#Preview {
    NavigationStack {
        if let d = DemoStore.demos.first { PatientView(demo: d) }
    }
}
