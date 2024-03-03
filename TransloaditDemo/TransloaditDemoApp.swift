//
//  TransloaditDemoApp.swift
//  TransloaditDemo
//
//  Created by Julian Cheal on 03/03/2024.
//

import SwiftUI
import TransloaditKit

final class MyUploader: ObservableObject {
  let transloadit: Transloadit

  func upload(_ urls: [URL]) {
    transloadit.createAssembly(templateId: "", andUpload: urls) { result in
      switch result {
        case .success(let assembly):
          print("Retrieved \(assembly)")
        case .failure(let error):
          print("Assembly error \(error)")
      }
    }.pollAssemblyStatus { result in
      switch result {
        case .success(let assemblyStatus):
          print("Received assemblystatus \(assemblyStatus)")
        case .failure(let error):
          print("Caught polling error \(error)")
      }
    }
  }

  init() {
    let credentials = Transloadit.Credentials(key: "", secret: "")
    self.transloadit = Transloadit(credentials: credentials, session: URLSession.shared)
    self.transloadit.fileDelegate = self
  }
}

extension MyUploader: TransloaditFileDelegate {
  func progressFor(assembly: Assembly, bytesUploaded: Int, totalBytes: Int, client: Transloadit) {
    print("Progress for \(assembly) is \(bytesUploaded) / \(totalBytes)")
  }

  func totalProgress(bytesUploaded: Int, totalBytes: Int, client: Transloadit) {
    print("Total bytes \(totalBytes)")
  }

  func didErrorOnAssembly(errror: Error, assembly: Assembly, client: Transloadit) {
    print("didErrorOnAssembly")
  }

  func didError(error: Error, client: Transloadit) {
    print("didError")
  }

  func didCreateAssembly(assembly: Assembly, client: Transloadit) {
    print("didCreateAssembly \(assembly)")
  }

  func didFinishUpload(assembly: Assembly, client: Transloadit) {
    print("didFinishUpload")

    transloadit.fetchStatus(assemblyURL: assembly.url) { result in
      print("status result \(result)")
    }
  }

  func didStartUpload(assembly: Assembly, client: Transloadit) {
    print("didStartUpload")
  }
}

@main
struct TransloaditDemoApp: App {
  @ObservedObject var uploader: MyUploader

  init() {
    self.uploader = MyUploader()
  }

  var body: some Scene {
    WindowGroup {
      ContentView(uploader: uploader)
    }
  }
}
