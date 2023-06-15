import SwiftUI

public protocol PickerOption {
    var description: String { get }
}

public protocol PickerViewViewModel: AnyObject {
    var selectedPickerOption: AnyPickerOption? { get set }
    var pickerOptions: [AnyPickerOption] { get }
    func optionChanged(to pickerOption: AnyPickerOption?)
}

public class AnyPickerOption: PickerOption, Hashable, Identifiable {
    
    public static func == (lhs: AnyPickerOption, rhs: AnyPickerOption) -> Bool {
        lhs.wrapped.description == rhs.wrapped.description
    }
    
    public func hash(into hasher: inout Hasher) {
        return hasher.combine(description)
    }
    
    public let wrapped: PickerOption
    
    public init(wrapped: PickerOption) {
        self.wrapped = wrapped
    }
    
    public var id: String { wrapped.description }
    public var description: String { wrapped.description }
}

public struct TypeErasedPickerView: View {
    
    private var viewModel: PickerViewViewModel
    @State private var selectedOption: AnyPickerOption?

    public init(viewModel: PickerViewViewModel) {
        self.viewModel = viewModel
        self._selectedOption = State(initialValue: viewModel.selectedPickerOption)
    }
    
    public var body: some View {
        Picker("", selection: $selectedOption) {
            ForEach(viewModel.pickerOptions) {
                Text($0.description)
                    .tag(Optional($0))
            }
        }
        .pickerStyle(.menu)
        .onChange(of: selectedOption) { newValue in
            viewModel.optionChanged(to: newValue)
        }
    }
}
