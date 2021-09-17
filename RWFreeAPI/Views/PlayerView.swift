import SwiftUI
import AVKit

struct PlayerView: View {
    let episode: Episode
    @State private var showPlayer = false
    @Environment(\.verticalSizeClass) var vSizeClass
    
    private func height9(to16 width: CGFloat) -> CGFloat {
        return (width - 20.0) * 9.0 / 16.0
    }
    
    var body: some View {
        if let url = URL(string: episode.videoURL?.urlString ?? "") {
            GeometryReader { proxy in
                VStack {
                    VideoPlayer(player: AVPlayer(url: url))
                        .frame(
                            maxHeight: vSizeClass == .regular ?
                                height9(to16: proxy.size.width) : .infinity)
                        .padding(15)
                        .roundedGradientBackground()
                    
                    if vSizeClass == .regular {
                        VStack(spacing: 16) {
                            Text(episode.name)
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(Color(UIColor.label))
                            HStack(spacing: 15) {
                                Text(episode.released)
                                Text(episode.domain)
                                Text(String(episode.difficulty ?? "").capitalized)
                            }
                            Text(episode.description)
                                .padding(.horizontal)
                        }
                        .foregroundColor(Color(UIColor.systemGray))
                    }
                    Spacer()
                }
                .navigationTitle(episode.name)
                .navigationBarTitleDisplayMode(.inline)
            }
        } else {
            PlaceholderView()
        }
    }
}

struct PlayView_Previews: PreviewProvider {
    static var previews: some View {
        let store = EpisodeStore()
        Group {
            NavigationView {
                PlayerView(episode: store.episodes[0])
            }
            .navigationViewStyle(StackNavigationViewStyle())
            
            PlayerView(episode: store.episodes[0])
                .previewLayout(.fixed(width: 896.0, height: 414.0))
        }
    }
}

extension View {
    func roundedGradientBackground() -> some View {
        self
            .background(
                LinearGradient(
                    gradient: Gradient(
                        colors: [Color.gradientDark, Color.gradientLight]),
                    startPoint: .leading,
                    endPoint: .trailing)
            )
            .cornerRadius(15, corners: [.bottomLeft, .bottomRight])
    }
}

struct PlaceholderView: View {
    var body: some View {
        VStack {
            Text("""
        Placeholder episode
        No video
        """)
                .font(.title)
                .multilineTextAlignment(.center)
                .padding(15)
                .roundedGradientBackground()
            Spacer()
        }
    }
}
