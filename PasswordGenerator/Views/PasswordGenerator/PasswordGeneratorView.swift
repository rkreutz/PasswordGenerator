import SwiftUI
import UIKit
import Combine
import PasswordGeneratorKit

struct PasswordGeneratorView: View {

    @Environment(\.sizeCategory) private var sizeCategory

    @ObservedObject var viewModel: ViewModel = ViewModel()
    @EnvironmentObject private var appState: AppState

    var body: some View {

        ScrollView {

            VStack(alignment: .center, spacing: 16 * sizeCategory.modifier) {

                PasswordGeneratorView.ConfigurationView()

                LengthView()

                CharactersView()

                generatePasswordStateView(viewModel.passwordState)
            }
            .padding(16 / sizeCategory.modifier)
        }
        .accentColor(.accent)
        .background(
            Rectangle()
                .foregroundColor(.background01)
                .edgesIgnoringSafeArea(.all)
        )
        .emittingError($viewModel.error)
        .onAppear(perform: viewModel.bind)
        .navigationBarItems(
            trailing: Button(
                action: { self.viewModel.logout(self.appState) },
                label: {

                    Text(Strings.PasswordGeneratorView.resetMasterPassword)
                        .font(.headline)
                }
            )
        )
        .environmentObject(viewModel)
        .navigationBarTitle("", displayMode: .inline)
    }

    private func generatePasswordStateView(_ passwordState: PasswordState) -> AnyView {

        switch passwordState {

        case .invalid:
            return MainButton(
                action: {},
                text: Strings.PasswordGeneratorView.generatePassword,
                isEnabled: false
            ).asAny()

        case .readyToGenerate:
            return MainButton(
                action: { self.viewModel.generatePassword() },
                text: Strings.PasswordGeneratorView.generatePassword,
                isEnabled: true
            ).asAny()

        case .loading:
            return Loader()
                .frame(height: 44 * sizeCategory.modifier)
                .asAny()

        case let .generated(password):
            return CardView { CopyableContentView(content: password) }.asAny()
        }
    }
}
