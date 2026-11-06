import SwiftUI

struct beginningView: View {

    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(gradient: Gradient(colors: [Color(hex:"#F9FBFA"), Color(hex: "#CCCDD2"),Color(hex: "#2A3C6C")]),
                               startPoint: .top,
                               endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)

                VStack(spacing: 30) {
                    VStack(spacing: 8){
                        Text("XBEAT")
                            .font(.system(size: 70))
                            .fontWeight(.heavy)
                            .foregroundColor(.black)

                        Text("CREATE YOUR RUNNING PLAN")
                            .font(.system(size: 20))
                            .fontWeight(.heavy)
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                    }

                    Spacer()

                    ZStack {
                        Circle()
                            .fill(LinearGradient(gradient: Gradient(colors: [Color(hex: "#457DFD"), Color(hex: "#B3BFFB"),Color(hex: "#FFB18D")]),
                                                 startPoint: .leading,
                                                 endPoint: .trailing))
                            .frame(width: 250, height: 250)

                        Circle()
                            .frame(width: 200, height: 200)

                        Image(systemName: "figure.walk")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 140, height: 140)
                            .foregroundColor(.white)
                    }
                    Spacer()
                    NavigationLink(destination: LoginView()) {
                        Circle()
                            .fill(Color.white)
                            .frame(width: 120, height: 120)
                            .shadow(radius: 25)
                            .overlay(
                                Image(systemName: "play.fill")
                                    .foregroundColor(.black)
                                    .font(.system(size: 50))
                            )
                    }
                    Text("PLAY")
                        .font(.system(size: 30))
                        .foregroundColor(.white)
                }
            }
        }
   }
}
extension Color {
    init(hex: String) {
        let scanner = Scanner(string: hex)
        _ = scanner.scanString("#")
        var rgb: UInt64 = 0
        scanner.scanHexInt64(&rgb)

        let r = Double((rgb >> 16) & 0xFF) / 255
        let g = Double((rgb >> 8) & 0xFF) / 255
        let b = Double(rgb & 0xFF) / 255
        self.init(red: r, green: g, blue: b)
    }
}
