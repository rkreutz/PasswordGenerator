//
//  RootView.swift
//  PasswordGenerator
//
//  Created by Rodrigo Kreutz on 12/07/20.
//  Copyright © 2020 Rodrigo Kreutz. All rights reserved.
//

import SwiftUI

struct RootView: View {

    @Environment(\.masterPasswordValidator) private var masterPasswordValidator
    @EnvironmentObject private var appState: AppState

    var body: some View {

        if masterPasswordValidator.hasMasterPassword {

            return NavigationView {

                PasswordGeneratorView()
            }.asAny()
        } else {

            return MasterPasswordView().asAny()
        }
    }
}
