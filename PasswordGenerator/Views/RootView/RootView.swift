//
//  RootView.swift
//  PasswordGenerator
//
//  Created by Rodrigo Kreutz on 12/07/20.
//  Copyright © 2020 Rodrigo Kreutz. All rights reserved.
//

import SwiftUI

struct RootView: View {

    @EnvironmentObject private var appState: AppState

    var body: some View {

        switch appState.state {

        case .masterPasswordSet:
            return NavigationView {

                PasswordGeneratorView()
            }.asAny()

        case .mustProvideMasterPassword:
            return MasterPasswordView().asAny()
        }
    }
}
