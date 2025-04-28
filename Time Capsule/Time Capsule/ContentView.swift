import SwiftUI
import PhotosUI

struct ContentView: View {
    @State private var email = ""
    @State private var subject = ""
    @State private var message = ""
    @State private var sendDate = Date()
    @State private var selectedPhoto: PhotosPickerItem? = nil
    @State private var selectedPhotoData: Data? = nil

    var body: some View {
        NavigationView {
            VStack(spacing: 16) {
                Spacer().frame(height: 40)

                Text("Welcome to Time Capsule!")
                    .font(.title)
                    .fontWeight(.semibold)
                    .multilineTextAlignment(.center)

                TextField("Enter subject", text: $subject)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)

                TextField("Enter recipient's email", text: $email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)

                ZStack(alignment: .topLeading) {
                    if message.isEmpty {
                        Text("Enter your message here...")
                            .foregroundColor(.gray)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 12)
                    }
                    TextEditor(text: $message)
                        .padding(10)
                }
                .frame(height: 150)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                )
                .padding(.horizontal)

                DatePicker("Send date:", selection: $sendDate, displayedComponents: [.date, .hourAndMinute])
                    .padding()

                PhotosPicker(selection: $selectedPhoto, matching: .images, photoLibrary: .shared()) {
                    Text("Select Photo")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(8)
                        .padding(.horizontal)
                }
                .onChange(of: selectedPhoto) {
                    Task {
                        if let data = try? await selectedPhoto?.loadTransferable(type: Data.self) {
                            selectedPhotoData = data
                        }
                    }
                }

                Button(action: {
                    sendCapsule()
                }) {
                    Text("Send Capsule")
                        .bold()
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .padding(.horizontal)
                
                NavigationLink(destination: CapsuleListView()) {
                    Text("View Capsules")
                }
                .padding()
                .background(Color.green)
                .foregroundColor(.white)
                .cornerRadius(8)

                Spacer()
            }
            .navigationTitle("")
            .navigationBarHidden(true)
        }
    }
    

    func sendCapsule() {
        print("Sending capsule with:")
        print("Email: \(email)")
        print("Subject: \(subject)")
        print("Message: \(message)")
        print("Send date: \(sendDate)")
        guard let url = URL(string: "https://time-capsule-app.onrender.com/api/capsules/") else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"

        let boundary = UUID().uuidString
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        var body = Data()

        func appendFormField(name: String, value: String) {
            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"\(name)\"\r\n\r\n".data(using: .utf8)!)
            body.append("\(value)\r\n".data(using: .utf8)!)
        }

        appendFormField(name: "email", value: email)
        appendFormField(name: "subject", value: subject)
        appendFormField(name: "text", value: message)
        appendFormField(name: "send_date", value: ISO8601DateFormatter().string(from: sendDate))
        appendFormField(name: "status", value: "pending")

        if let photoData = selectedPhotoData {
            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"attachment\"; filename=\"photo.jpg\"\r\n".data(using: .utf8)!)
            body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
            body.append(photoData)
            body.append("\r\n".data(using: .utf8)!)
        }

        body.append("--\(boundary)--\r\n".data(using: .utf8)!)
        request.httpBody = body

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error sending capsule: \(error)")
            } else {
                print("Capsule sent successfully!")
            }
            if let error = error {
                print("HTTP request failed: \(error.localizedDescription)")
            } else if let httpResponse = response as? HTTPURLResponse {
                print("HTTP response status: \(httpResponse.statusCode)")
            }
        }.resume()
    }
}
