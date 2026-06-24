//
//  ReportView.swift
//  OneBrain_Mobile
//
//  The imaging + grounded evidence report (the "View" destination from the vignette). Mirrors the
//  web Results view minus the 3-D viewer: the rendered brain slice, the patient one-liner, the
//  involved structures, and the grounded findings (each cited, with an evidence-strength chip).
//

import SwiftUI
import UIKit

struct ReportView: View {
    let demo: Demo

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                imaging
                oneLiner
                if !demo.structures.isEmpty { structures }
                findings
                disclaimer
            }
            .padding(20)
        }
        .background(RP.page.ignoresSafeArea())
        .navigationTitle("Evidence report")
        .navigationBarTitleDisplayMode(.inline)
    }

    // Brain-slice preview
    private var imaging: some View {
        ZStack {
            Color.black
            if let img = previewImage(named: demo.preview) {
                Image(uiImage: img).resizable().scaledToFit()
            }
        }
        .frame(height: 220)
        .frame(maxWidth: .infinity)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .overlay(alignment: .bottomLeading) {
            Text(demo.label)
                .font(.caption.weight(.semibold))
                .foregroundStyle(.white)
                .padding(.horizontal, 10).padding(.vertical, 5)
                .background(.black.opacity(0.45), in: Capsule())
                .padding(12)
        }
    }

    private var oneLiner: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(demo.oneLiner.isEmpty ? demo.blurb : demo.oneLiner)
                .font(.body.weight(.medium))
                .foregroundStyle(RP.ink)
            HStack(spacing: 6) {
                Image(systemName: "books.vertical")
                    .font(.caption)
                Text("\(demo.nAnalyzed) sources analyzed · \(demo.nCited) cited")
                    .font(.caption)
            }
            .foregroundStyle(RP.muted)
        }
    }

    private var structures: some View {
        VStack(alignment: .leading, spacing: 8) {
            sectionLabel("Involved structures")
            FlowChips(demo.structures)
        }
    }

    private var findings: some View {
        VStack(alignment: .leading, spacing: 12) {
            sectionLabel("Findings")
            if demo.findings.isEmpty {
                Text("No grounded findings available for this demo.")
                    .font(.subheadline)
                    .foregroundStyle(RP.muted)
            } else {
                ForEach(demo.findings) { FindingCard(finding: $0) }
            }
        }
    }

    private var disclaimer: some View {
        Text("Decision-support only — not a diagnosis. Every finding is grounded in the cited sources; a missing answer is reported rather than fabricated.")
            .font(.caption2)
            .foregroundStyle(RP.faint)
            .padding(.top, 4)
    }

    private func sectionLabel(_ text: String) -> some View {
        Text(text.uppercased())
            .font(.caption.weight(.semibold))
            .foregroundStyle(RP.faint)
    }
}

private struct FindingCard: View {
    let finding: Finding

    var body: some View {
        VStack(alignment: .leading, spacing: 9) {
            Text(finding.title)
                .font(.headline)
                .foregroundStyle(RP.ink)
            if !finding.body.isEmpty {
                Text(finding.body)
                    .font(.callout)
                    .foregroundStyle(RP.ink)
                    .lineSpacing(2)
            }
            if !finding.bullets.isEmpty {
                VStack(alignment: .leading, spacing: 6) {
                    ForEach(finding.bullets, id: \.self) { b in
                        HStack(alignment: .top, spacing: 8) {
                            Circle().fill(RP.groundFull).frame(width: 5, height: 5).padding(.top, 6)
                            Text(b).font(.footnote).foregroundStyle(RP.muted)
                        }
                    }
                }
                .padding(.top, 2)
            }
            HStack(spacing: 8) {
                if !finding.strength.isEmpty {
                    Text(finding.strength.uppercased())
                        .font(.caption2.weight(.semibold))
                        .foregroundStyle(RP.strengthColor(finding.strength))
                        .padding(.horizontal, 7).padding(.vertical, 2)
                        .background(RP.strengthColor(finding.strength).opacity(0.14), in: Capsule())
                }
                if finding.sources > 0 {
                    Text("\(finding.sources) source\(finding.sources == 1 ? "" : "s")")
                        .font(.caption2)
                        .foregroundStyle(RP.faint)
                }
            }
            .padding(.top, 2)
        }
        .padding(15)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(RP.surface, in: RoundedRectangle(cornerRadius: 14))
        .overlay(RoundedRectangle(cornerRadius: 14).stroke(RP.border, lineWidth: 0.5))
    }
}

/// Simple wrapping chip layout for the involved structures.
private struct FlowChips: View {
    let items: [String]
    init(_ items: [String]) { self.items = items }

    var body: some View {
        FlowLayout(spacing: 7) {
            ForEach(items, id: \.self) { item in
                Text(item)
                    .font(.caption)
                    .foregroundStyle(RP.ink)
                    .padding(.horizontal, 10).padding(.vertical, 5)
                    .background(RP.surface, in: Capsule())
                    .overlay(Capsule().stroke(RP.border, lineWidth: 0.5))
            }
        }
    }
}

/// Minimal flow layout (wraps chips to the next line).
private struct FlowLayout: Layout {
    var spacing: CGFloat = 7

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout Void) -> CGSize {
        let maxWidth = proposal.width ?? .infinity
        var x: CGFloat = 0, y: CGFloat = 0, rowHeight: CGFloat = 0
        for v in subviews {
            let s = v.sizeThatFits(.unspecified)
            if x + s.width > maxWidth {
                x = 0; y += rowHeight + spacing; rowHeight = 0
            }
            x += s.width + spacing
            rowHeight = max(rowHeight, s.height)
        }
        return CGSize(width: maxWidth == .infinity ? x : maxWidth, height: y + rowHeight)
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout Void) {
        var x = bounds.minX, y = bounds.minY, rowHeight: CGFloat = 0
        for v in subviews {
            let s = v.sizeThatFits(.unspecified)
            if x + s.width > bounds.maxX {
                x = bounds.minX; y += rowHeight + spacing; rowHeight = 0
            }
            v.place(at: CGPoint(x: x, y: y), proposal: ProposedViewSize(s))
            x += s.width + spacing
            rowHeight = max(rowHeight, s.height)
        }
    }
}

#Preview {
    NavigationStack {
        if let d = DemoStore.demos.first { ReportView(demo: d) }
    }
}
