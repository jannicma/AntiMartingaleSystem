import Foundation
import CryptoKit

class BaseApiController {
    private var apiKey: String
    private var apiSecret: String
    private var baseUrl: String
    
    init(baseUrl: String) {
        self.apiKey = ProcessInfo.processInfo.environment["BINGX_API_KEY"] ?? ""
        self.apiSecret = ProcessInfo.processInfo.environment["BINGX_API_SECRET"] ?? ""
        self.baseUrl = baseUrl
    }
    
    public func request<T: Decodable>(endpoint: String, body: String, method: String = "GET") async throws -> T {
        let timestamp = Int(Date().timeIntervalSince1970 * 1000)
        var query = body.isEmpty ? "timestamp=\(timestamp)" : "\(body)&timestamp=\(timestamp)"
        let signature = sign(query: query)
        query += "&signature=\(signature)"
        
        guard let url = URL(string: "\(baseUrl)\(endpoint)?\(query)") else {
            throw NSError(domain: "BaseApiController", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])
        }

        var request = URLRequest(url: url)
        request.httpMethod = method
        request.addValue(apiKey, forHTTPHeaderField: "X-BX-APIKEY")
        if method != "GET" {
            request.httpBody = body.data(using: .utf8)
        }

        let (data, _) = try await URLSession.shared.data(for: request)
        return try JSONDecoder().decode(T.self, from: data)
    }
    
    private func sign(query: String) -> String {
        let key = SymmetricKey(data: Data(apiSecret.utf8))
        let signatureData = HMAC<SHA256>.authenticationCode(for: Data(query.utf8), using: key)
        let signature = signatureData.map { String(format: "%02x", $0) }.joined()
        return signature
    }
}
