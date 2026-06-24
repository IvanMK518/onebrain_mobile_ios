//
//  Theme.swift
//  OneBrain_Mobile
//
//  OneBrain design tokens — mirrors the web app (web/src/components/rp/tokens.ts) so the mobile
//  UI stays on-brand: teal accent, system-adaptive paper/ink (light + dark), and the semantic
//  colours (lesion, grounded-claim green/amber, pathway badges).
//

import SwiftUI
import UIKit

extension Color {
    init(hex: UInt) {
        self.init(
            .sRGB,
            red: Double((hex >> 16) & 0xFF) / 255,
            green: Double((hex >> 8) & 0xFF) / 255,
            blue: Double(hex & 0xFF) / 255,
            opacity: 1
        )
    }
}

enum RP {
    // Brand / accent
    static let mark = Color(hex: 0x0D9488)            // teal
    static let accent = mark

    // Semantic
    static let lesion = Color(hex: 0xD6543A)
    static let groundFull = Color(hex: 0x3E8E5C)      // verified claim (green)
    static let groundAbstract = Color(hex: 0xC99A3C)  // abstract-only (amber)

    // Pathway badges (mirror the web SAMPLE_META)
    static let neuroOnc = Color(hex: 0xE0533B)
    static let vascular = Color(hex: 0xC9A227)
    static let functional = Color(hex: 0x2F8FC9)

    // Surfaces — system-adaptive (light + dark, like the web's --background/--card/--foreground)
    static let page = Color(.systemGroupedBackground)
    static let surface = Color(.secondarySystemGroupedBackground)
    static let ink = Color(.label)
    static let muted = Color(.secondaryLabel)
    static let faint = Color(.tertiaryLabel)
    static let border = Color(.separator)

    static func pathwayColor(_ pathway: String) -> Color {
        switch pathway {
        case "ischemic_stroke": return vascular
        case "structural": return functional
        default: return neuroOnc            // glioma / metastasis
        }
    }

    static func pathwayBadge(_ pathway: String) -> String {
        switch pathway {
        case "ischemic_stroke": return "Vascular"
        case "structural": return "Functional"
        default: return "Neuro-onc"
        }
    }

    /// Colour for a finding's evidence-strength chip (matches the report's grounding palette).
    static func strengthColor(_ strength: String) -> Color {
        let s = strength.lowercased()
        if s.contains("strong") || s.contains("high") { return groundFull }
        if s.contains("weak") || s.contains("low") || s.contains("limited") { return groundAbstract }
        return muted
    }
}
