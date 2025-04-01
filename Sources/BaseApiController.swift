import Foundation
import CryptoKit

actor BaseApiController {
    private var apiKey: String
    private var apiSecret: String
    let baseURL = "https://open-api.bingx.com"

    init(baseUrl: String) {
        self.apiKey = ProcessInfo.processInfo.environment["BINGX_API_KEY"] ?? ""
        self.apiSecret = ProcessInfo.processInfo.environment["BINGX_API_SECRET"] ?? ""
    }
    
    func sendRequest(endpoint: String, method: String, parameters: [String: String], isPrivate: Bool) async throws -> Data {
        var params = parameters
        params["timestamp"] = String(Int(Date().timeIntervalSince1970 * 1000))
        
        if isPrivate {
            let signature = generateSignature(parameters: params)
            params["signature"] = signature
        }
        
        let urlString = baseURL + endpoint
        guard var urlComponents = URLComponents(string: urlString) else {
            throw URLError(.badURL)
        }
        
        if method.uppercased() == "GET" {
            urlComponents.queryItems = params.map { URLQueryItem(name: $0.key, value: $0.value) }
        }
        
        guard let url = urlComponents.url else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.uppercased()
        
        if isPrivate {
            request.addValue(apiKey, forHTTPHeaderField: "X-BX-APIKEY")
        }
        
        if method.uppercased() == "POST" {
            request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            let bodyString = params.map { "\($0.key)=\($0.value)" }.joined(separator: "&")
            request.httpBody = bodyString.data(using: .utf8)
        }
        
        let (data, _) = try await URLSession.shared.data(for: request)
        return data
    }
    
    
    private func generateSignature(parameters: [String: String]) -> String {
        let sortedKeys = parameters.keys.sorted()
        let paramString = sortedKeys.map { key in
            "\(key)=\(parameters[key]!)"
        }.joined(separator: "&")
        let data = Data(paramString.utf8)
        let keyData = Data(apiSecret.utf8)
        let hmac = HMAC<SHA256>.authenticationCode(for: data, using: SymmetricKey(data: keyData))
        return Data(hmac).map { String(format: "%02hhx", $0) }.joined()
    }
}
