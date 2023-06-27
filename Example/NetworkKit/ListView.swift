//
//  ListView.swift
//  NetworkKit_Example
//
//  Created by Nileshkumar M. Prajapati on 2023/06/26.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import SwiftUI


struct ListView: View {
    
    //MARK: - Properties
    
    @ObservedObject private var viewModel = ViewModel()
    
    private var isListVisible: Bool {
        self.viewModel.tracks.count > 0
    }
    
    //MARK: - Body
    
    var body: some View {
        VStack {
            GeometryReader { geometry in
                ZStack(alignment: .center) {
                    List {
                        ForEach($viewModel.tracks) {$track in
                            ListRowView(track: $track)
                        }
                    }//:List
                    .disabled(self.isListVisible == false)
                    .blur(radius: self.isListVisible ? 0 : 3)

                    VStack {
                        Text("Loading...")
                        ActivityIndicator(isAnimating: .constant(true), style: .large)
                    }//:VStack
                    .frame(width: geometry.size.width / 2,
                           height: geometry.size.height / 5)
                    .background(Color.secondary.colorInvert())
                    .foregroundColor(Color.primary)
                    .cornerRadius(20)
                    .opacity(self.isListVisible ? 0 : 1)
                }
            }
        }
        .onAppear {
            Task {
                await viewModel.callWebservice()
            }
        }
    }
}

//MARK: - Preview

struct ListView_Previews: PreviewProvider {
    static var previews: some View {
        ListView()
    }
}

//MARK: - ActivityIndicator

private struct ActivityIndicator: UIViewRepresentable {

    @Binding var isAnimating: Bool
    let style: UIActivityIndicatorView.Style

    func makeUIView(context: UIViewRepresentableContext<ActivityIndicator>) -> UIActivityIndicatorView {
        return UIActivityIndicatorView(style: style)
    }

    func updateUIView(_ uiView: UIActivityIndicatorView, context: UIViewRepresentableContext<ActivityIndicator>) {
        isAnimating ? uiView.startAnimating() : uiView.stopAnimating()
    }
}
