//
//  ViewModel.swift
//  NetworkKit_Example
//
//  Created by Nileshkumar M. Prajapati on 2023/06/26.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import Foundation
import NetworkKit

class ViewModel: ObservableObject {
    
    //MARK: - Properties
    
    @Published var tracks: [Track] = []

    //MARK: - Methods
    
    @MainActor
    func callWebservice() async {
        guard let url = URL(string: "https://openwhyd.org/hot/electro?format=json") else { return }
        
        let resource = Resource<ResponseModel>(url: url,
                                              method: .get,
                                              body: nil) { data in
            return ResponseModel.decode(data)
        }
        
        if #available(iOS 15.0, *) {
            Task {
                let result = await WebServiceManager.webServiceHelper.fetchData(resource: resource)
                switch result {
                    case .success(let object):
                        tracks = object?.tracks ?? []
                    case .failure(let error):
                        print(error.localizedDescription)
                }
            }
        } else {
            // Fallback on earlier versions
            WebServiceManager.webServiceHelper.fetchData(resource: resource) { [weak self] result in
                guard let self else { return }
                
                DispatchQueue.main.async {
                    switch result {
                        case .success(let object):
                            self.tracks = object?.tracks ?? []
                        case .failure(let error):
                            print(error.localizedDescription)
                    }
                }
            }
        }
    }

    
    deinit {
        tracks.removeAll()
    }
}
