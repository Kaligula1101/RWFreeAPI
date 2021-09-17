import SwiftUI

@main
struct RWFreeAPIApp: App {
    @StateObject private var store = EpisodeStore()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(store)
        }
    }
}
