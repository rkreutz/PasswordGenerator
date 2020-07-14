//
//  MasterPasswordView.swift
//  PasswordGenerator
//
//  Created by Rodrigo Kreutz on 27/06/20.
//  Copyright © 2020 Rodrigo Kreutz. All rights reserved.
//

import SwiftUI

struct MasterPasswordView: View {

    @Environment(\.sizeCategory) private var sizeCategory
    @EnvironmentObject private var appState: AppState

    @ObservedObject var viewModel = ViewModel()

    var body: some View {

        ScrollView {

            VStack(spacing: 48 / sizeCategory.modifier) {

                TextField(Strings.MasterPasswordView.placeholder, text: $viewModel.masterPassword)
                    .font(.system(.title, design: .monospaced))
                    .foregroundColor(.foreground)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)

                MainButton(
                    action: { self.viewModel.saveMasterPassword(self.appState) },
                    text: Strings.MasterPasswordView.save,
                    isEnabled: viewModel.isValid
                )

                Text(Strings.MasterPasswordView.title)
                    .font(.body)
                    .multilineTextAlignment(.leading)
            }
            .padding(16 / sizeCategory.modifier)
            .padding(.top, 32 / sizeCategory.modifier)
        }
        .accentColor(.accent)
        .background(
            Rectangle()
                .foregroundColor(.background01)
                .edgesIgnoringSafeArea(.all)
        )
        .emittingError($viewModel.error)
    }
}

#if DEBUG

struct MasterPasswordView_Previews: PreviewProvider {

    static var previews: some View {

        Group {

            MasterPasswordView()
                .environment(\.colorScheme, .light)
                .previewDisplayName("Light")

            MasterPasswordView()
                .environment(\.colorScheme, .dark)
                .previewDisplayName("Dark")

            ForEach(ContentSizeCategory.allCases, id: \.hashValue) { category in

                MasterPasswordView()
                    .environment(\.sizeCategory, category)
                    .previewDisplayName("\(category)")
            }
        }
        .use(masterPasswordStorage: MockMasterPasswordStorage())
        .environmentObject(AppState(state: .mustProvideMasterPassword))
    }
}

#endif
