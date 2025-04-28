import Foundation

struct Capsule: Codable {
    let id: Int?
    let email: String
    let subject: String
    let text: String
    let send_date: String
    let status: String?
    let attachment: String?
}

class APIService {
    static let shared = APIService()
    private init() {}
    
    private let baseURL = "https://time-capsule-app.onrender.com/capsules/"

    func createCapsule(capsule: Capsule, completion: @escaping (Result<Capsule, Error>) -> Void) {
        guard let url = URL(string: baseURL) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let jsonData = try JSONEncoder().encode(capsule)
            request.httpBody = jsonData
        } catch {
            completion(.failure(error))
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let data = data else { return }
            do {
                let newCapsule = try JSONDecoder().decode(Capsule.self, from: data)
                completion(.success(newCapsule))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }

    func fetchCapsules(completion: @escaping (Result<[Capsule], Error>) -> Void) {
        guard let url = URL(string: baseURL) else { return }
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let data = data else { return }
            do {
                let capsules = try JSONDecoder().decode([Capsule].self, from: data)
                completion(.success(capsules))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}
