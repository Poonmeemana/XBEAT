import SwiftUI

struct LoginView: View {
    @State private var name = ""
    @State private var age = ""
    @State private var gender = "male"

    var body: some View {
        ZStack {
            // Background to match beginningView
            LinearGradient(gradient: Gradient(colors: [
                Color(hex: "#F9FBFA"),
                Color(hex: "#CCCDD2"),
                Color(hex: "#2A3C6C")
            ]), startPoint: .top, endPoint: .bottom)
            .ignoresSafeArea()

            VStack(spacing: 40) {
                Text("Let’s Get Started")
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(.black)

                VStack(spacing: 20) {
                    // Username
                    TextField("Enter your name", text: $name)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(12)
                        .shadow(radius: 3)

                    // Age
                    TextField("Enter your age", text: $age)
                        .keyboardType(.numberPad)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(12)
                        .shadow(radius: 3)

                    // Gender
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Select Gender")
                            .font(.subheadline)
                            .foregroundColor(.gray)

                        Picker("Gender", selection: $gender) {
                            Text("Male").tag("male")
                            Text("Female").tag("female")
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        .background(Color.white)
                        .cornerRadius(8)
                    }
                }
                .padding()
                .background(Color.white.opacity(0.9))
                .cornerRadius(20)
                .shadow(radius: 6)

                NavigationLink(destination: ContentView()) {
                    HStack {
                        Image(systemName: "arrow.right.circle.fill")
                        Text("Continue")
                    }
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color(hex: "#457DFD"))
                    .cornerRadius(14)
                    .shadow(radius: 5)
                }
                .padding(.horizontal)

                Spacer()
            }
            .padding()
        }
    }
}
