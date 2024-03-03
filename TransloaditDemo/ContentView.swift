//
//  ContentView.swift
//  TransloaditDemo
//
//  Created by Julian Cheal on 03/03/2024.
//

import SwiftUI

struct ContentView: View {
  @ObservedObject var uploader: MyUploader
  @State private var importing = false
  var body: some View {
    HStack {
      Button(action: { importing = true}, label: {
        Text("Upload Files")
      })
    }
    .padding()
    .fileImporter(
        isPresented: $importing,
        allowedContentTypes: [.audio,.image],
        allowsMultipleSelection: true
    ) { result in
        do {
          uploader.upload(try result.get())
        } catch {
          // Handle failure.
          print("Unable to read file contents")
          print(error.localizedDescription)
        }
    }
  }
}
