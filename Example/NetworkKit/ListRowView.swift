//
//  ListRowView.swift
//  NetworkKit_Example
//
//  Created by Nileshkumar M. Prajapati on 2023/06/26.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import SwiftUI

struct ListRowView: View {
    
    //MARK: - Properties
    
    @Binding var track: Track
    
    //MARK: - Body
    
    var body: some View {
        HStack(alignment: .center, spacing: 10) {
            if #available(iOS 15.0, *) {
                AsyncImage(url: URL(string: track.img ?? "")) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 80, height: 100)
                        .cornerRadius(8)
                } placeholder: {
                    Color.gray
                }
            } else {
                // Fallback on earlier versions
                Image(systemName: "music.note.list")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 60, height: 60)
            }
            
            VStack(alignment: .leading, spacing: 5) {
                Text(track.name ?? "")
                    .font(.headline)
                    .foregroundColor(.primary)
                    .padding(.vertical)
                    .multilineTextAlignment(.leading)
                
                Text("Score: \(track.score ?? 0)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.leading)
                
                Text("TrackID: \(track.trackID ?? "")")
                    .font(.footnote)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.leading)
            }
            .padding(.horizontal)
        }
    }
}

//MARK: - Preview

struct ListRowView_Previews: PreviewProvider {
    static var previews: some View {
        @State var track: Track = Track(id: nil, uID: nil, uNm: nil, text: nil, pl: nil, name: nil, eID: nil, img: nil, nbP: nil, lov: nil, nbR: nil, score: nil, nbL: nil, prev: nil, trackID: nil, rankIncr: nil, src: nil, order: nil)
        ListRowView(track: $track)
    }
}
