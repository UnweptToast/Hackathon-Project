//
//  CustomTextField.swift
//  hackathon-project
//
//  Created by Sanchith on 2/1/23.
//

import Foundation
import SwiftUI

struct CustomTextField: UIViewRepresentable {
    
    var placeholder: String
    
    @State var text = ""
    
    func makeUIView(context: Context) -> UITextField {
        
        let field = UITextField()
        field.placeholder = placeholder
        field.addTarget(self, action: #selector(CustomTextFieldAction.shared.edited), for: .allEditingEvents)
        return field
    }
    
    func updateUIView(_ uiView: UITextField, context: Context) {
        
    }

}

class CustomTextFieldAction {
    
    static let shared = CustomTextFieldAction()
    
    private init() {}
    
    @objc public func edited() {
        print("Hello")
    }
}
