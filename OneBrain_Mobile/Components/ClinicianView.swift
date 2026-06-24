//
//  ClinicianView.swift
//  OneBrain_Mobile
//
//  Created by Ivan Martinez-Kay on 6/24/26.
//
//  The case picker — the demo grid (mirrors the web "Explore a demo"). Tapping a case opens its
//  clinical vignette (PatientView); from there the clinician taps "View" to reach the evidence report.
//

import SwiftUI
import UIKit

struct ClinicianView: View {
    private let demos = DemoStore.demos

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Explore a demo")
                            .font(.title2.weight(.semibold))
                            .foregroundStyle(RP.ink)
                        Text("Real saved cases. Open one to read the vignette, then view the grounded evidence report.")
                            .font(.subheadline)
                            .foregroundStyle(RP.muted)
                    }

                    if demos.isEmpty {
                        Text("No demo cases bundled.")
                            .font(.subheadline)
                            .foregroundStyle(RP.muted)
                            .padding(.top, 24)
                    } else {
                        ForEach(demos) { demo in
                            NavigationLink(value: demo) {
                                DemoCard(demo: demo)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
                .padding(20)
            }
            .background(RP.page.ignoresSafeArea())
            .navigationTitle("OneBrain")
            .navigationDestination(for: Demo.self) { demo in
                PatientView(demo: demo)
            }
        }
        .tint(RP.accent)
    }
}

/// A demo case row: brain-slice thumbnail + label/blurb + pathway badge.
struct DemoCard: View {
    let demo: Demo

    var body: some View {
        HStack(spacing: 14) {
            ZStack {
                Color.black
                if let img = previewImage(named: demo.preview) {
                    Image(uiImage: img)
                        .resizable()
                        .scaledToFit()
                        .padding(4)
                } else {
                    Circle()
                        .fill(RP.pathwayColor(demo.pathway).opacity(0.85))
                        .frame(width: 26, height: 18)
                        .blur(radius: 1)
                }
            }
            .frame(width: 76, height: 76)
            .clipShape(RoundedRectangle(cornerRadius: 12))

            VStack(alignment: .leading, spacing: 4) {
                Text(demo.label)
                    .font(.headline)
                    .foregroundStyle(RP.ink)
                Text(demo.blurb)
                    .font(.subheadline)
                    .foregroundStyle(RP.muted)
                    .lineLimit(2)
                Text(demo.patientLine)
                    .font(.caption)
                    .foregroundStyle(RP.faint)
            }

            Spacer(minLength: 0)

            VStack(alignment: .trailing, spacing: 10) {
                Text(RP.pathwayBadge(demo.pathway).uppercased())
                    .font(.caption2.weight(.semibold))
                    .foregroundStyle(RP.pathwayColor(demo.pathway))
                    .padding(.horizontal, 8)
                    .padding(.vertical, 3)
                    .background(RP.pathwayColor(demo.pathway).opacity(0.14), in: Capsule())
                Image(systemName: "chevron.right")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(RP.faint)
            }
        }
        .padding(14)
        .background(RP.surface, in: RoundedRectangle(cornerRadius: 16))
        .overlay(RoundedRectangle(cornerRadius: 16).stroke(RP.border, lineWidth: 0.5))
    }
}

#Preview {
    ClinicianView()
}
