//
//  ContentView.swift
//  OneBrain_Mobile
//
//  Created by Ivan Martinez-Kay on 6/24/26.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        // Demo mode for now: straight into the case picker. Later this becomes
        // Auth() → ClinicianView() once MSAL / Entra sign-in is wired.
        ClinicianView()
    }
}

#Preview {
    ContentView()
}
