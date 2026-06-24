//
//  DemoModels.swift
//  OneBrain_Mobile
//
//  The bundled demo cases (Demos.json) — real saved OneBrain runs, one per pathway. This lets the
//  app run standalone for testing (no auth/backend yet); later the same models populate from the
//  live API. Each demo carries the clinical vignette + the grounded evidence report (one-liner +
//  findings + involved structures).
//

import Foundation
import UIKit

struct Finding: Codable, Hashable, Identifiable {
    var id: String { title }
    let title: String
    let body: String
    let bullets: [String]
    let strength: String
    let sources: Int
}

struct Demo: Codable, Hashable, Identifiable {
    var id: String { key }
    let key: String
    let label: String
    let blurb: String
    let pathway: String
    let age: String
    let sex: String
    let vignette: String
    let oneLiner: String
    let nAnalyzed: Int
    let nCited: Int
    let findings: [Finding]
    let structures: [String]
    let preview: String

    /// "47y · Male"
    var patientLine: String {
        let s = sex.isEmpty ? "" : sex.prefix(1).uppercased() + sex.dropFirst()
        return [age.isEmpty ? "" : "\(age)y", s].filter { !$0.isEmpty }.joined(separator: " · ")
    }
}

private struct DemoBundle: Codable { let demos: [Demo] }

enum DemoStore {
    static let demos: [Demo] = {
        guard let url = Bundle.main.url(forResource: "Demos", withExtension: "json"),
              let data = try? Data(contentsOf: url),
              let bundle = try? JSONDecoder().decode(DemoBundle.self, from: data)
        else { return [] }
        return bundle.demos
    }()
}

/// Load a bundled preview JPEG (the API-rendered axial brain slice). Tries the flat bundle, the
/// Previews/ subdirectory, then the asset catalog — robust to how Xcode flattens resources.
func previewImage(named name: String) -> UIImage? {
    for sub in [nil, "Previews"] as [String?] {
        if let url = Bundle.main.url(forResource: name, withExtension: "jpg", subdirectory: sub),
           let img = UIImage(contentsOfFile: url.path) {
            return img
        }
    }
    return UIImage(named: name)
}
