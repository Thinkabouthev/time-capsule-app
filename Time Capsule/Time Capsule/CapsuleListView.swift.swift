import SwiftUI

struct CapsuleListView: View {
    @State private var capsules: [CapsuleModel] = []

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text("Your Capsules")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding()

                ForEach(capsules, id: \.id) { capsule in
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(capsule.subject)
                                    .font(.headline)
                                Text(capsule.text)
                                    .font(.subheadline)
                                Text("To: \(capsule.email)")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                                Text("Send on: \(capsule.send_date)")
                                    .font(.caption2)
                                    .foregroundColor(.gray)
                                Text("Status: \(capsule.status)")
                                    .font(.caption2)
                                    .foregroundColor(capsule.status == "pending" ? .orange : .green)
                            }
                            Spacer()
                            Button(action: {
                                deleteCapsule(id: capsule.id)
                            }) {
                                Image(systemName: "trash")
                                    .foregroundColor(.red)
                            }
                        }
                        Divider()
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                    .shadow(radius: 1)
                    .padding(.horizontal)
                }
            }
        }
        .onAppear {
            fetchCapsules()
        }
        .background(Color(.systemGray6))
    }

    func fetchCapsules() {
        guard let url = URL(string: "https://time-capsule-app.onrender.com/api/capsules/") else { return }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                if let decodedResponse = try? JSONDecoder().decode([CapsuleModel].self, from: data) {
                    DispatchQueue.main.async {
                        self.capsules = decodedResponse
                    }
                }
            }
        }.resume()
    }

    func deleteCapsule(id: Int) {
        guard let url = URL(string: "https://time-capsule-app.onrender.com/api/capsules/\(id)/") else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"

        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                self.capsules.removeAll { $0.id == id }
            }
        }.resume()
    }
}

struct CapsuleModel: Codable {
    var id: Int
    var email: String
    var subject: String
    var text: String
    var send_date: String
    var status: String
}
