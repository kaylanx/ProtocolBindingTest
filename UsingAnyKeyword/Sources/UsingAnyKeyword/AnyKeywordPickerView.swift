import SwiftUI

public protocol PickerOption: Identifiable, Hashable {
    associatedtype Id
    var id: Id { get }
    var description: String { get }
}

public protocol PickerViewViewModel: AnyObject {
    associatedtype Option: PickerOption
    var selectedPickerOption: Option? { get set }
    var pickerOptions: [Option] { get }
    func optionChanged(to pickerOption: Option?)
}

public struct AnyKeywordPickerView<Option: PickerOption, ViewModel: PickerViewViewModel>: View where ViewModel.Option == Option {
    
    private var viewModel: ViewModel
    @State private var selectedOption: Option?

    public init(viewModel: ViewModel) {
        self.viewModel = viewModel
        self._selectedOption = State(initialValue: viewModel.selectedPickerOption)
    }
    
    public var body: some View {
        Picker("", selection: $selectedOption) {
            ForEach(viewModel.pickerOptions, id: \.self) { option in
                Text(option.description)
                    .tag(Optional(option))
            }
        }
        .pickerStyle(.menu)
        .onChange(of: selectedOption) { newValue in
            viewModel.optionChanged(to: newValue)
        }
    }
}
